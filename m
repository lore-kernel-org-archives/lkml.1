Return-Path: <linux-kernel-owner+w=401wt.eu-S1763171AbZFLOvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763171AbZFLOvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758918AbZFLOvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:51:02 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33004 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZFLOvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:51:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mNZDtkmToMblrlIqgm+CpWFqnEj6NmEkeIgPHlrrWZ7xIRS913p5M9a5eu4gQD/dRx
         QdoxldgzFBHGioHgpJjA0DwHaivzRvEr5e8yDM9jjwp66k4oaMQ4omcJDNS5YNL1Ncna
         lG/QB3os2+2E9kzWhL7dvZms3C821O8lx2D0E=
MIME-Version: 1.0
In-Reply-To: <20090612141346.GY5139@amd.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
	 <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com>
	 <20090611081032.GN5139@amd.com>
	 <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
	 <20090612141346.GY5139@amd.com>
Date: Fri, 12 Jun 2009 16:51:01 +0200
Message-ID: <64bb37e0906120751u14cac347hfa2356372e1e0a6a@mail.gmail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com,
       bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 4:13 PM, Joerg Roedel<joerg.roedel@amd.com> wrote:
> On Thu, Jun 11, 2009 at 07:38:47PM +0200, Torsten Kaiser wrote:
>> DMA-API: device driver tries to free DM
>> A memory it has not allocated [device address=0x000000011e4c3000]
>> [size=4096 bytes]
>
> Hmm, looking again over the code I've seen that the ref
> dma_debug_entries are not alway filled with all necessary information
> for best-fit. Can you please try if you still get false warnings when
> you apply the two patches attached instead of the one I sent yesterday?

Hmm... There isn't a get_nr_mapped_entries() in 2.6.30.
Are these patches again the current linus tree?

For unfilled information I wanted to complain that for non-sg mapping
sg_call_ents never gets filled. But as dma_entry_alloc() does a
memset() to clean the entrys it should not matter.
And what about dma_debug_entry.paddr? Should this also be compared?

Torsten
