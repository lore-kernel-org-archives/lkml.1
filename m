Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZFYWMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZFYWMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 18:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZFYWMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 18:12:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60369 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZFYWMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 18:12:19 -0400
Message-ID: <4A43F60D.2040801@redhat.com>
Date: Thu, 25 Jun 2009 17:11:25 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de, linux-ext4@vger.kernel.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
References: <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain> <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain> <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com> <20090625203743.GD6472@mit.edu> <20090625212628.GO3385@webber.adilger.int> <20090625220504.GG6472@mit.edu>
In-Reply-To: <20090625220504.GG6472@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Jun 25, 2009 at 11:26:28PM +0200, Andreas Dilger wrote:
>> IIRC there was also a good reason for this in the past, related to
>> the buffers being submitted to the block device layer, and if they
>> were allocated from the slab cache with CONFIG_DEBUG_SLAB or something
>> similar enabled the buffer would be misaligned and cause grief.
> 
> So what does SLAB/SLUB/SLOB do if we create a slab cache which is a
> power of two?  Can one of the allocators still return misaligned
> blocks of memory in some circumstances?
> 
> 						- Ted

ecryptfs used to do kmalloc(PAGE_CACHE_SIZE) & virt_to_page on that, and
with SLUB + slub debug, that gave back non-aligned memory, causing
eventual corruption ...

-Eric

