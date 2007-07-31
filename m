Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbXGaRAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbXGaRAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbXGaRAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:00:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:58380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577AbXGaRAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:00:19 -0400
Date: Tue, 31 Jul 2007 19:00:12 +0200
From: Jan Blunck <jblunck@suse.de>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070731170012.GN5101@hasse.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, Josef Sipek wrote:

> On Mon, Jul 30, 2007 at 06:13:35PM +0200, Jan Blunck wrote:
> > Introduce white-out support to ext2.
> 
> I think storing whiteouts on the branches is wrong. It creates all sort of
> nasty cases when people actually try to use unioning. Imagine a (no-so
> unlikely) scenario where you have 2 unions, and they share a branch. If you
> create a whiteout in one union on that shared branch, the whiteout magically
> affects the other union as well! Whiteouts are a union-level construct, and
> therefore storing them at the branch level is wrong.

So you think that just because you mounted the filesystem somewhere else it
should look different? This is what sharing is all about. If you share a
filesystem you also share the removal of objects.

> If you store whiteouts on the branches, you'll probably want readdir to not
> include them. That's relatively cheap if you have a whiteout bit in the
> inode, but I don't think filesystems should be forced to use up rather
> prescious inode bits for whiteouts/opaqueness [1].

How filesystem implement the whiteout filetype is up to them.

> Really the only sane way of keeping track of whiteouts seems some external
> store. We did an experiment with Unionfs, and moving the whiteout handling
> to effectively a "library" that did all the dirty work cleaned up the code
> considerably [2,3].

Haven't checked if you could use ODF for a generic store for filesystems that
couldn't support whiteouts. This might be an interesting idea.

> > Known Bugs:
> > - Needs a reserved inode number for white-outs
> > - S_OPAQUE isn't persistently stored
> 
> Out of curiosity, how do you keep track of opaqueness while the fs is
> mounted?

Its an inode flag (S_OPAQUE).
