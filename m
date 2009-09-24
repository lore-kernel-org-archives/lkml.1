Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbZIYACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbZIYACw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbZIYACv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:02:51 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:47752 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZIYACv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HNoLCX1nbg6GFTAJgaIxmLPXNE59F46heZ2ui+Sm0qlVf+DhVtuyHCqpgp48pFbLmH
         MjcARRlQeXkhrVb32MWOq+4JYvpHKsInZ/jsBU9LkkNHXapRUvFNqwdHK+BSl0Uj43KD
         vIW7qy9AzpV5vxO2Vzks8pM7kV7jKWNSuNmqY=
Message-ID: <4ABC06CE.6040404@gmail.com>
Date: Thu, 24 Sep 2009 17:54:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org
Subject: Re: Strange .31 freeze - ata related
References: <200909241834.53852.edt@aei.ca>
In-Reply-To: <200909241834.53852.edt@aei.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2009 04:34 PM, Ed Tomlinson wrote:
> Hi,
>
> I just had a strange freeze with 2.6.31.1-rc1.  Looking at the console log from startup I see that ata4&  ata5 have nothing connected.
> Later while working the box stalled.  Checking the serial console I say messages from ata4&  ata5...  There really is nothing plugged
> into the connectors.  Any ideas on what might have happened?
>
> Thanks
> Ed
>
>  From startup:

Missing the part that says which driver this is. Can you post the full 
boot log?

>
> [    2.138060] ata4: SATA link down (SStatus 0 SControl 300)
> [    2.138064] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.138417] ata5: SATA link down (SStatus 0 SControl 300)
> [    2.138818] ata3.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
> [    2.138820] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> [    2.140637] ata3.00: configured for UDMA/133
> [    2.142441] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    2.153147] ata2.00: ATA-7: WDC WD3200KS-00PFB0, 21.00M21, max UDMA/133
> [    2.153150] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 1)
> [    2.153878] ata2.00: configured for UDMA/133
> [    2.198790] ata6: SATA link down (SStatus 0 SControl 300)
> [    2.545040] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    2.556880] ata1.00: ATA-7: Maxtor 6L250S0, BACE1G10, max UDMA/133
> [    2.566684] ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.580221] ata1.00: configured for UDMA/133
>
> Last messages before it stalled:
>
> [49844.950401] ata4: exception Emask 0x73 SAct 0x0 SErr 0xffffffff action 0xe frozen
> [49844.950630] ata5: exception Emask 0x73 SAct 0x0 SErr 0xffffffff action 0xe frozen
> [49844.950677] ata5: irq_stat 0xffffffff, unknown FIS 00000000 00000000 00000000 00000000, host bus
> [49844.950725] ata5: SError: { RecovData RecovComm UnrecovData Persist Proto HostInt PHYRdyChg PHYInt CommWake 10B8B Dispar BadCRC
> [49844.950863] ata5: hard resett

The registers returning all ones suggests the hardware somehow went away 
or stopped responding to reads properly..
