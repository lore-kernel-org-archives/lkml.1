Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbXINSpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbXINSpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 14:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXINSpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 14:45:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47165 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbXINSpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 14:45:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46EAD68C.5020809@s5r6.in-berlin.de>
Date: Fri, 14 Sep 2007 20:44:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
CC: Helge Hafting <helge.hafting@aitel.hist.no>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com>	<20070907083522.3191a4ba.randy.dunlap@oracle.com>	<46E8F9D4.10307@aitel.hist.no> <87myvpqjvp.fsf@informatik.uni-tuebingen.de>
In-Reply-To: <87myvpqjvp.fsf@informatik.uni-tuebingen.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Goswin von Brederlow wrote:
> Helge Hafting <helge.hafting@aitel.hist.no> writes:
>> Randy Dunlap wrote:
>>>   NOTE: ATA enables basic SCSI support; *however*,
>>>   'SCSI disk support', 'SCSI tape support', or
>>>   'SCSI CDROM support' may also be needed,
>>>   depending on your hardware configuration.
> 
> Could one duplicate the configure options for scsi disk/tape/cdrom at
> that place?

Yes, e.g. like in http://lkml.org/lkml/2007/9/8/9.

> The text should then probably read SCSI/SATA disk support in both places.

Or rather than duplicating the menu items for the same options, split
the SCSI high-level options out into a top-level menu and adjust the
wording of the prompts.  http://lkml.org/lkml/2007/9/14/217

(top level)
menu "Storage (core and SCSI commands)"
	config SCSI
		tristate "Storage support (core and SCSI commands)"
	config BLK_DEV_SD
		tristate "Harddisks and other Direct access devices"
	config CHR_DEV_ST
		tristate "Tape drives"
	config CHR_DEV_OSST
		tristate "SCSI OnStream SC-x0 tape support"
	config BLK_DEV_SR
		tristate "CD-ROMs, DVD-ROMs"
	...

menu "Device Drivers"
	...
	menu "SCSI device support"
		config RAID_ATTRS
		config SCSI_TGT
		menu "SCSI Transports"
			...
		menuconfig SCSI_LOWLEVEL
			bool "SCSI low-level drivers"
			...

-- 
Stefan Richter
-=====-=-=== =--= -===-
http://arcgraph.de/sr/
