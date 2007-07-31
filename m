Return-Path: <linux-kernel-owner+w=401wt.eu-S1763342AbXGaRRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763342AbXGaRRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbXGaRQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:16:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46861 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbXGaRQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:16:56 -0400
Date: Tue, 31 Jul 2007 13:16:44 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Mark Williamson <mark.williamson@cl.cam.ac.uk>
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070731171644.GB27234@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <200707311803.08698.mark.williamson@cl.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707311803.08698.mark.williamson@cl.cam.ac.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 06:03:06PM +0100, Mark Williamson wrote:
> > Really the only sane way of keeping track of whiteouts seems some external
> > store. We did an experiment with Unionfs, and moving the whiteout handling
> > to effectively a "library" that did all the dirty work cleaned up the code
> > considerably [2,3].
> 
> What about keeping track of whiteouts in a special file (or files) in the top 
> level filesystem of the union?  For instance, having a /.whiteouts file at 
> the root of the top FS in the stack, instead of storing union-specific data 
> in the flags / inode numbers of the lower levels.
 
What is needed is a "filesystem" that has all the directory bits only. For
ODF, we opted to "abuse" existing filesystems to see if it actually helped
Unionfs, and I think it did help. Really, now what we (unionfs) need is a
cleanup of the ODF code, with a bit better defined interface.

...
> This might avoid requiring a store external to the stack of filesystems and I 
> believe it would solve the problem with shared branches and arbitrary 
> stacking that you described?

We generally did a loopback mount on a file. Very similar to your idea.

> I guess a rather similar effect could be had by somehow storing loopback 
> mountable ODF filesystems in the top layer of a union somewhere (e.g. with 
> the default path /.odf) and allowing the user to specify an alternate 
> location at mount time if necessary.  So maybe these approaches are quite 
> similar after all...

Very :) We forced the user to mount the fs in the odf loopback manually, but
there's no reason why we couldn't do an in-kernel mount on unionfs mount
time.

Josef 'Jeff' Sipek.

-- 
Once you have their hardware. Never give it back.
(The First Rule of Hardware Acquisition)
