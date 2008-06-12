Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYFLUVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYFLUVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbYFLUVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:21:06 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:35250 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752879AbYFLUVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:21:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FsmhxPdWbB6MYdtZe3KdLQTgfzXK3F7mvz+oCSRNXztqY7FoRLj6VhI6NlPMuMnLxznyWJfwPJxrLVoU/RoZ2hZ3UdvBeOUraPimXCDltlMHKmc/MvwZpHNtFtfD/7JBLUX4c6y2BtvhHN2Bex82G2dFaqhkYNaeJcMmsluexNE=  ;
X-YMail-OSG: HCa3EWgVM1lMOUUi3DNVp2RJt_Vo6hRtkF9FHQHxHFi46BggdWrWBgGdrnFHaBLOaAVYtpYd6vZDsQDG53FHyxBRAd4IC7vKsh.DPubLw6VRSbQnRHfCA.e897DXLaWjI4U-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH, RFC] Earlier I2C initialization
Date: Thu, 12 Jun 2008 13:21:03 -0700
User-Agent: KMail/1.9.9
Cc: Jean Delvare <khali@linux-fr.org>, Ryan Mallon <ryan@bluewatersys.com>,
       Uli Luckas <u.luckas@road.de>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
References: <200806091541.43899.u.luckas@road.de> <20080611225416.169574a0@hyperion.delvare> <Pine.LNX.4.55.0806112226060.14077@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806112226060.14077@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806121321.03429.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008, Maciej W. Rozycki wrote:
> > That being said, I'm not sure if the comparison with the PCI subsystem
> > holds... I am under the impression that PCI bus handling doesn't
> > require dedicated drivers? At least I can't see any under drivers/pci.
> 
>  Of course it does require them.  It is just due to their very nature they
> tend to be placed under arch/,

PCI root hubs, yes.  The drivers/pci/hotplug bridges are slightly
more generic, ditto drivers/pci/pcie and the CardBus bridges in
drivers/pcmcia.  At one point, lack of a generic (non-hotplug) PCI
bridge driver was viewed as a weakness of that driver stack.

Also, drivers/acpi/pci_root.c binds the root at subsys_initcall.
That's done *after* some earlier PCI magic; I never bothered
to sort through that little maze.


> although there are some cases where the 
> same system controller can be used for a range of processors (e.g. some
> Marvell chips can be used either with MIPS or PowerPC CPUs) and they might
> be arguably put in a place more suitable for sharing between
> architectures.  See arch/mips/pci/ for an example of a generous bunch of
> PCI host drivers.

Which, for the record, get very early initialization using two
different mechanisms:

  - many use arch_initcall()

  - the "arch" subtree is linked before the "drivers" subtree

I don't think I2C needs to worry about arch_initcall just now,
but if necessary it could initialize earlier than subsys_initcall.

- Dave

