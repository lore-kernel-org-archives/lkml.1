Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969AbXBJTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbXBJTro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 14:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXBJTro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 14:47:44 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:19232 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbXBJTrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 14:47:43 -0500
Date: Sat, 10 Feb 2007 20:46:30 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iomap: make PCI iomap stuff excluded when PCI isn't configured
Message-ID: <20070210194630.GA13416@osiris.ibm.com>
References: <20070210114314.GB12642@osiris.boeblingen.de.ibm.com> <45CE0434.30105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CE0434.30105@gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 12:43:16PM -0500, Tejun Heo wrote:
> devres iomap made lib/iomap.c always built and added several
> arch-indep PCI routines to include/linux/io.h and lib/iomap.c without
> wrapping them inside CONFIG_PCI.  This breaks configurations where PCI
> is not configured.  Wrap pci_iomap() in CONFIG_PCI and move managed
> PCI iomap functions into include/linux/pci.h and drivers/pci/pci.c.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> Heiko, how about this?  Does it fix s390?

Unfortunately not. Now I get

  CC      lib/iomap.o
lib/iomap.c: In function 'devm_ioport_map_release':
lib/iomap.c:270: warning: implicit declaration of function 'ioport_unmap'
lib/iomap.c: In function 'devm_ioport_map':
lib/iomap.c:297: warning: implicit declaration of function 'ioport_map'
lib/iomap.c:297: warning: assignment makes pointer from integer without a cast

and

lib/built-in.o: In function `devm_ioport_unmap': undefined reference to `ioport_unmap'
lib/built-in.o: In function `devm_ioport_map_release':iomap.c:(.text+0xf20): undefined reference to `ioport_unmap'
lib/built-in.o: In function `devm_ioport_map': undefined reference to `ioport_map'
drivers/built-in.o: In function `dmam_noncoherent_release':dma-mapping.c:(.text+0x15238): undefined reference to `dma_free_noncoherent'
drivers/built-in.o: In function `dmam_free_noncoherent': undefined reference to `dma_free_noncoherent'
drivers/built-in.o: In function `dmam_alloc_noncoherent': undefined reference to `dma_alloc_noncoherent'
make: *** [.tmp_vmlinux1] Error 1
