Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYIOIAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYIOIAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 04:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYIOH74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 03:59:56 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:47115 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYIOH7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 03:59:55 -0400
X-Greylist: delayed 1648 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2008 03:59:55 EDT
Date: Thu, 11 Sep 2008 13:50:09 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Alex Nixon <alex.nixon@citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/MIPS Development <linux-mips@linux-mips.org>,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/3] Globally defining phys_addr_t
Message-ID: <20080911115009.GA6715@linux-mips.org>
References: <48C8D76B.10901@goop.org> <Pine.LNX.4.64.0809111202560.1545@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809111202560.1545@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 12:03:36PM +0200, Geert Uytterhoeven wrote:

> On Thu, 11 Sep 2008, Jeremy Fitzhardinge wrote:
> > This is a repost of a little 3-patch series which Andrew has been
> > carrying in -mm.  It cleans up the definition of phys_addr_t to make it
> > kernel-wide rather than x86-specific, and fixes up PFN_PHYS() to use it
> > to avoid address truncation.
> > 
> > We currently have a few workarounds for this problem in the tree, but
> > Alex found another bug caused by PFN_PHYS(), so it's probably better if
> > you bring these patches into tip.git for now.
> > 
> > PowerPC also defines a phys_addr_t with the same meaning as x86; the
> > powerpc arch maintainers are happy with these patches.
> 
> If I'm not mistaking, this is also true for some MIPS machines.

Jeremy probably missed it because it's called phys_t on MIPS.  It's usually
the same size as unsigned long but a few of the 32-bit Alchemy SOCs have
peripherals placed outside of the 32-bit physical address space so for
those CONFIG_64BIT_PHYS_ADDR will be defined and phys_t be unsigned long
long and used for some pagetable stuff to map those devices into the 32-bit
virtual address space.

UM uses a phys_t for its pagetables.

A single data type for everybody is enough.  phys_addr_t or phys_t I don't
care; I went for phys_t because it's shorter, less to type.

  Ralf
