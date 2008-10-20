Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbYJTXEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbYJTXEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYJTXEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:04:31 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:57846 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578AbYJTXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:04:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAM8S9kh5LE2t/2dsb2JhbADCJoFr
X-IronPort-AV: E=Sophos;i="4.33,454,1220193000"; 
   d="scan'208";a="214601453"
Date: Tue, 21 Oct 2008 10:04:20 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, penberg@cs.helsinki.fi,
       nickpiggin@yahoo.com.au, hugh@veritas.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
Message-ID: <20081020230420.GC21152@disturbed>
Mail-Followup-To: Christoph Lameter <cl@linux-foundation.org>,
	Miklos Szeredi <miklos@szeredi.hu>, penberg@cs.helsinki.fi,
	nickpiggin@yahoo.com.au, hugh@veritas.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <E1KpOOL-0003Vf-9y@pomaz-ex.szeredi.hu> <48F378C6.7030206@linux-foundation.org> <E1KpOjX-0003dt-AY@pomaz-ex.szeredi.hu> <48FC9CCC.3040006@linux-foundation.org> <E1Krz4o-0002Fi-Pu@pomaz-ex.szeredi.hu> <48FCCC72.5020202@linux-foundation.org> <E1KrzgK-0002QS-Os@pomaz-ex.szeredi.hu> <48FCD7CB.4060505@linux-foundation.org> <E1Ks0QX-0002aC-SQ@pomaz-ex.szeredi.hu> <48FCE1C4.20807@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FCE1C4.20807@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 02:53:40PM -0500, Christoph Lameter wrote:
> Miklos Szeredi wrote:
> > Case below was brainfart, please ignore.  But that doesn't really
> > help: the VFS assumes that you cannot umount while there are busy
> > dentries/inodes.  Usually it works this way: VFS first gets vfsmount
> > ref, then gets dentry ref, and releases them in the opposite order.
> > And umount is not allowed if vfsmount has a non-zero refcount (it's a
> > bit more complicated, but the essense is the same).
> 
> The dentries that we get a ref on are candidates for removal. Their lifetime
> is limited. Unmounting while we are trying to remove dentries/inodes results
> in two mechanisms removing dentries/inodes.
> 
> If we have obtained a reference then invalidate_list() will return the number
> of busy inodes which would trigger the printk in generic_shutdown_super(). But
> these are inodes currently being reclaimed by slab defrag. Just waiting a bit
> would remedy the situation.
> 
> We would need some way to make generic_shutdown_super() wait until slab defrag
> is finished.

Seems to me that prune_dcache() handles this case by holding the sb->s_umount
semaphore while pruning. The same logic applies here, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
