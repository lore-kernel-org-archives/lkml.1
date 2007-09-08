Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbXIHHG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbXIHHG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXIHHGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:06:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50627 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbXIHHGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:06:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46E249CB.5070505@s5r6.in-berlin.de>
Date: Sat, 08 Sep 2007 09:05:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Folkert van Heusden <folkert@vanheusden.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com> <20070907083522.3191a4ba.randy.dunlap@oracle.com> <20070907155903.GR16806@vanheusden.com> <46E17A81.7020304@s5r6.in-berlin.de> <20070907230529.GX16806@vanheusden.com>
In-Reply-To: <20070907230529.GX16806@vanheusden.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(added Cc linux-ide)

Folkert van Heusden wrote:
>>>> A popup makes some sense, but I don't know if menuconfig knows how to
>>>> do popup warnings... and it needs to be done for all *configs,
>>>> not just menuconfig.
>>> Maybe add a new type?
>> How about
>> comment "Note: 'SCSI disk support' is required for SATA/PATA HDDs!"
>> 	depends on ATA && !BLK_DEV_SD
> 
> Yes! Maybe create some status-line at the bottom of the screen in which
> these hints scrollby. Like powertop does.

'comment' is already supported by make {menu,x,g}config and AFAIK by
make oldconfig too.  It is not effective in make oldconfig though
because it will scroll off the screen quickly.

I am not a friend of 'select', but maybe the following actually helps.
I didn't follow all of this and previous related discussions, so I guess
somebody else suggested something like this before:


# drivers/ata/Kconfig

config ATA
	[...]

comment "Controller drivers"

[...low-level drivers go here...]

comment "Storage device drivers"

config ATA_SD
	tristate "SATA/PATA HDD support (via SCSI disk support)"
	depends on ATA
	select BLK_DEV_SD
	help
	  'SCSI disk support' is required to access SATA HDDs.  It is
	  also necessary for parallel ATA (IDE) HDDs if you use the
	  experimental parallel ATA option.

	  You can say Y or M here to select SCSI disk support, or you
	  can do so in the 'SCSI device support' section.

[...ditto for CD/DVD-ROMs, tapes, and generic support...]
-- 
Stefan Richter
-=====-=-=== =--= -=---
http://arcgraph.de/sr/
