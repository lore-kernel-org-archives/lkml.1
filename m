Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbYFXDvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbYFXDvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYFXDuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:50:52 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:40684 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752237AbYFXDuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:50:50 -0400
Date: Tue, 24 Jun 2008 12:48:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, dhowells@redhat.com, gerg@uclinux.org,
       ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-sh@vger.kernel.org, Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [2.6 patch] remove pcibios_update_resource() functions
Message-ID: <20080624034806.GA22526@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, jbarnes@virtuousgeek.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	dhowells@redhat.com, gerg@uclinux.org, ralf@linux-mips.org,
	linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
	Russell King <rmk+lkml@arm.linux.org.uk>
References: <20080617223332.GM25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617223332.GM25911@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 01:33:32AM +0300, Adrian Bunk wrote:
> Russell King did the following back in 2003:
> 
> <--  snip  -->
> 
>     [PCI] pci-9: Kill per-architecture pcibios_update_resource()
>     
>     Kill pcibios_update_resource(), replacing it with pci_update_resource().
>     pci_update_resource() uses pcibios_resource_to_bus() to convert a
>     resource to a device BAR - the transformation should be exactly the
>     same as the transformation used for the PCI bridges.
>     
>     pci_update_resource "knows" about 64-bit BARs, but doesn't attempt to
>     set the high 32-bits to anything non-zero - currently no architecture
>     attempts to do something different.  If anyone cares, please fix; I'm
>     going to reflect current behaviour for the time being.
>     
>     Ivan pointed out the following architectures need to examine their
>     pcibios_update_resource() implementation - they should make sure that
>     this new implementation does the right thing.  #warning's have been
>     added where appropriate.
>     
>         ia64
>         mips
>         mips64
>     
>     This cset also includes a fix for the problem reported by AKPM where
>     64-bit arch compilers complain about the resource mask being placed
>     in a u32.
> 
> <--  snip  -->
> 
> 
> This patch removes the unused pcibios_update_resource() functions the 
> kernel gained since.
> 
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
sh parts -

Acked-by: Paul Mundt <lethal@linux-sh.org>
