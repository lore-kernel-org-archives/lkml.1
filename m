Return-Path: <linux-kernel-owner+w=401wt.eu-S935514AbYCDXff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935514AbYCDXff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935464AbYCDXdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:33:17 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:9988 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934976AbYCDXdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:33:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rFHUta1Ylx2s1OGfesf9BFqxpRnBwk3yoxKkCSI8UarjOTU35m6z7GWWCkg0yl7n9PJglXpcK3692wanxVIfaUbUU/1sZTfUEU4cKQv059xcfm1YXfPRfs9y2c+lg4kFa5syNGumMF6f3IsfENusnffU7tMvTJ8TIl6elLbQ33Q=
Message-ID: <47CDDC31.4070806@gmail.com>
Date: Wed, 05 Mar 2008 08:33:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp,
       James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47CD53BA.5040908@gmail.com>	<47CD7611.2030606@gmail.com>	<47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org>
In-Reply-To: <20080305041914V.tomof@acm.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> Hmm, does SCSI mid-layer need to care about how many bytes the block
> layer allocates? I don't think that extra_len is NOT good_bytes.
> 
> I think that the block layer had better take care about it (fix
> __end_that_request_first?).

Yeah, probably calling completion functions w/o bytes count is the right
thing to do but what I was talking about was what could break when the
semantics of rq->data_len changed.  If we keep rq->data_len() ==
sum(sg), we keep it business as usual for all the rest except for the
device application layer if we don't we do the reverse and SCSI midlayer
completion was a good example, I think.

Things going the other way is fine with me but I at least want to hear a
valid rationale.  Till now all I got is "because that's the true size"
which doesn't really make much sense to me.

Thanks.

-- 
tejun
