Return-Path: <linux-kernel-owner+w=401wt.eu-S1764176AbYEBRK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764176AbYEBRK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYEBRKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:10:47 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:3085 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbYEBRKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:10:47 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.1, stray noise in dmesg
Date: Fri, 2 May 2008 19:10:44 +0200
User-Agent: KMail/1.9.9
Cc: Gene Heskett <gene.heskett@gmail.com>
References: <200805021126.15225.gene.heskett@gmail.com>
In-reply-To: <200805021126.15225.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200805021910.45266.elendil@planet.nl>
X-OriginalArrivalTime: 02 May 2008 17:10:46.0108 (UTC) FILETIME=[760369C0:01C8AC77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> I just rebooted to 2.6.25.1, and was momentarily panic'd by the messages
> going by early in the boot, but on putting 2&2 together, found they were
> just noise.
> 
> From dmesg:
> [root@coyote ~]# dmesg|grep unable
> [    2.093502] hub 1-0:1.0: unable to enumerate USB device on port 2
> [    2.248475] hub 1-0:1.0: unable to enumerate USB device on port 5
> [    2.454444] hub 1-0:1.0: unable to enumerate USB device on port 6

I'm seeing these too (hub 5-0):
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: unable to enumerate USB device on port 5
hub 5-0:1.0: unable to enumerate USB device on port 7
usb 3-1: new low speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
usb 4-1: new low speed USB device using uhci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice

With 2.6.25 the 2 "unable to enumerate" lines were not there.
The changing order in which USB busses are detected makes comparison 
awkward, but these seem to be the only new lines.

$ lsusb # with 2.6.25-git
Bus 005 Device 001: ID 1d6b:0002
Bus 004 Device 002: ID 046d:c50d Logitech, Inc.
Bus 004 Device 001: ID 1d6b:0001
Bus 003 Device 002: ID 05a4:9841 Ortek Technology, Inc.
Bus 003 Device 001: ID 1d6b:0001
Bus 001 Device 001: ID 1d6b:0001
Bus 002 Device 001: ID 1d6b:0001

$ lsusb #with 2.6.25
Bus 005 Device 002: ID 046d:c50d Logitech, Inc.
Bus 005 Device 001: ID 1d6b:0001
Bus 004 Device 002: ID 05a4:9841 Ortek Technology, Inc.
Bus 004 Device 001: ID 1d6b:0001
Bus 003 Device 001: ID 1d6b:0001
Bus 002 Device 001: ID 1d6b:0002

Comparing the two there is one "new" device. Strange that "Bus 001" is 
missing in lsusb with 2.6.25 because dmesg does mention it as assigned.
