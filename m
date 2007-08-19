Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbXHSO0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbXHSO0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 10:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbXHSO0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 10:26:10 -0400
Received: from rtr.ca ([64.26.128.89]:2128 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbXHSO0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 10:26:06 -0400
Message-ID: <46C852DE.8040701@rtr.ca>
Date: Sun, 19 Aug 2007 10:25:34 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Maciek Rutecki <maciej.rutecki@gmail.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, htejun@gmail.com,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: SATA error while resume
References: <46C80999.1060700@gmail.com>
In-Reply-To: <46C80999.1060700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciek Rutecki wrote:
> Kernel: 2.6.23-rc2 witch patches [1], but older and stable versions also
.. 
> Sometimes (one in ten, or rarely) I have this error while system resume
> from suspend to disk:
..
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata1.00: irq_stat 0x40000001
> ata1.00: cmd 25/00:00:10:0b:f3/00:04:05:00:00/e0 tag 0 cdb 0x0 data
> 524288 in
>          res 51/40:a4:6c:0b:f3/00:03:05:00:00/e0 Emask 0x9 (media error)
> ata1.00: configured for UDMA/100
> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 0:0:0:0: [sda] Sense Key : Medium Error [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
>         05 f3 0b 6c
> sd 0:0:0:0: [sda] Add. Sense: Unrecovered read error - auto reallocate
> failed
> end_request: I/O error, dev sda, sector 99814252
> Read-error on swap-device (8:0:99814256)
...

Looks like a bad sector in the swap partition.
You can probably repair it by using this sequence of commands:

swapoff /dev/sdX	<--- replace sdX with actual swap partition dev name
sync
cat /dev/zero > /dev/sdX
mkswap /dev/sdX
swapon /dev/sdX

If it recurs after doing that, then it's time for a new drive.

-ml
