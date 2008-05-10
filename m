Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYEJG4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYEJG4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 02:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYEJG4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 02:56:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35785 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYEJGz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 02:55:59 -0400
Date: Sat, 10 May 2008 02:55:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com
Subject: Re: [patch 15/21] Filesystem: XFS slab defragmentation
Message-ID: <20080510065554.GA26734@infradead.org>
References: <20080510030831.796641881@sgi.com> <20080510030918.159429884@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080510030918.159429884@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 08:08:46PM -0700, Christoph Lameter wrote:
> +	kmem_cache_setup_defrag(xfs_vnode_zone, get_inodes, kick_inodes);

So you're exporting get_inodes and kick_inodes just to use it in always
the same way.  Much better to have a kmem_cache_set_inode_defrag helper
and keep them static in inode.c

