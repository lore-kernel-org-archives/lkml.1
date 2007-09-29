Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXI2FQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXI2FQW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 01:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbXI2FQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 01:16:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36098 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbXI2FQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 01:16:09 -0400
Message-ID: <46FDDF76.7000805@pobox.com>
Date: Sat, 29 Sep 2007 01:15:34 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac: Driver model & phylib update
References: <Pine.LNX.4.64N.0709191811040.24627@blysk.ds.pg.gda.pl>
In-Reply-To: <Pine.LNX.4.64N.0709191811040.24627@blysk.ds.pg.gda.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
>  A driver model and phylib update.  It includes the following changes:
> 
> 1. Removal of unused module options.
> 
> 2. Phylib support and the resulting removal of generic bits for handling
>    the PHY.
> 
> 3. Proper reserving of device resources and using ioremap()ped handles
>    to access MAC registers rather than platform-specific macros.
> 
> 4. Handling of the device using the driver model.
> 
> Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> ---
>  This is a resubmission and this patch has waited for some time now as the 
> original submission triggered some concerns on the way phylib handled 
> interrupt-driven PHY units.  The issues were resolved a while ago already, 
> but I was distracted by some other work, mainly in the toolchain area, so 
> this got postponed this far.  For some background information -- as a 
> reminder -- here is the original long explanation I gave back then:
> 
>  "Here is a set of patches that update the sb1250-mac driver used for the 
> onchip Gigabit Ethernet interfaces of the Broadcom SiByte family of SOCs 
> including the BCM1250 and a couple of other members.  These are used, 
> among others, on various Broadcom evaluation boards together with Broadcom 
> Gigabit Ethernet PHY chips.  Changes include porting the driver to the 
> driver model as a platform device, support for phylib, including the 
> BCM54xx PHYs in the interrupt mode, proper resource managment and a couple 
> of minor clean-ups.
> 
>  Apart from changes to networking code, there are a few required in the
> architecture-specific areas and therefore I am sending these changes to
> Ralf and the linux-mips list as well.  It might also involve a few more
> interested parties in the discussion.
> 
>  The changes were tested with a Broadcom SWARM board, which includes a
> BCM1250 part which has 3 MAC units on chip, of which 2 are usable, with
> BCM5421 PHY chips attached (both wired to the same interrupt line, which
> made testing whether IRQ sharing works properly in phylib possible).
> Link partners included a 1000base and a 100base interface doing
> autonegotiation as well as a 10base one doing none.
> 
>  Other Broadcom boards that I know of may have these or BCM5411 or BCM5461
> chips.  The lack of documentation or at least actual pieces of hardware
> makes the use of interrupts impossible for all but the SWARM, the Sentosa
> and the Shorty (with the latter unsupported by Linux)."
> 
>  All the bits except from the mentioned architecture-specific fix -- the 
> firmware of the SWARM gets the polarity of the PHY IRQ line wrong, which 
> has to be reprogrammed in the SOC -- have found their way into Linux 
> already.  The polarity fix is not critical for the update provided here as 
> the update has been written such that with the current state of affairs 
> the driver will use the polled mode of phylib operation.
> 
>  I will provide the architecture-specific fix later on, probably once this 
> update has propagated back to the linux-mips.org tree (suggestions as to 
> why I should do otherwise certainly welcome).  This way if any problems 
> are seen due to the switch of the PHY to the interrupt-driven mode, they 
> can be sorted out independently of this change.
> 
>  This change applies to the current netdev-2.6.git#upstream tree, on top 
> of "patch-netdev-2.6.23-rc6-20070920-sb1250-mac-typedef-9" submitted 
> yesterday.
> 
>  Please apply.
> 
>   Maciej

applied


