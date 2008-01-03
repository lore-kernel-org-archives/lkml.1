Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbYACA1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbYACA1D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYACA0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:26:53 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:16222 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYACA0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:26:52 -0500
Date: Wed, 02 Jan 2008 18:25:21 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA kernel-buffered read VERY slow (not raid,
 Promise TX300 card); 2.6.23.1(vanilla)
In-reply-to: <477BEF8D.8090307@tlinx.org>
To: Linda Walsh <lkml@tlinx.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Message-id: <477C2B71.7040504@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>
 <4777E08C.4000603@shaw.ca> <4779870E.5070507@tlinx.org>
 <20080101015812.59e9ebf0@the-village.bc.nu> <477BEF8D.8090307@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> Alan Cox wrote:
>>> rate began falling; at 128k block-reads-at-a-time or larger, it drops 
>>> below
>>> 20MB/s (only on buffered SATA).
>>
>> Try disabling NCQ - see if you've got a drive with the 'NCQ = no
>> readahead' flaw.
> ---
>   I'm not aware, off hand, how to disable NCQ.  I haven't had any
> NCQ- or SATA- capable disks before a few weeks ago.

See here:

http://linux-ata.org/faq.html#ncq

> 
>>>     The only way I could tell before was using hdparm to read the 
>>> parameters. Since that doesn't work, it's hard to tell if they
>>> are set correctly...
>>
>> hdparm supports identify to read modes on drives with libata. The one
>> thing you cannot do is force modes right now.
>>
>>>     More importantly, how does one set parameters for acoustic and power
>>> saving parameters?  Some of my disks are used as 'backup' devices for my
>>
>> hdparm or blktool
> ----
> 
>  I have hdparm-v7.7. There are some areas where it shows information, 
> but areas where it
> does not work jump out and lead me to suspect whether or not areas
> that don't give explicit "ERROR" messages are presenting valid info.
> 
> Problem areas (using hdparm, disk=Seagate Barracuda 16MB cache, model=
> ST3750640AS):
> 1) The drives current 'multicount' setting isn't readable or settable.
> param "-i" shows "?16?" (with question marks around 16) and "-I" simply
> shows "?" for the current setting.  Attempting to <read|set> it:
> "HDIO_<GET|SET>_MULTCOUNT failed: Inappropriate ioctl for device"

I don't think you can get or get the multi count currently, it just uses 
the best supported value.

> 2) Drive Advanced Power Management setting("-B") (write-only):
> "HDIO_DRIVE_CMD failed: Input/output error"
> 3) Drive Acoustic ("-M"), read = " acoustic      = not supported",
> write = " HDIO_DRIVE_CMD:ACOUSTIC failed: Input/output error"
>   Note: drive detailed info from "-I" says:
>        "Recommended acoustic management value: 254, current value: 0"
>   (i.e. - there seems to be no way to set recommended value)

Not sure about these ones.. Does anything show up in dmesg when you do this?

> 4) 32-bit IO setting ("-c") (don't know if this important given the disk's
> raw-read speed, it may be meaningless for SATA)
> "IO_support    =  0 (default 16-bit)"*
> *

This setting is not meaningful for anything using DMA.

> FWIW -- the spindown/standby timeout ("S") does seem to work.
> 
>>> other computers.  With the ATA disks, they were kept "spun down" when 
>>> not
>>> being used (only used, 'normally', in early AM hours).
>>
>> Well for backup devices you can use the fact SATA is hot/warm plug.
> ---
>    I don't follow. It is an internal drive.  Are their software "logically
> unplug" commands that automatically re-"plug-in" the drive on access
> and spin it back up like the spindown/standby timeout does?  Or were
> you referring to SATA's general hot/warm plug ability (if my hardware
> setup, drive-slots, etc, permitted removability)?

I think they were referring to physically hotplugging the drive. This is 
more practical if you have a removable drive caddy, or if the drive is 
hooked up through eSATA.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

