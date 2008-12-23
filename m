Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbYLWVdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbYLWVdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 16:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYLWVdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 16:33:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21017 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbYLWVdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 16:33:03 -0500
X-IronPort-AV: E=McAfee;i="5300,2777,5473"; a="14191144"
Message-ID: <495158F4.5090904@qualcomm.com>
Date: Tue, 23 Dec 2008 13:32:36 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       "edward_estabrook@agilent.com" <edward_estabrook@agilent.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hjk@linutronix.de" <hjk@linutronix.de>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "edward.estabrook@gmail.com" <edward.estabrook@gmail.com>,
       linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
References: <43FC624C55D8C746A914570B66D642610367F29B@cos-us-mb03.cos.agilent.com> <1228379942.5092.14.camel@twins> <Pine.LNX.4.64.0812041026340.6340@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0812041026340.6340@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 4 Dec 2008, Peter Zijlstra wrote:
>> On Wed, 2008-12-03 at 14:39 -0700, edward_estabrook@agilent.com wrote:
>>> The gist of this implementation is to overload uio's mmap
>>> functionality to allocate and map a new DMA region on demand.  The
>>> bus-specific DMA address as returned by dma_alloc_coherent is made
>>> available to userspace in the 1st long word of the newly created
>>> region (as well as through the conventional 'addr' file in sysfs).  
>>>
>>> To allocate a DMA region you use the following:
>>> /* Pass this magic number to mmap as offset to dynamically allocate a
>>> chunk of memory */ #define DMA_MEM_ALLOCATE_MMAP_OFFSET 0xFFFFF000UL
>>> ...
>>> Comments appreciated!
>> Yuck!
>>
>> Why not create another special device that will give you DMA memory when
>> you mmap it? That would also allow you to obtain the physical address
>> without this utter horrid hack of writing it in the mmap'ed memory.
>>
>> /dev/uioN-dma would seem like a fine name for that.
> 
> I couldn't agree more.  It sounds fine as a local hack for Edward to
> try out some functionality he needed in a hurry; but as something
> that should enter the mainline kernel in that form - no.

Agree with Peter and Hugh here. Also I have a use case where I need to share
DMA buffers between two or more devices. So I think we need a generic DMA
device that does operations like alloc, mmap, etc. Mmapped regions can then be
used with UIO devices.
I'll put together a prototype of that some time early next year.

Max




