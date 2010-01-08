Return-Path: <linux-kernel-owner+w=401wt.eu-S1752980Ab0AHNeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0AHNeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 08:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662Ab0AHNen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 08:34:43 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:41504 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab0AHNem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 08:34:42 -0500
Date: Fri, 8 Jan 2010 13:34:34 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: Joe Perches <joe@perches.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, davem@davemloft.net
Subject: RE: [PATCH] drivers/net/defxx.c: use %pMF to show MAC address
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090208961F@mi8nycmail19.Mi8.com>
Message-ID: <alpine.LFD.2.00.1001081316570.13474@eddie.linux-mips.org>
References: <201001071624.20139.hartleys@visionengravers.com> <1262914750.10429.88.camel@Joe-Laptop.home> <alpine.LFD.2.00.1001080143250.13474@eddie.linux-mips.org> <BD79186B4FD85F4B8E60E381CAEE19090208961F@mi8nycmail19.Mi8.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, H Hartley Sweeten wrote:

> >> I believe the output will _now_ be in the canonical form.
> >> Before it wasn't bit reversed.  Now it should be.
> >
> > Output was correct -- why would you assume otherwise?  The bit order in 
> > the MLA (My Long Address) register as retrieved from the MAC chip by 
> > board's firmware has nothing to do with the wire order and is already in 
> > the canonical form (the same applies to CAM entries and frame headers) -- 
> > the board designers were sane people.
> >
> > With the two patches in place the output produced is now broken. :(
> >
> 
> Ugh.. This is a mess...
> 
> David,
> 
> Can you please un-apply both this patch and the one for skfddi.c?
> I think they should both use some form of the %p[mMF] format to display
> the address but it appears Maciej is the only person that really knows
> what the output _should" be...

 Here are excerpts from old bootstrap logs -- I don't have any of these 
boards handy at the moment, but I'll have access to a couple in a few 
weeks' time:

defxx: v1.10 2006/12/14  Lawrence V. Stefani and others
tc0: DEFTA at addr = 0x10100000, IRQ = 2, Hardware addr = 08-00-2B-A3-66-C8
tc0: registered as fddi0
tc1: DEFTA at addr = 0x14100000, IRQ = 3, Hardware addr = 08-00-2B-A3-A3-29
tc1: registered as fddi1

defxx: v1.10 2006/12/14  Lawrence V. Stefani and others
0000:00:06.0: DEFPA at addr = 0x41071000, IRQ = 57, Hardware addr = 00-60-B0-58-40-75
0000:00:06.0: registered as fddi0
0000:02:00.0: DEFPA at addr = 0x41510000, IRQ = 57, Hardware addr = 00-60-B0-58-41-E7
0000:02:00.0: registered as fddi1

Compare the addresses reported with the OUIs of the respective 
manufacturers -- the former is DEC and the latter is HP.  See 
http://standards.ieee.org/regauth/oui/oui.txt for a reference.

  Maciej
