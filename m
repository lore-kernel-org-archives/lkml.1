Return-Path: <linux-kernel-owner+w=401wt.eu-S935261AbZJOSnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935261AbZJOSnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935249AbZJOSnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:43:05 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:34513 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935242AbZJOSnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:43:03 -0400
Date: Thu, 15 Oct 2009 11:42:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, sfr@canb.auug.org.au,
       greg@kroah.com, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [BUILD-FAILURE] next-20091015 - vbus_enet driver breaks with
 allmodconfig
Message-Id: <20091015114210.65e1be72.randy.dunlap@oracle.com>
In-Reply-To: <4AD75E60.4020306@gmail.com>
References: <20091015152538.74a1cb15.sfr@canb.auug.org.au>
	<20091015104852.GA6740@linux.vnet.ibm.com>
	<4AD6CD940200005A00056857@sinclair.provo.novell.com>
	<4AD75E60.4020306@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4AD76D07.01DE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 13:39:44 -0400 Gregory Haskins wrote:

> Gregory Haskins wrote:
> >>>> On 10/15/2009 at  6:48 AM, in message
> > <20091015104852.GA6740@linux.vnet.ibm.com>, Kamalesh Babulal
> > <kamalesh@linux.vnet.ibm.com> wrote: 
> >> Hi Gregory,
> >>
> >> 	While building next-20091015 with allmodconfig on the powerpc
> >> vbus-enet driver breaks
> > 
> > Hi Kamalesh,
> > 
> > I'll take a look at this and get a fix submitted today.
> > 
> > Kind Regards,
> > -Greg
> > 
> >> MODPOST 2492 modules
> >> ERROR: ".vbus_driver_register" [drivers/net/vbus-enet.ko] undefined!
> >> ERROR: ".vbus_driver_unregister" [drivers/net/vbus-enet.ko] undefined!
> >> ERROR: ".vbus_driver_ioq_alloc" [drivers/net/vbus-enet.ko] undefined!
> >>
> >> CONFIG_VBUS_ENET=m
> >> CONFIG_VBUS_ENET_DEBUG=y
> >> CONFIG_VBUS_PROXY=n
> 
> Hi Kamalesh,
> 
> I am having difficulty reproducing the problem.  When I look at the
> Kconfig, I see that VBUS_ENET has a "select VBUS_PROXY" as I would
> expect.  Additionally, if I run allmodconfig I can confirm that I get
> VBUS_ENET=m, VBUS_PROXY=y:

Greg,

Did you try to reproduce it with the ppc64 config file?
allmodconfig on what arch?

I think the problem is that arch/x86/Kconfig says:

source "drivers/vbus/Kconfig"

and that should actually be in drivers/Kconfig, so that it applies
to ppc64 et al, not just x86.



> ghaskins@dev:~/sandbox/git/fabric/linux-2.6-next> rm .config
> ghaskins@dev:~/sandbox/git/fabric/linux-2.6-next> make allmodconfig
> scripts/kconfig/conf -m arch/x86/Kconfig
> #
> # configuration written to .config
> #
> ghaskins@dev:~/sandbox/git/fabric/linux-2.6-next> grep -i vbus .config
> CONFIG_VBUS_PROXY=y
> CONFIG_VBUS_PCIBRIDGE=y
> CONFIG_VBUS_ENET=m
> CONFIG_VBUS_ENET_DEBUG=y
> CONFIG_USB_GADGET_VBUS_DRAW=2
> CONFIG_USB_GPIO_VBUS=m
> 
> I am not sure how your environment could have generated the VBUS_PROXY=n
> outcome.  Does anyone have any ideas?
> 
> -Greg


---
~Randy
