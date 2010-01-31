Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322Ab0AaIeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0AaIeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471Ab0AaIeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:34:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab0AaIeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:34:15 -0500
Date: Sun, 31 Jan 2010 09:34:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: tytso@mit.edu, Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100131083409.GF29555@one.firstfloor.org>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100130192623.GE788@thunk.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 02:26:23PM -0500, tytso@mit.edu wrote:
> On Fri, Jan 29, 2010 at 02:49:42PM -0600, Christoph Lameter wrote:
> > This implements the ability to remove inodes in a particular slab
> > from inode caches. In order to remove an inode we may have to write out
> > the pages of an inode, the inode itself and remove the dentries referring
> > to the node.
> 
> How often is this going to happen?  Removing an inode is an incredibly

The standard case is the classic updatedb. Lots of dentries/inodes cached
with no or little corresponding data cache.

> a huge number of pages that are actively getting used, the thrashing
> that is going to result is going to enormous.

I think the consensus so far is to try to avoid any inodes/dentries
which are dirty or used in any way.

I personally would prefer it to be more aggressive for memory offlining
though for RAS purposes though, but just handling the unused cases is a 
good first step.

> "invalidate_mapping_pages() will not block on I/O activity, and it
> will refuse to invalidate pages which are dirty, locked, under
> writeback, or mapped into page tables."

I think that was the point.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
