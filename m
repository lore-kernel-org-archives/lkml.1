Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbXIHQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbXIHQcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXIHQcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:32:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20612 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbXIHQcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:32:21 -0400
Message-ID: <46E2CE73.3000207@oracle.com>
Date: Sat, 08 Sep 2007 09:31:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
References: <20070907124800.GP16806@vanheusden.com> <20070907083522.3191a4ba.randy.dunlap@oracle.com> <20070907155903.GR16806@vanheusden.com> <46E17A81.7020304@s5r6.in-berlin.de> <20070907230529.GX16806@vanheusden.com> <46E249CB.5070505@s5r6.in-berlin.de>
In-Reply-To: <46E249CB.5070505@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> (added Cc linux-ide)
> 
> Folkert van Heusden wrote:
>>>>> A popup makes some sense, but I don't know if menuconfig knows how to
>>>>> do popup warnings... and it needs to be done for all *configs,
>>>>> not just menuconfig.
>>>> Maybe add a new type?
>>> How about
>>> comment "Note: 'SCSI disk support' is required for SATA/PATA HDDs!"
>>> 	depends on ATA && !BLK_DEV_SD
>> Yes! Maybe create some status-line at the bottom of the screen in which
>> these hints scrollby. Like powertop does.
> 
> 'comment' is already supported by make {menu,x,g}config and AFAIK by
> make oldconfig too.  It is not effective in make oldconfig though
> because it will scroll off the screen quickly.
> 
> I am not a friend of 'select', but maybe the following actually helps.
> I didn't follow all of this and previous related discussions, so I guess
> somebody else suggested something like this before:
> 

The problem with 'select' here is that it will enable BLK_DEV_SD,
but if SCSI is not enabled, it will not become enabled -- i.e.,
select does not follow the dependency chain.  So usually the
kernel will not build unless SCSI is enabled by the user.

> # drivers/ata/Kconfig
> 
> config ATA
> 	[...]
> 
> comment "Controller drivers"
> 
> [...low-level drivers go here...]
> 
> comment "Storage device drivers"
> 
> config ATA_SD
> 	tristate "SATA/PATA HDD support (via SCSI disk support)"
> 	depends on ATA
> 	select BLK_DEV_SD
> 	help
> 	  'SCSI disk support' is required to access SATA HDDs.  It is
> 	  also necessary for parallel ATA (IDE) HDDs if you use the
> 	  experimental parallel ATA option.
> 
> 	  You can say Y or M here to select SCSI disk support, or you
> 	  can do so in the 'SCSI device support' section.
> 
> [...ditto for CD/DVD-ROMs, tapes, and generic support...]


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
