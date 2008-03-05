Return-Path: <linux-kernel-owner+w=401wt.eu-S1765531AbYCEAoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765531AbYCEAoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757228AbYCEAoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:44:11 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:8105 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYCEAoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:44:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hGS9/8UHLPct+lVYDTQWLukP7OwpZzCQpldmkMrKdg5yvwpL2srcSgrqQGWStY/HcI6cNhOjQNo2csB/bfUI9TuPTHtgk+fr7nH7VPR8bsIoDYZcXJOF/kGipX613riTY+1FusklaSVG+4MmZGLTU0jzLdn6npAjcRnn/HAPpZo=
Message-ID: <47CDECD1.6070601@gmail.com>
Date: Wed, 05 Mar 2008 09:44:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: tomof@acm.org, efault@gmx.de, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47CD7C05.1080707@gmail.com>	<20080305041914V.tomof@acm.org>	<47CDDC31.4070806@gmail.com> <20080305092619Y.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080305092619Y.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

FUJITA Tomonori wrote:
> sglist is a low-level I/O representation for device drivers. SCSI
> midlayer should not care about sglist. We should not fix SCSI midlayer
> for rq->data_len != sum(sg) change (so I can't agree with your
> diagrams in another mail).

But that's not the way things currently are.

> When if we change a rule, we need to fix something.
> 
> If we keep rq->data_len == sum(sg), we need to fix the device
> application layer. If we keep rq->data_len == the true data length, we
> need to fix the low-level drivers.

Basically everything under block layer.

> Now I'm fine with the commit e97a294ef6938512b655b1abf17656cf2b26f709
> since we are in -rc stages. But I plan to send a patch to revert it
> and fix this issue in the block layer. I'd like to test it in -mm for
> a while.
> 
> Only sglist stuff in SCSI midlayer is scsi_req_map_sg now. As you
> know, we really want to remove it.

If the way forward is to make anything but the low level drivers not
care about sglist, in the long term, the current scheme is fine but I
still don't think this way of doing things is safe one.  We're affecting
large portion of code based on what things should be in future not what
they currently are.

>> Things going the other way is fine with me but I at least want to hear a
>> valid rationale.  Till now all I got is "because that's the true size"
>> which doesn't really make much sense to me.
> 
> Most of users of request structure care about only the real data
> length, don't care about padding and drain length. Why do they bother
> to use a helper function to get the real data length?

I think this is where the difference comes from.  To me it seems
internal usage seems more wide-spread and more delicate and not too many
care about the true size and when they do only in well defined places.
Maybe it comes from the difference between your most and my most.

Thanks.

-- 
tejun
