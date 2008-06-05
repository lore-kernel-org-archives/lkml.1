Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYFEUub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYFEUub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYFEUuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:50:23 -0400
Received: from www.tglx.de ([62.245.132.106]:46686 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYFEUuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:50:23 -0400
Date: Thu, 5 Jun 2008 22:49:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, hpa@zytor.com, rmh@aybabtu.com,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] OLPC: pci: fix up PCI stuff so that PCI_GOANY supports
 OLPC
In-Reply-To: <20080605124220.5a6245ab.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806052245530.3235@apollo.tec.linutronix.de>
References: <20080605152914.6f4ca839@ephemeral> <20080605124220.5a6245ab.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, Andrew Morton wrote:
> On Thu, 5 Jun 2008 15:29:14 -0400
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > Previously, one would have to specifically choose CONFIG_OLPC and
> > CONFIG_PCI_GOOLPC in order to enable PCI_OLPC.  That doesn't really
> > work for distro kernels, so this patch allows one to choose
> > CONFIG_OLPC and CONFIG_PCI_GOANY in order to build in OLPC support in
> > a generic kernel (as requested by Robert Millan).
> > 
> > This also moves GOOLPC before GOANY in the menuconfig list.
> > 
> > Finally, make pci_access_init return early if we detect OLPC hardware.
> > There's no need to continue probing stuff, and pci_pcbios_init
> > specifically trashes our settings (we didn't run into that before
> > because PCI_GOANY wasn't supported).
> > 
> > It would be great if we could sneak this in for 2.6.26..  *cough*  :)
> > 
> 
> It looks harmless enough.
> 
> > ---
> >  arch/x86/Kconfig    |   11 +++++------
> >  arch/x86/pci/init.c |    3 ++-
> >  arch/x86/pci/olpc.c |    5 +++--
> >  arch/x86/pci/pci.h  |    2 +-
> 
> But I never know whether arch/x86/pci is a Jesse thing or an Ingo
> thing.  Usual answer: it's an everyone thing and we all make a big mess ;)

So the Salomonic solution is: 

You pick it up and send it either to Jesse or x86@kernel.org :)

I put it into my urgent bucket just to be on the safe side.

Thanks,
	tglx
