Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYCCN4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYCCN4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYCCN4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:56:09 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41709 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYCCN4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:56:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jfElxQTZGsPNO30Y14GIDFZvn7oAo284EJsKc2STEeN3pgin38P8NQip/JGU9zEhljsk0pJkEuwUUg4cYlNXMTubH/1GMedmB9jtLvu3Q6ztYjTlJjb18vkUbe/MCKar/aXE2vo4kIGGGi8/R8rsedTnPPXeNK3ogugH/h+S94E=
Message-ID: <47CC036C.2060902@gmail.com>
Date: Mon, 03 Mar 2008 22:55:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47CBC309.7090106@gmail.com>	<20080303211727P.tomof@acm.org>	<47CBFF6F.4060301@gmail.com> <20080303225024J.tomof@acm.org>
In-Reply-To: <20080303225024J.tomof@acm.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>>>> FUJITA Tomonori wrote:
>>>>>>> I can't see what changing the meaning of rq->data_len (and
>>>>>>> investigating all the block drivers) gives us.
>>>>>> No matter which way you go, you change the meaning of rq->data_len and
>>>>>> you MUST inspect rq->data_len usage whichever way you go.
>>>>> The patch doens't change that rq->data_len means the true data
>>>>> length. But yeah, it breaks rq->data_len == sum(sg). So it might break
>>>>> some drivers.
>>>> Yeah, that's what I was saying.  You end up breaking one of the two
>>>> assumptions.  As sglist is getting modified for any driver if it has DMA
>>>> alignment set, whether rq->data_len is adjusted together or not, sglist
>>>> and data_len usages have to be audited.
>>> My patch (well, James' original approach) doesn't affect drivers that
>>> don't use drain buffer. rq->data_len still means the true data length
>>> and rq->data_len is equal to sum(sg) for them. So right now we need to
>>> audit only libata.
>> Your patch does change sglist for any driver which sets DMA alignment.
> 
> I overlook it. Where does it changes sglist?

At the end of blk_rq_map_user() together with data_len / extra_len
mangling or were you talking about James' original patch?

-- 
tejun
