Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbXLZL3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbXLZL3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbXLZL2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:28:36 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:31140 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbXLZL2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:28:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gM2JTEdUSs9ByA8v+nuWZxMppBhwkuAeN5TwKU2eDqVld6ilOaTyXfNd8hNXi6uBp+S6Z7CoPSUyO0pwbjBZd9kGDRFl6nUD8pnOiLXr05qu+NOirqiwGgvrRVroiN76b32pCzUcohRo3AaAbsiFIM/ivi0GI0Veoc4nfPQOZHg=
Message-ID: <47721294.7030401@gmail.com>
Date: Wed, 26 Dec 2007 17:36:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 7/7] sg_ring: convert core ATA code to sg_ring.
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191836.06769.rusty@rustcorp.com.au> <200712191837.04697.rusty@rustcorp.com.au> <200712191838.27363.rusty@rustcorp.com.au>
In-Reply-To: <200712191838.27363.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty Russell.

Rusty Russell wrote:
> ATA relies so heavily on scsi that it needs to be converted at the
> same time.
> 
> ATA adds padding to scatterlists in scsi commands, but because there was
> no good way of appending to those scatterlists, it had to use boutique
> iterators to make sure the padding is included.  With sg_ring, ATA can
> simply append an sg_ring entry with the padding, and normal iterators
> can be used.
> 
> I renamed qc->cursg to qc->cur_sg to catch all the users: they should
> now be referring to 'qc->cur_sg[qc->cursg_i]' wherever they were using
> 'qc->cursg'.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

There's pending patchset to make libata use chained sg.  Please search
for "[PATCHSET] libata: improve ATAPI data transfer handling, take #3"
on your favorite mailing archive (I'm writing this message offline so
can't give you the url at the moment).  The 11th patch in the patchset
converts libata to use chained sg and and the following ones extend it
to also chain drain sg entries.

I agree that the current chained sg isn't easy to use and it would be
nice to have some abstraction on top of it but sg_ring seems to
implement duplicate feature which is already available through sg
chaining albeit cumbersome to use.

It would be better to build upon sg chaining as we already have it.  I
think it can be made much easier with a bit more safe guards,
generalization and some helpers.

Thanks.

(PS, I haven't followed the sg chaining discussion.  Why is sg chaining
an optional feature?  Performance overhead on low end machines?)

-- 
tejun

