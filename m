Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbYLDK1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbYLDK1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYLDK1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:27:05 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41272 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYLDK1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:27:04 -0500
Date: Thu, 4 Dec 2008 10:27:22 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Peter Zijlstra <peterz@infradead.org>
cc: edward_estabrook@agilent.com, linux-kernel@vger.kernel.org,
       hjk@linutronix.de, gregkh@suse.de, edward.estabrook@gmail.com,
       linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
In-Reply-To: <1228379942.5092.14.camel@twins>
Message-ID: <Pine.LNX.4.64.0812041026340.6340@blonde.anvils>
References: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com>
 <1228379942.5092.14.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2008, Peter Zijlstra wrote:
> On Wed, 2008-12-03 at 14:39 -0700, edward_estabrook@agilent.com wrote:
> > 
> > The gist of this implementation is to overload uio's mmap
> > functionality to allocate and map a new DMA region on demand.  The
> > bus-specific DMA address as returned by dma_alloc_coherent is made
> > available to userspace in the 1st long word of the newly created
> > region (as well as through the conventional 'addr' file in sysfs).  
> > 
> > To allocate a DMA region you use the following:
> > /* Pass this magic number to mmap as offset to dynamically allocate a
> > chunk of memory */ #define DMA_MEM_ALLOCATE_MMAP_OFFSET 0xFFFFF000UL
> > ...
> > Comments appreciated!
> 
> Yuck!
> 
> Why not create another special device that will give you DMA memory when
> you mmap it? That would also allow you to obtain the physical address
> without this utter horrid hack of writing it in the mmap'ed memory.
> 
> /dev/uioN-dma would seem like a fine name for that.

I couldn't agree more.  It sounds fine as a local hack for Edward to
try out some functionality he needed in a hurry; but as something
that should enter the mainline kernel in that form - no.

Hugh
