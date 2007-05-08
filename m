Return-Path: <linux-kernel-owner+w=401wt.eu-S967391AbXEHNlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967391AbXEHNlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967325AbXEHNle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:41:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:15526 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966235AbXEHNld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AsHYXnCaQleuzA5OhRRd7uh/9geq7WvW4yZVGYhfijIer397V4Rf67ka8qApJmrBzn1l+hAo+XS3zNZuSAAzRFrcv3Weuiqnc74o0Xu8J2ljOd5zQRnoDdjAJbUAIoyry3EA7GUDE6JdslyTZb7fBaNuxMNUWoRWbdmneEqnwA8=
Message-ID: <46407D75.7050603@gmail.com>
Date: Tue, 08 May 2007 15:39:01 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Andrew Morton <akpm@osdl.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
References: <464045F0.3040906@gmail.com> <20070508103524.GH4163@kernel.dk>
In-Reply-To: <20070508103524.GH4163@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2007 12:35 PM, Jens Axboe wrote:

Thanks very much for the prompt answer!

> bio[n - 1].bi_sector + bio_sectors(bio[n - 1]) == bio[n].bi_sector
> 
> IOW, the bio's in the chain on the request are contig in the lba space.

Okay great, thanks, everything fine then.

> Yeah, I think it's pointless to support highmem. And as long as you
> don't call blk_queue_bounce_limit() to actively enable highmem, you are
> not going to receive a bio/request with highmem pages.

Yep, the driver is setting BLK_BOUNCE_ANY.

> The block layer wil bounce any highmem pages before it reaches you. So
> for a driver like this, I would recommend just forgetting the mapping
> aspect.

Okay, I agree highmem doesn't make any practical sense for this driver but 
I'm not really sure what it would gain. if !CONFIG_HIGHMEM the bvec_kmap_irq 
turns info "(page_address((bvec)->bv_page) + (bvec)->bv_offset)" directly 
anyway. I am a bit unsure about it all but it's not the case that we can 
then leave out the entire bio_for_each_segnment() loop is it?

(generic kernels with HIGHMEM enabled are I guess an argument...)

> I don't have time to review your driver right now, but I will applaud
> your effort to write a maintenable mitsumi driver! Basically all the old
> cdrom drivers are utter crap, so they are destined for removal.

I noticed by the way there was a bit too much emphasis on the "I" in this 
message; it's in fact Pekka Enberg who  started this and did the core stuff!

Yes ,the current legacy CD-ROM drivers really are complete crap by now. Once 
this mitsumi driver is in final shape it should serve as a nice template for 
the few other types that I'd like to keep supported and the rest can just go.

Thanks again for the prompt comments.

Rene.

