Return-Path: <linux-kernel-owner+w=401wt.eu-S937020AbXLQWou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937020AbXLQWou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937007AbXLQWoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:44:23 -0500
Received: from rtr.ca ([76.10.145.34]:1846 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936978AbXLQWoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:44:20 -0500
Message-ID: <4766FBBF.5020606@rtr.ca>
Date: Mon, 17 Dec 2007 17:44:15 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jean-Louis Dupond <info@dupondje.be>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_mv not working with a RocketRaid 2220
References: <4766562B.8090609@dupondje.be>
In-Reply-To: <4766562B.8090609@dupondje.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Louis Dupond wrote:
> Added CC to linux-ide
> 
> -------- Originele bericht --------
> Onderwerp:     sata_mv not working with a RocketRaid 2220
> Datum:     Mon, 17 Dec 2007 00:15:30 +0100
> Van:     Jean-Louis Dupond <info@dupondje.be>
> Aan:     linux-kernel@vger.kernel.org
> 
> 
> 
> Hello,
> 
> I'm trying to get my HighPoint RocketRaid Controller working with the 
> sata_mv drivers.
> But something is not working correctly :(
> 
> Kernel version 2.6.23.11 (also tried 2.6.24-rc5 with same results)
> Controller in lspci: Marvell Technology Group Ltd. MV88SX6081 8-port 
> SATA II PCI-X Controller (rev 07)
> 
..

The sata_mv driver is currently not very good,
but should improve over this winter as some effort
is finally going into fixing it.

And the Highpoint RocketRAID cards are a similarly dubious choice,
as their onboard BIOS is known to corrupt filesystems before Linux
is even booted.

In particular, an "unconfigured" drive -- just plugged into a RR card
without entering the BIOS setup to configure a RAID -- gets sector 8 
overwritten by the BIOS.  This will destroy GRUB if it was installed.
And for drives which *have* been configured in the RR BIOS,
it overwrites a sector at the end of the final full GB on the drive,
for holding RR metadata.

Cheers

