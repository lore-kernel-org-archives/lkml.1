Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZF2WgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZF2WgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZF2Wfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:35:54 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:42246 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752119AbZF2Wfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:35:53 -0400
Date: Mon, 29 Jun 2009 18:35:49 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Eric Sandeen <sandeen@redhat.com>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Theodore Tso <tytso@mit.edu>,
       Andreas Dilger <adilger@sun.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, arjan@infradead.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       linux-ext4@vger.kernel.org
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <4A493029.40601@redhat.com>
Message-ID: <alpine.DEB.1.10.0906291834090.21956@gentwo.org>
References: <20090624150714.c7264768.akpm@linux-foundation.org> <20090625132544.GB9995@mit.edu> <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com> <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu> <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com>
 <20090625203743.GD6472@mit.edu> <20090625212628.GO3385@webber.adilger.int> <20090625220504.GG6472@mit.edu> <4A43F60D.2040801@redhat.com> <20090626011155.GI6472@mit.edu> <Pine.LNX.4.64.0906260815260.18724@melkki.cs.Helsinki.FI> <4A44DE14.2080403@redhat.com>
 <alpine.DEB.1.10.0906291714520.21956@gentwo.org> <4A493029.40601@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Eric Sandeen wrote:

> > Isnt the problem that the slab allocator did not align something that
> > you did not request to be aligned?
>
> Well, maybe that's all I needed.  At the risk of exposing myself to
> ridicule, here's the commit:
>
> 7fcba054373d5dfc43d26e243a5c9b92069972ee
>
> Was there a better way?

No. Good patch. Indeed the right way. Page allocations come from the page
allocator not from the slab allocator (yes yes there are still issues with
the performance of the page allocator that sometimes dictate the use of
the slabs but in general I think this is what is needed).

