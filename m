Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbZFMO0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbZFMO0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZFMO0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:26:07 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:46445 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761568AbZFMO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BFsz+VUxd+ZxsqhcXGVi1eZ1ILyKgDWIaHALL1nzCmQ0DjO/TeMeXW067jj66Zx3T6
         1ayoEwu9F6zxBep1VLmEfq1yWYX2HgORGsvzIR+HRhg0C3sxH8ckYkFl+Zeh7jYr3Yx3
         b0e2UHQMQisRomMi4vrqsO6DoVityIz5dpHOU=
MIME-Version: 1.0
In-Reply-To: <20090613111014.GA18638@8bytes.org>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp>
	 <20090605104132.GE24836@amd.com>
	 <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com>
	 <20090611081032.GN5139@amd.com>
	 <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
	 <20090612141346.GY5139@amd.com>
	 <64bb37e0906120751u14cac347hfa2356372e1e0a6a@mail.gmail.com>
	 <20090613111014.GA18638@8bytes.org>
Date: Sat, 13 Jun 2009 16:26:06 +0200
Message-ID: <64bb37e0906130726i7b6ac33dma25e17c72cca54dd@mail.gmail.com>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com,
       bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 1:10 PM, Joerg Roedel<joro@8bytes.org> wrote:
> On Fri, Jun 12, 2009 at 04:51:01PM +0200, Torsten Kaiser wrote:
>> On Fri, Jun 12, 2009 at 4:13 PM, Joerg Roedel<joerg.roedel@amd.com> wrote:
>> > On Thu, Jun 11, 2009 at 07:38:47PM +0200, Torsten Kaiser wrote:
>> >> DMA-API: device driver tries to free DM
>> >> A memory it has not allocated [device address=0x000000011e4c3000]
>> >> [size=4096 bytes]
>> >
>> > Hmm, looking again over the code I've seen that the ref
>> > dma_debug_entries are not alway filled with all necessary information
>> > for best-fit. Can you please try if you still get false warnings when
>> > you apply the two patches attached instead of the one I sent yesterday?
>>
>> Hmm... There isn't a get_nr_mapped_entries() in 2.6.30.
>> Are these patches again the current linus tree?
>
> Indeed. These patches are against tip/core/iommu but should also apply
> against current linus/master too.

OK, I will try 2.6.30-git6 with and without these patches.

>> For unfilled information I wanted to complain that for non-sg mapping
>> sg_call_ents never gets filled. But as dma_entry_alloc() does a
>> memset() to clean the entrys it should not matter.
>> And what about dma_debug_entry.paddr? Should this also be compared?
>
> paddr shouldn't matter. We also can't compare against it because it is
> not a parameter we get in the unmap path (not always).

check_unmap() checks it and sg_call_ents are also optional.

Torsten
