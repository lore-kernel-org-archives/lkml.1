Return-Path: <linux-kernel-owner+w=401wt.eu-S1763944AbXEWHYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763944AbXEWHYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbXEWHYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:24:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57287 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbXEWHYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:24:23 -0400
Date: Wed, 23 May 2007 17:24:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Introduce CONFIG_VIRT_TO_BUS
Message-Id: <20070523172415.0e496ceb.sfr@canb.auug.org.au>
In-Reply-To: <20070523070450.GN4095@ftp.linux.org.uk>
References: <20070523170155.2cb9eff8.sfr@canb.auug.org.au>
	<20070523070450.GN4095@ftp.linux.org.uk>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_May_2007_17_24_15_+1000_KoXyABpLj4uqhhlt"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2007_17_24_15_+1000_KoXyABpLj4uqhhlt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hi Al,

On Wed, 23 May 2007 08:04:50 +0100 Al Viro <viro@ftp.linux.org.uk> wrote:
>
> On Wed, May 23, 2007 at 05:01:55PM +1000, Stephen Rothwell wrote:
> > Make some offending drivers depend on it and set
> > CONFIG_ARCH_NO_VIRT_TO_BUS for ppc64 so that we don't build those drivers.
>
> Seeing how few targets _do_ have that, I'd invert the that.  I.e. have
> HAS_VIRT_TO_BUS in arch/*/Kconfig for the few architectures that have
> that stuff.

NAK :-)

I did a quick look and many architecture have some definition of
virt_to_bus ...

$ grep -w virt_to_bus include/asm*/io.h
include/asm-alpha/io.h:static inline unsigned long virt_to_bus(void *address)
include/asm-alpha/io.h:#define isa_virt_to_bus virt_to_bus
include/asm-avr32/io.h:#define virt_to_bus virt_to_phys
include/asm-blackfin/io.h:#define virt_to_bus virt_to_phys
include/asm-cris/io.h:#define virt_to_bus virt_to_phys
include/asm-h8300/io.h:#define virt_to_bus virt_to_phys
include/asm-i386/io.h:#define virt_to_bus virt_to_phys
include/asm-ia64/io.h:#define virt_to_bus       virt_to_phys
include/asm-m32r/io.h:#define virt_to_bus       virt_to_phys
include/asm-m68knommu/io.h:#define virt_to_bus virt_to_phys
include/asm-mips/io.h:#define virt_to_bus virt_to_phys
include/asm-parisc/io.h:#define virt_to_bus virt_to_phys
include/asm-powerpc/io.h: * 32 bits still uses virt_to_bus() for it's implementation of DMA
include/asm-powerpc/io.h:static inline unsigned long virt_to_bus(volatile void * address)
include/asm-ppc/io.h:extern inline unsigned long virt_to_bus(volatile void * address)
include/asm-sh64/io.h:#define virt_to_bus virt_to_phys
include/asm-sh/io.h:#define virt_to_bus virt_to_phys
include/asm-sparc64/io.h:#define virt_to_bus virt_to_bus_not_defined_use_pci_map
include/asm-x86_64/io.h:#define virt_to_bus virt_to_phys
include/asm-xtensa/io.h: * virt_to_bus and bus_to_virt are deprecated.
include/asm-xtensa/io.h:#define virt_to_bus(x)  virt_to_phys(x)

and I am not in a position to tell whether each architecture wants it or
not.  At least the way I have it, each architecture maintainer can turn
it off as they want to.  Otherwise I have to edit every architecture's
Kconfig and add HAS_VIRT_TO_BUS to each one.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_May_2007_17_24_15_+1000_KoXyABpLj4uqhhlt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGU+wkFdBgD/zoJvwRAnoCAKCbRnXbKTbrOm0BPIoESqmg6c8VvACdFeNq
sNZ81tCTPJpoChRHz1Lz0Qg=
=Ovf+
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2007_17_24_15_+1000_KoXyABpLj4uqhhlt--
