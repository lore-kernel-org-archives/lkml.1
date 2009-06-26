Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZFZBMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZFZBMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 21:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZFZBMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 21:12:35 -0400
Received: from thunk.org ([69.25.196.29]:44089 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZFZBMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 21:12:34 -0400
Date: Thu, 25 Jun 2009 21:11:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andreas Dilger <adilger@sun.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de, linux-ext4@vger.kernel.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-ID: <20090626011155.GI6472@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>, Andreas Dilger <adilger@sun.com>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	penberg@cs.helsinki.fi, arjan@infradead.org,
	linux-kernel@vger.kernel.org, cl@linux-foundation.org,
	npiggin@suse.de, linux-ext4@vger.kernel.org
References: <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com> <20090625203743.GD6472@mit.edu> <20090625212628.GO3385@webber.adilger.int> <20090625220504.GG6472@mit.edu> <4A43F60D.2040801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A43F60D.2040801@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 05:11:25PM -0500, Eric Sandeen wrote:
> 
> ecryptfs used to do kmalloc(PAGE_CACHE_SIZE) & virt_to_page on that, and
> with SLUB + slub debug, that gave back non-aligned memory, causing
> eventual corruption ...

Grumble.  Any chance we could add an kmem_cache option which requires
the memory to be aligned?  Otherwise we could rewrite our own sub-page
allocator in ext4 that only handled aligned filesystem block sizes
(i.e., 1k, 2k, 4k, etc.) but that would be really silly and be extra
code that really should be done once at core functionality.

     	  	 	   	     	- Ted
