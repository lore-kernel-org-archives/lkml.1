Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033Ab0ASCfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0ASCfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 21:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536Ab0ASCfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 21:35:43 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:45248 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753481Ab0ASCfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 21:35:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=X/Xg8MZ8NMiF7A/EarzY6QsMwv3jJBps2zafl61LELOlM3yDRMwyTGthLWbrTnSEB+r4DKj2d65tclXO+t5MmVKBBKUVPaCO047zBI7rRxAMB37EEoipa5pSOFs8LrA1;
Date: Tue, 19 Jan 2010 02:35:34 +0000
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Shaohua Li <shaohua.li@intel.com>
Subject: Re: linux-next: pci tree build failure
Message-ID: <20100119023534.69a7790a@jbarnes-x200>
In-Reply-To: <201001182224.44223.rjw@sisk.pl>
References: <20100118194050.7ea0c406.sfr@canb.auug.org.au>
	<201001182224.44223.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i586-moblin-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 213.28.64.71 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 22:24:44 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday 18 January 2010, Stephen Rothwell wrote:
> > Hi Jesse,
> > 
> > Today's linux-next build (ppc64 allyesconfig) failed like this:
> > 
> > In file included from drivers/pci/pcie/pme/pcie_pme.c:22:
> > include/linux/pci-acpi.h:42: error: expected '=', ',', ';', 'asm'
> > or '__attribute__' before 'acpi_find_root_bridge_handle'
> > 
> > This file was added in commit
> > f3adb5a4f2e1dfdf9482af05481d0928a39477e8 ("PCI PM: PCIe PME root
> > port service driver") from the pci tree and seems to depend on
> > ACPI.  Maybe its building should depend on CONFIG_ACPI?
> > 
> > I added the following patch for today (I presume there is a better
> > fix):
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 18 Jan 2010 19:36:11 +1100
> > Subject: [PATCH] pci: PCIE_PME seems to depend on ACPI
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/pci/pcie/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
> > index cf3c35f..b8b494b 100644
> > --- a/drivers/pci/pcie/Kconfig
> > +++ b/drivers/pci/pcie/Kconfig
> > @@ -49,4 +49,4 @@ config PCIEASPM_DEBUG
> >  
> >  config PCIE_PME
> >  	def_bool y
> > -	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL
> > +	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL &&
> > ACPI
> 
> Thanks a lot, this is the right fix IMO.
> 
> Jesse, do you want me to resend the patch with this fix included or
> are you going to take the Stephens patch to your tree?

I'll pull in Stephen's fix, thanks.

Jesse
