Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbZFQBLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbZFQBLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 21:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759833AbZFQBKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 21:10:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:34523 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760680AbZFQBKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 21:10:53 -0400
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Leon Woestenberg <leon.woestenberg@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, arnd@arndb.de,
       scottwood@freescale.com, chris.pringle@oxtel.com,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <c384c5ea0906161756j4b701abfj2a8908b9c93ddd04@mail.gmail.com>
References: <4A37DB0F.7060801@freescale.com>
	 <200906162002.12376.arnd@arndb.de> <1245197925.21602.0.camel@pasglop>
	 <20090617093654B.fujita.tomonori@lab.ntt.co.jp>
	 <c384c5ea0906161756j4b701abfj2a8908b9c93ddd04@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 11:08:32 +1000
Message-Id: <1245200912.21602.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 02:56 +0200, Leon Woestenberg wrote:
> I use pci_map_sg(), have the device perform either DMA master reads or
> writes to the bus address using PCIe.
> After that, I use pci_unmap_sg().
> 
> My assumption is that pci_unmap_sg() either makes the cache coherent
> or invalidated and thus I do not need to take further actions.
> This is on a MPC83xx or 85xx system.
> 
> Is this assumption correct?

It is, as far as I understand things :-) Those APIs are fun.

You should only need the explicit sync calls if you are going to peek or
poke at the DMA mapped memory before you unmap it.

Cheers,
Ben.




