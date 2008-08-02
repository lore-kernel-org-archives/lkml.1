Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYHBCcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYHBCcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYHBCcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:32:10 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55132 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752303AbYHBCcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:32:09 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=Qv7oak6kF0f45mvCiH0A:9 a=Ve4RqPuhGblrs9nSUx8A:7 a=VhaIVnTB2GmvDzjL_Fwefujf1SsA:4 a=Gr1l-fY1kBQA:10 a=CDgK0yFw8z8A:10
Message-ID: <4893C722.3010100@shaw.ca>
Date: Fri, 01 Aug 2008 20:32:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alex Buell <alex.buell@munted.org.uk>
CC: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Tomas Styblo <tripie@cpan.org>, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
References: <4890C72D.7040604@shaw.ca> <Pine.LNX.4.44L0.0807301700310.2322-100000@iolanthe.rowland.org> <20080801221504.49464f85.alex.buell@munted.org.uk> <20080801232240.d24166de.alex.buell@munted.org.uk>
In-Reply-To: <20080801232240.d24166de.alex.buell@munted.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Buell wrote:
> On Fri, 1 Aug 2008 22:15:04 +0100, I waved a wand and this message
> magically appears in front of Alex Buell:
> 
>> I've done a lot of mkfs and fsck, haven't seen any problems so far.
>> Fingers crossed that this patch works. 
> 
> Spoke too soon, that patch that was posted doesn't work for me. Here's
> my log:
> 
> Aug  1 23:18:08 lithium scsi 5:0:0:0: Direct-Access     SAMSUNG  SP1213C          0-30 PQ: 0 ANSI: 2 CCS
> Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] 234493056 512-byte hardware sectors (120060 MB)
> Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Write Protect is off
> Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Mode Sense: 00 38 00 00
> Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Assuming drive cache: write through
> Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] 234493056 512-byte hardware sectors (120060 MB)
> Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Write Protect is off
> Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Mode Sense: 00 38 00 00
> Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Assuming drive cache: write through
> Aug  1 23:18:08 lithium sda: sda1
> Aug  1 23:18:08 lithium sd 5:0:0:0: [sda] Attached SCSI disk
> Aug  1 23:18:08 lithium sd 5:0:0:0: Attached scsi generic sg1 type 0
> Aug  1 23:18:08 lithium usb-storage: device scan complete
> Aug  1 23:19:11 lithium sd 5:0:0:0: [sda] Sense Key : 0x0 [current] 
> Aug  1 23:19:11 lithium sd 5:0:0:0: [sda] ASC=0x0 ASCQ=0x0

These patches (mine or Alan's) won't stop those messages from showing 
up. The request should get retried, though.

> Aug  1 23:19:11 lithium ERROR: (device sda1): dbAllocNext: Corrupt dmap page
> Aug  1 23:19:11 lithium ERROR: (device sda1): dbAllocNext: Corrupt dmap page

Not sure what is producing these messages?

> Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] Sense Key : 0x0 [current] 
> Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] ASC=0x0 ASCQ=0x0
> Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] Sense Key : 0x0 [current] 
> Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] ASC=0x0 ASCQ=0x0
> Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] Sense Key : 0x0 [current] 
> Aug  1 23:19:20 lithium sd 5:0:0:0: [sda] ASC=0x0 ASCQ=0x0
> Aug  1 23:20:01 lithium cron[13504]: (root) CMD (test -x /usr/sbin/run-crons && /usr/sbin/run-crons )
> Aug  1 23:20:34 lithium usb 1-3.4.3: USB disconnect, address 8
> 
> :-(
