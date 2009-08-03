Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbZHCU5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbZHCU5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbZHCU5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:57:53 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:52902 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbZHCU5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:57:52 -0400
From: Frans Pop <elendil@planet.nl>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: nfs: __setup_str_nfs_root_setup causes a section type conflict
Date: Mon, 3 Aug 2009 22:57:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, Helge Deller <deller@gmx.de>
References: <200907311446.33486.elendil@planet.nl> <200908032121.10635.elendil@planet.nl> <1249328851.18161.32.camel@heimdal.trondhjem.org>
In-Reply-To: <1249328851.18161.32.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032257.51739.elendil@planet.nl>
X-OriginalArrivalTime: 03 Aug 2009 20:57:52.0110 (UTC) FILETIME=[10EFD0E0:01CA147D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Trond Myklebust wrote:
> On Mon, 2009-08-03 at 21:21 +0200, Frans Pop wrote:
> > On Monday 03 August 2009, Trond Myklebust wrote:
> > > > > /home/fjp/projects/kernel/linux-2.6/fs/nfs/nfsroot.c:403:
> > > > >     error: __setup_str_nfs_root_setup causes a section type
> > > > > conflict
> > >
> > > If you do a 'make fs/nfs/nfsroot.i', and then look at the resulting
> > > file fs/nfs/nfsroot.i, what does the line that defines
> > > '__setup_str_nfs_root_setup' look like?
> >
> > $ grep __setup_str_nfs_root_setup fs/nfs/nfsroot.i
> >
> > static const char __setup_str_nfs_root_setup[] __attribute__
> > ((__section__(".init.rodata"))) __attribute__((aligned(1))) = "nfsroot=";
> > static struct obs_kernel_param __setup_nfs_root_setup __attribute__((__used__))
> > __attribute__ ((__section__(".init.setup")))
> > __attribute__((aligned((sizeof(long))))) = { __setup_str_nfs_root_setup,
> > nfs_root_setup, 0 }; 
>
> Yup. That matches what I get on an x86_64 platform, where it appears to
> compile without any trouble. I can see no reason why it shouldn't
> compile on parisc too. In fact you should have tons of these in
> init/do_mounts.c: do they generate compile errors too?

Yes, that does have similar constructs, but that does compiles OK:

$ make init/do_mounts.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-parisc
  CALL    scripts/checksyscalls.sh
  CC      init/do_mounts.o

while:

$ make fs/nfs/nfsroot.o
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-parisc
  CALL    scripts/checksyscalls.sh
  CC      fs/nfs/nfsroot.o
fs/nfs/nfsroot.c:403: error: __setup_str_nfs_root_setup causes a section type 
conflict
