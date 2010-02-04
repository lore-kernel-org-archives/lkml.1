Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0BDROL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:14:11 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:44031 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0BDROJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:14:09 -0500
Date: Thu, 4 Feb 2010 11:13:15 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Nick Piggin <npiggin@suse.de>
cc: Dave Chinner <david@fromorbit.com>, tytso@mit.edu,
       Andi Kleen <andi@firstfloor.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
In-Reply-To: <20100204093350.GE13318@laptop>
Message-ID: <alpine.DEB.2.00.1002041109500.28165@router.home>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org> <20100131135933.GM15853@discord.disaster> <alpine.DEB.2.00.1002030920500.5671@router.home>
 <20100204003410.GD5332@discord.disaster> <20100204030736.GB25885@thunk.org> <20100204033911.GE5332@discord.disaster> <20100204093350.GE13318@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Nick Piggin wrote:

> Well what I described is to do the slab pinning from the reclaim path
> (rather than from slab calling into the subsystem). All slab locking
> basically "innermost", so you can pretty much poke the slab layer as
> much as you like from the subsystem.

Reclaim/defrag is called from the reclaim path (of the VM). We could
enable a call from the fs reclaim code into the slab. But how would this
work?

> After that, LRU on slabs should be fairly easy. Slab could provide a
> private per-slab pointer for example that is managed by the caller.
> Subsystem can then call into slab to find the objects.

Sure with some minor changes we could have a call that is giving you the
list of neighboring objects in a slab, while locking it? Then you can look
at the objects and decide which ones can be tossed and then do another
call to release the objects and unlock the slab.



