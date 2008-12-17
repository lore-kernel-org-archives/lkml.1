Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759676AbYLQH1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbYLQH1e (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbYLQH1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:27:06 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54487 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759368AbYLQH1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:27:04 -0500
Message-ID: <4948A9C1.6050900@garzik.org>
Date: Wed, 17 Dec 2008 02:26:57 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Justin Madru <bevicm@dslextreme.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [2.6.28-rc] Sata soft reset filling log
References: <494318F5.4060007@gawab.com> <20081216210251.138d3e98.akpm@linux-foundation.org>
In-Reply-To: <20081216210251.138d3e98.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> (cc linux-ide).
> 
> This is a post-2.6.27 regression.  Panic!
> 
> On Fri, 12 Dec 2008 18:07:49 -0800 Justin Madru <bevicm@dslextreme.com> wrote:
> 
>> I've been testing .28 (currently -rc8) and I've noticed in the logs a 
>> massive amount of the following.
>> I can confirm that the messages doesn't appear when booting into a .27 
>> kernel.
>>
>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>> ata2.00: ST_FIRST: !(DRQ|ERR|DF)
>> ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>>          cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
>>          res 50/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
>> ata2.00: status: { DRDY }
>> ata2: soft resetting link
>> ata2.00: configured for UDMA/33
>> ata2: EH complete
>>
>> I get this block of messages about every 20 seconds for as long as I'm 
>> booted into a .28 kernel.
>> It seems that the sata link is being soft reseted about every _20_ secs.
>> My drive is a sata drive that should be using UDMA/133 (right?),
>> but the "error" message says configuring for UDMA/33.
>> Does this mean that my drive is running at a slower speed?
>> Should I be worried about the .28 kernel corrupting my hardware? Is this 
>> a known issue?
>> How can I stop it from filling my logs!
>>
>> Some information about my computer:
>>
>> $ lspci
>> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML 
>> and 945GT Express Memory Controller Hub (rev 03)
>> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 
>> 943/940GML Express Integrated Graphics Controller (rev 03)
>> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 
>> 943/940GML Express Integrated Graphics Controller (rev 03)
>> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
>> Definition Audio Controller (rev 01)
>> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
>> Port 1 (rev 01)
>> 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
>> Port 4 (rev 01)
>> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
>> Controller #1 (rev 01)
>> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
>> Controller #2 (rev 01)
>> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
>> Controller #3 (rev 01)
>> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
>> Controller #4 (rev 01)
>> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
>> Controller (rev 01)
>> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
>> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
>> Bridge (rev 01)
>> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA 
>> IDE Controller (rev 01)
>> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
>> (rev 01)
>> 03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX 
>> (rev 02)

What driver in use?  ata_piix?  Can you give full dmesg (boot + first 
few errors)?

Are there any ATAPI devices attached to this controller, in addition to 
the Seagate ST980811AS ?

	Jeff




