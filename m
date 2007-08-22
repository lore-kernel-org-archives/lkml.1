Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbXHVCkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbXHVCkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 22:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXHVCkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 22:40:21 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:53464 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXHVCkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 22:40:20 -0400
Message-ID: <46CBA0F0.70503@gmail.com>
Date: Wed, 22 Aug 2007 04:35:28 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= 
	<jopan@alumni.uv.es>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Problems with IDE on linux 2.6.22.X
References: <200708212149.12912.jopan@alumni.uv.es> <46CB626F.8020801@gmail.com> <200708220339.45138.jopan@alumni.uv.es>
In-Reply-To: <200708220339.45138.jopan@alumni.uv.es>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2007 03:39 AM, José Luis Patiño Andrés wrote:

>> You have a SATA harddrive (Hitachi Travelstar 5K100 100GB SATA/2.5") and an
>> IDE (also known as PATA) DVD drive (LG GMA-4082N). That is, your disk
>> should be driven by the:
>>
>> "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
>>
>> under the "Serial ATA (prod) and Parallel ATA (experimental) drivers" menu,
>> and it seems this driver should also take care of your DVD. Not sure from
>> your report what you are using -- first try with only that driver, and
>> nothing from the old "ATA/ATAPI/MFM/RLL support" menu selected.
>>
>> In that situation, your harddrive works, but your DVD does not?
> 
> Okay, now it's tested as you said. In fact, in this way with only the SATA 
> drivers activated and ATA/ATAPI support completely unselected, my HDD works 
> but my DVD not.

Okay. Jeff, Alan -- 2.6.20.15 apparently working. A few weeks ago there was 
another report of a DVD drive failing detection on pata_amd (my CD and DVD 
drives work fine on pata_amd). Did some ATAPI timeouts change or something?

He's using:

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial 
ATA Storage Controller IDE (rev 02) (prog-if 80 [Master])

> And so...
> 
>> If so, this should be fixed in the driver, but to get things working I
>> believe you may try with both the above driver for your harddisk and the
>> old IDE driver for the DVD:
>>
>> <*>   Enhanced IDE/MFM/RLL disk/cdrom/tape/floppy support
>> <*>     Include IDE/ATAPI CDROM support (NEW)
>> [*]     PCI IDE chipset support
>> [*]     Generic PCI bus-master DMA support
>> <*>       Intel PIIXn chipsets support
> 
> Checked.
> 
>> (do not select IDE/ATA-2 disk support)
> 
> Unselected.
> 
> Now, I have this kernel panic:
> ###################
> #VFS: cannot open root device "sda3" or unknown-block (0,0)
> #Please, append a correct "root=" boot option; here are the available 
> #partitions:
> #1600 4194302 hdc driver: ide-cdrom

Okay, makes sense, seems the new driver simply can't grab the SATA part 
anymore when the old driver already's got the IDE part -- I wasn't sure 
about that (not a SATA user myself -- just noticed your report due to 
noticing that previous one due to pata_amd...).

The old SATA driver available from the IDE menu also does not support your 
chip, so I don't believe there are any workarounds -- you'll need the issue 
fixed.

Rene.

