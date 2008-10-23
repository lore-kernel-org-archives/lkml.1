Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYJWHqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYJWHqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYJWHqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:46:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:48788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbYJWHp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:45:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,469,1220252400"; 
   d="scan'208";a="454678518"
Date: Thu, 23 Oct 2008 14:50:57 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "greg@kroah.com" <greg@kroah.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 7/16 v6] PCI: cleanup pcibios_allocate_resources()
Message-ID: <20081023065057.GA4340@yzhao12-linux.sh.intel.com>
References: <20081022083809.GA3757@yzhao12-linux.sh.intel.com> <20081022084241.GG3773@yzhao12-linux.sh.intel.com> <86802c440810230010redfbbe7oaf94bf2077ccdcdf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440810230010redfbbe7oaf94bf2077ccdcdf@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 03:10:26PM +0800, Yinghai Lu wrote:
> On Wed, Oct 22, 2008 at 1:42 AM, Yu Zhao <yu.zhao@intel.com> wrote:
> > diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> > index 844df0c..8729bde 100644
> > --- a/arch/x86/pci/i386.c
> > +++ b/arch/x86/pci/i386.c
> > @@ -147,7 +147,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
> >  static void __init pcibios_allocate_resources(int pass)
> >  {
> >        struct pci_dev *dev = NULL;
> > -       int idx, disabled;
> > +       int idx, enabled;
> >        u16 command;
> >        struct resource *r, *pr;
> >
> > @@ -160,22 +160,22 @@ static void __init pcibios_allocate_resources(int pass)
> >                        if (!r->start)          /* Address not assigned at all */
> >                                continue;
> >                        if (r->flags & IORESOURCE_IO)
> > -                               disabled = !(command & PCI_COMMAND_IO);
> > +                               enabled = command & PCI_COMMAND_IO;
> >                        else
> > -                               disabled = !(command & PCI_COMMAND_MEMORY);
> > -                       if (pass == disabled) {
> > -                               dev_dbg(&dev->dev, "resource %#08llx-%#08llx (f=%lx, d=%d, p=%d)\n",
> > +                               enabled = command & PCI_COMMAND_MEMORY;
> > +                       if (pass == enabled)
> > +                               continue;
> 
> it seems you change the flow here for MMIO
> because PCI_COMMAND_MEMORY is 2.
> 
> YH

Nice finding! Will change it back to 'disable' next version.

Thanks,
Yu
