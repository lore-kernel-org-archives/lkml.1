Return-Path: <linux-kernel-owner+w=401wt.eu-S1759778AbYHUVwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778AbYHUVwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYHUVwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:52:45 -0400
Received: from n3b.bullet.mail.ac4.yahoo.com ([76.13.13.73]:29829 "HELO
	n3b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753768AbYHUVwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:52:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 362023.48787.bm@omp114.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=34eYWmOaZKCs+ScE5vGTU6VpgIus1+H3ppgTj//fUfUwQ58IcT1g2DrXdrjRx8U7ZaudC4Ojub8iMlNx9uhiBcACgh0loammrmoecXin+IAp1ZRxhWym4b2738kjYNyBC0eSnhHyvz9UDr5606iL9bkQZWSEYpOPfDktTIMvTPU=;
X-Mailer: YahooMailWebService/0.7.218
Date: Thu, 21 Aug 2008 14:52:41 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable details captured
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0808211712530.17334-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <685308.61820.qm@web45211.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Alan. I will test in another computers with the new patch and let you know if I again find the issue.

Thanks
Amruth p.v


--- On Thu, 8/21/08, Alan Stern <stern@rowland.harvard.edu> wrote:

> From: Alan Stern <stern@rowland.harvard.edu>
> Subject: Re: USB Serial device disconnect causes IRQ disable details captured
> To: "amruth" <amruth_pv@yahoo.com>
> Cc: "Oliver Neukum" <oliver@neukum.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Thursday, August 21, 2008, 4:20 PM
> On Thu, 21 Aug 2008, amruth wrote:
> 
> > Hi
> > Oliver
> > I got the same issue once again. I have captured
> detail log and lusb -t with interrupts.
> > cat /proc/interrupts:
> 
> > dmesg:
> > sb 1-5: Magtek 75/Excella USB card reader converter
> now attached to ttyUSB1
> > drivers/usb/core/inode.c: creating file '012'
> > usb 1-5: New USB device found, idVendor=0801,
> idProduct=2231
> > usb 1-5: New USB device strings: Mfr=1, Product=2,
> SerialNumber=3
> > usb 1-5: Product: STX
> > usb 1-5: Manufacturer: MagTek
> > usb 1-5: SerialNumber: STX001
> > usb 2-2: uhci_result_common: failed with status 440000
> > /home/amr/linux-2.6.26/drivers/usb/serial/magtek.c:
> magtek_read_int_callback - p
> > ort 0
> > uhci_hcd 0000:00:1d.0: release dev 6 ep81-INT, period
> 8, phase 4, 61 us
> > hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
> > uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
> > hub 2-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
> > usb 2-2: USB disconnect, address 6
> > usb 2-2: unregistering device
> > usb 2-2: usb_disable_device nuking all URBs
> > usb 2-2: unregistering interface 2-2:1.0
> > /home/amr/linux-2.6.26/drivers/usb/serial/magtek.c:
> magtek_shutdown
> > magtek ttyUSB0: Magtek 75/Excella USB card reader
> converter now disconnected from ttyUSB0
> > magtek 2-2:1.0: device disconnected
> > usb 2-2:1.0: uevent
> > usb 2-2: uevent
> > hub 2-0:1.0: debounce: port 2: total 100ms stable
> 100ms status 0x100
> > usb usb2: suspend_rh (auto-stop)
> > ehci_hcd 0000:00:1d.7: devpath 5 ep2in 3strikes
> > /home/amr/linux-2.6.26/drivers/usb/serial/magtek.c:
> magtek_read_int_callback - port 1
> > usb 1-5: unlink qh0-00ff/dec56380 start 0 [1/0 us]
> > usb 1-5: link qh0-00ff/dec56380 start 0 [1/0 us]
> > usb 1-5: unlink qh0-00ff/dec56380 start 0 [1/0 us]
> > ehci_hcd 0000:00:1d.7: HC died; cleaning up
> 
> You should try using the patch in this message:
> 
> 	http://marc.info/?l=linux-usb&m=121848784300960&w=2
> 
> If that doesn't help, can you test this on another
> computer to see if
> the same thing happens?
> 
> For future testing, it would help if you enable
> CONFIG_PRINTK_TIME.
> 
> Alan Stern


      

