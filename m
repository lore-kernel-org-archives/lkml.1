Return-Path: <linux-kernel-owner+w=401wt.eu-S932251AbZHCVwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251AbZHCVwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZHCVwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:52:38 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54392 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZHCVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:52:38 -0400
Date: Mon, 3 Aug 2009 23:52:37 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       Helge Deller <deller@gmx.de>
Subject: Re: nfs: __setup_str_nfs_root_setup causes a section type conflict
Message-ID: <20090803215237.GA956@merkur.ravnborg.org>
References: <200907311446.33486.elendil@planet.nl> <200908032121.10635.elendil@planet.nl> <1249328851.18161.32.camel@heimdal.trondhjem.org> <200908032257.51739.elendil@planet.nl> <1249333643.18161.36.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249333643.18161.36.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 05:07:23PM -0400, Trond Myklebust wrote:
> On Mon, 2009-08-03 at 22:57 +0200, Frans Pop wrote:
> > $ make init/do_mounts.o
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   SYMLINK include/asm -> include/asm-parisc
> >   CALL    scripts/checksyscalls.sh
> >   CC      init/do_mounts.o
> > 
> > while:
> > 
> > $ make fs/nfs/nfsroot.o
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   SYMLINK include/asm -> include/asm-parisc
> >   CALL    scripts/checksyscalls.sh
> >   CC      fs/nfs/nfsroot.o
> > fs/nfs/nfsroot.c:403: error: __setup_str_nfs_root_setup causes a section type 
> > conflict
> 
> To me that looks like some kind of compiler bug.

unspecified behaviour is a better name for it.

We have two variables we have forced a section on.
One variable is marked RO by the compiler while the other is not.
This results in a section type conflict because all
symbols needs to have the same falgs.

We usually triggers this with powerpc builds (64 bit IIRC),
and now with parisc too.

The only way to fix it is to move one of the offending
variables to __initdata.
There is two variales to consider - the compiler only
mention one of them.

Trying to declare the variables const etc usually has
no good effect.

	Sam
