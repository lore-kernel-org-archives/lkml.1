Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbYGYE5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbYGYE5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 00:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYGYE5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 00:57:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbYGYE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 00:57:08 -0400
Date: Thu, 24 Jul 2008 21:56:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Altobelli <david.altobelli@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Let HP iLO driver depend on PCI
Message-Id: <20080724215652.24e4e550.akpm@linux-foundation.org>
In-Reply-To: <20080725022048.GB5179@osiris.boeblingen.de.ibm.com>
References: <20080725022048.GB5179@osiris.boeblingen.de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 04:20:48 +0200 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Subject: [PATCH] Let HP iLO driver depend on PCI
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> "HP iLO driver" causes this on s390:
> 
> drivers/misc/hpilo.c: In function 'doorbell_set':
> drivers/misc/hpilo.c:147: error: implicit declaration of function 'iowrite8'
> drivers/misc/hpilo.c: In function 'ilo_ccb_close':
> drivers/misc/hpilo.c:204: error: implicit declaration of function 'iowrite32'
> drivers/misc/hpilo.c:204: error: implicit declaration of function 'ioread32'
> drivers/misc/hpilo.c:222: error: implicit declaration of function 'memset_io'
> drivers/misc/hpilo.c:225: error: implicit declaration of function 'pci_free_consistent'
> drivers/misc/hpilo.c: In function 'ilo_ccb_open':
> drivers/misc/hpilo.c:244: error: implicit declaration of function 'pci_alloc_consistent'
> drivers/misc/hpilo.c:245: warning: assignment makes pointer from integer without a cast
> drivers/misc/hpilo.c:296: error: implicit declaration of function 'memcpy_toio'
> drivers/misc/hpilo.c: In function 'ilo_unmap_device':
> drivers/misc/hpilo.c:575: error: implicit declaration of function 'pci_iounmap'
> drivers/misc/hpilo.c: In function 'ilo_map_device':
> drivers/misc/hpilo.c:585: error: implicit declaration of function 'pci_iomap'
> drivers/misc/hpilo.c:585: warning: assignment makes pointer from integer without a cast
> drivers/misc/hpilo.c:592: warning: assignment makes pointer from integer without a cast
> drivers/misc/hpilo.c:599: warning: assignment makes pointer from integer without a cast
> make[2]: *** [drivers/misc/hpilo.o] Error 1
> 
> Just let it depend on PCI.

Yeah, I already queued up the same patch as
drivers-misc-hpiloc-needs-config_pci.patch

Three weeks and nobody did an allmodconfig build on linux-next for s390
or m68k (at least).

