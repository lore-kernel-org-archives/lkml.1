Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYCFFDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYCFFDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 00:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYCFFDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 00:03:11 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:12546 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYCFFDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 00:03:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lqmh3MAE+Okx6HQB8wYNajgiRdBKcgNJzIKe2w5F0F6H2x82Ik8Tw8iNXl4gQQvDgi+Ytfrvy3EwmX2CycsqlZ7vBfs7vDp3W95yYsZIqoXUJOwe14QW33VP2uZTXview9pMC5XMC785s+toXuZHrQ7g8egE0CbrtWpFQ7xKZ4g=
Message-ID: <47CF7AFA.8060305@gmail.com>
Date: Thu, 06 Mar 2008 14:02:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: tomof@acm.org, efault@gmx.de, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47CDDC31.4070806@gmail.com>	<20080305092619Y.fujita.tomonori@lab.ntt.co.jp>	<47CDECD1.6070601@gmail.com> <20080306135627P.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080306135627P.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, FUJITA.

FUJITA Tomonori wrote:
>>>> Things going the other way is fine with me but I at least want to hear a
>>>> valid rationale.  Till now all I got is "because that's the true size"
>>>> which doesn't really make much sense to me.
>>> Most of users of request structure care about only the real data
>>> length, don't care about padding and drain length. Why do they bother
>>> to use a helper function to get the real data length?
>> I think this is where the difference comes from.  To me it seems
>> internal usage seems more wide-spread and more delicate and not too many
>> care about the true size and when they do only in well defined places.
>> Maybe it comes from the difference between your most and my most.
> 
> I don't think that they only in well defined places.
> 
> If you see scsi mid-layer (and LLDs), you can find several places that
> use rq->data_len as the true data length.
> 
> Breaking rq->data_len == the true data length theoretically
> wrong. Even if it affects only libata now, it will hurt us, I think.

Yeap, I fully agree it's much better not to break any of the two
assumptions except when it's actually needed.  Both padding and draining
are requirements from low level driver which usually stems from hardware
kinkiness, so adjusting sg and length there and let the rest of system
not care about it sounds like a good idea to me.  Maybe something good
can come out of this long thread.  :-)

Thanks.

-- 
tejun
