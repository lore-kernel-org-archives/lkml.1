Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbXHBLzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbXHBLzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbXHBLzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:55:39 -0400
Received: from ns1.suse.de ([195.135.220.2]:33209 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbXHBLzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:55:38 -0400
Date: Thu, 2 Aug 2007 13:55:34 +0200
From: Jan Blunck <jblunck@suse.de>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070802115534.GX5101@hasse.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731163656.GC22350@filer.fsl.cs.sunysb.edu> <20070731170012.GN5101@hasse.suse.de> <20070731171159.GA27234@filer.fsl.cs.sunysb.edu> <1185981810.18007.14.camel@kleikamp.austin.ibm.com> <20070801184405.GA18405@filer.fsl.cs.sunysb.edu> <1185995431.18007.24.camel@kleikamp.austin.ibm.com> <20070801193330.GA20928@filer.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801193330.GA20928@filer.fsl.cs.sunysb.edu>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, Josef Sipek wrote:

> This brings up an very interesting (but painful) question...which makes more
> sense? Allowing the modifications in only the top-most branch, or any branch
> (given the user allows it at mount-time)?

My implementation is keeping things simple because of reason. There have been
many attempts to get unioning working on the filesystem layer. Most of them
failed because of complexity. E.g. BSD throwed away all of the filesystem
stacking support after they tried to fix unionfs for years. Writing to lower
layers is making things unnecessary complex. Therefore I left it out.

> > > 1) "cp -r" the entire subtree being renamed to highest-priority branch, and
> > > rename there (you might have to recreate a series of directories to have a
> > > place to "cp" to...so you got "cp -r" _AND_ "mkdir -p"-like code in the VFS!
> > > 1/2 a :) )
> > 
> > I think this is the only alternative, given the design.
>  
> Right. Doing something like this at the filesystem level (as we do in
> unionfs) seems less painful - filesystems are places full of all sorts of
> nefarious activities to begin with. Having it in the VFS seems...even
> uglier.

The userspace is doing it since I return -EXDEV. And that even comes for
free. I don't need to hack around and call back into VFS as you do. It is so
simple and straightforward in the VFS.
