Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZHCTrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZHCTrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbZHCTrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:47:35 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:42282 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbZHCTre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:47:34 -0400
Subject: Re: nfs: __setup_str_nfs_root_setup causes a section type conflict
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, Helge Deller <deller@gmx.de>
In-Reply-To: <200908032121.10635.elendil@planet.nl>
References: <200907311446.33486.elendil@planet.nl>
	 <200908020010.30459.elendil@planet.nl>
	 <1249323782.18161.2.camel@heimdal.trondhjem.org>
	 <200908032121.10635.elendil@planet.nl>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 15:47:31 -0400
Message-Id: <1249328851.18161.32.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 1 sum rcpts/h 9 sum msgs/h 2 total rcpts 974 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 00B3317FFE42DD8E1C38E26E3D5FA47F821C7DDB
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 99 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 21:21 +0200, Frans Pop wrote:
> On Monday 03 August 2009, Trond Myklebust wrote:
> > > > /home/fjp/projects/kernel/linux-2.6/fs/nfs/nfsroot.c:403:
> > > >     error: __setup_str_nfs_root_setup causes a section type
> > > > conflict
> >
> > If you do a 'make fs/nfs/nfsroot.i', and then look at the resulting
> > file fs/nfs/nfsroot.i, what does the line that defines
> > '__setup_str_nfs_root_setup' look like?
> 
> $ grep __setup_str_nfs_root_setup fs/nfs/nfsroot.i
> 
> static const char __setup_str_nfs_root_setup[] __attribute__ 
> ((__section__(".init.rodata"))) __attribute__((aligned(1))) = "nfsroot="; 
> static struct obs_kernel_param __setup_nfs_root_setup 
> __attribute__((__used__)) __attribute__ ((__section__(".init.setup"))) 
> __attribute__((aligned((sizeof(long))))) = { __setup_str_nfs_root_setup, 
> nfs_root_setup, 0 };

Yup. That matches what I get on an x86_64 platform, where it appears to
compile without any trouble. I can see no reason why it shouldn't
compile on parisc too. In fact you should have tons of these in
init/do_mounts.c: do they generate compile errors too?

Cheers
  Trond

