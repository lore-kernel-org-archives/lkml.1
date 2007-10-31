Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbXJaQu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbXJaQu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbXJaQuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:50:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42066 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXJaQuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:50:51 -0400
Date: Wed, 31 Oct 2007 09:47:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Domen Puncer <domen.puncer@telargo.com>
Cc: Gabriel C <nix.or.die@googlemail.com>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FEC_MPC52xx_MDIO oddness.
Message-Id: <20071031094710.363cc3a6.randy.dunlap@oracle.com>
In-Reply-To: <20071031164231.GP3369@nd47.coderock.org>
References: <20071031142212.GA792@redhat.com>
	<20071031150619.GO3369@nd47.coderock.org>
	<4728ADAF.7050607@googlemail.com>
	<20071031164231.GP3369@nd47.coderock.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 17:42:32 +0100 Domen Puncer wrote:

> On 31/10/07 17:30 +0100, Gabriel C wrote:
> > Domen Puncer wrote:
> > > On 31/10/07 10:22 -0400, Dave Jones wrote:
> > >> The Kconfig for this reads..
> > >>
> > >> +config FEC_MPC52xx_MDIO
> > >> +       bool "MPC52xx FEC MDIO bus driver"
> > >> +       depends on FEC_MPC52xx
> > >> +       default y
> > >> +       ---help---
> > >> +         The MPC5200's FEC can connect to the Ethernet either with
> > >> +         an external MII PHY chip or 10 Mbps 7-wire interface
> > >> +         (Motorola? industry standard).
> > >> +         If your board uses an external PHY connected to FEC, enable this.
> > >> +         If not sure, enable.
> > >> +         If compiled as module, it will be called 'fec_mpc52xx_phy.ko'.
> > >>
> > >> Because this is bool, it'll never be compiled as a module.
> > >> Given that fec_mpc52xx_phy.c has a MODULE_LICENSE()
> > >> Should this be a tristate perhaps ?
> > > 
> > > It's ok, it will be compiled as module if fec driver is compiled as
> > > module, and built-in if fec is built-in.
> > > 
> > > from Makefile:
> > > obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx.o
> > > ifeq ($(CONFIG_FEC_MPC52xx_MDIO),y)
> > >         obj-$(CONFIG_FEC_MPC52xx) += fec_mpc52xx_phy.o
> > > endif
> > > 
> > > Yes, a bit weird, but it's best I could come up with.
> > > (fec_mdio=m and fec=y is an invalid case, that I wanted to avoid).
> > 
> > Could you please fix this warnings as well ?
> > 
> > 
> > http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/13c9d93a7afa60e2
> 
> I saw the bug reports, but unfortunately don't have a smart idea for
> the solution (moving the driver into a separate Kconfig might do it),
> so I'm waiting for Sam's input on this.

Hi Domen,

I'd like to see what Sam says also.

Using a separate Kconfig probably won't help much since this construct:

if PPC_52xx
source "Kconfig.fec"
endif

will still be read/parsed by kconfig software.  I.e., the "if" line
just adds a dependency to the config symbols in Kconfig.fec.  It does
not keep the file from being read/parsed.


---
~Randy
