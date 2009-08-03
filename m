Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbZHCWLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbZHCWLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZHCWLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:11:38 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:47305 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZHCWLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:11:37 -0400
Subject: Re: nfs: __setup_str_nfs_root_setup causes a section type conflict
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, parisc-linux@lists.parisc-linux.org,
       Helge Deller <deller@gmx.de>
In-Reply-To: <20090803215237.GA956@merkur.ravnborg.org>
References: <200907311446.33486.elendil@planet.nl>
	 <200908032121.10635.elendil@planet.nl>
	 <1249328851.18161.32.camel@heimdal.trondhjem.org>
	 <200908032257.51739.elendil@planet.nl>
	 <1249333643.18161.36.camel@heimdal.trondhjem.org>
	 <20090803215237.GA956@merkur.ravnborg.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 18:11:33 -0400
Message-Id: <1249337493.18161.52.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 10 sum msgs/h 1 total rcpts 985 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 747252809D1B3796E2A7051DAD7CC8B6D93FC815
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 101 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 23:52 +0200, Sam Ravnborg wrote:
> On Mon, Aug 03, 2009 at 05:07:23PM -0400, Trond Myklebust wrote:
> > On Mon, 2009-08-03 at 22:57 +0200, Frans Pop wrote:
> > > $ make init/do_mounts.o
> > >   CHK     include/linux/version.h
> > >   CHK     include/linux/utsrelease.h
> > >   SYMLINK include/asm -> include/asm-parisc
> > >   CALL    scripts/checksyscalls.sh
> > >   CC      init/do_mounts.o
> > > 
> > > while:
> > > 
> > > $ make fs/nfs/nfsroot.o
> > >   CHK     include/linux/version.h
> > >   CHK     include/linux/utsrelease.h
> > >   SYMLINK include/asm -> include/asm-parisc
> > >   CALL    scripts/checksyscalls.sh
> > >   CC      fs/nfs/nfsroot.o
> > > fs/nfs/nfsroot.c:403: error: __setup_str_nfs_root_setup causes a section type 
> > > conflict
> > 
> > To me that looks like some kind of compiler bug.
> 
> unspecified behaviour is a better name for it.
> 
> We have two variables we have forced a section on.
> One variable is marked RO by the compiler while the other is not.
> This results in a section type conflict because all
> symbols needs to have the same falgs.
> 
> We usually triggers this with powerpc builds (64 bit IIRC),
> and now with parisc too.
> 
> The only way to fix it is to move one of the offending
> variables to __initdata.
> There is two variales to consider - the compiler only
> mention one of them.
> 
> Trying to declare the variables const etc usually has
> no good effect.

So why would it be happening in the NFSroot case, but not in
do_mounts.c? They're both using the standard __setup() macro with a
constant string, and an __init function argument.

Futhermore, when grepping for '__initconst', it seems that the
combination with 'static const' is the norm rather than the exception.

Trond

