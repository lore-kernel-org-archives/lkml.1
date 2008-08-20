Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYHTTfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYHTTfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbYHTTez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:34:55 -0400
Received: from n3a.bullet.mail.ac4.yahoo.com ([76.13.13.66]:25507 "HELO
	n3a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754067AbYHTTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:34:54 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 104370.46758.bm@omp106.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=RKwnZDApGYsgv7bTKlw6njsD1gCbYAEBnTtDhjid2N+6gH21kii9txYO05FO20Uzdd1L2mcqJbO5UDcoMQV4jY6JqEB8XKDO77y5e8P+yIxpk3AJgPrbmvvmj64qSOg7dyjz/vdYtbiO8Kis4xjWj5egFezOULBOlupZStF3Sp8=;
X-Mailer: YahooMailWebService/0.7.218
Date: Wed, 20 Aug 2008 12:34:51 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200808071010.27019.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <343002.57461.qm@web45206.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I again encountered the same issue IRQ23 disabled.
Here is my /proc/interrupts
           CPU0       CPU1       
  0:        381          0   IO-APIC-edge      timer
  1:         47       6499   IO-APIC-edge      i8042
  3:          2          0   IO-APIC-edge    
  4:          4          0   IO-APIC-edge    
  6:          7          0   IO-APIC-edge      floppy
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          4          0   IO-APIC-edge      i8042
 14:      27742          0   IO-APIC-edge      ide0
 15:       3152     809663   IO-APIC-edge      ide1
 16:        383          0   IO-APIC-fasteoi   uhci_hcd:usb2, uhci_hcd:usb5
 18:     888468          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb4, eth0
 19:        268          0   IO-APIC-fasteoi   uhci_hcd:usb3
 23:     300001          0   IO-APIC-fasteoi   ehci_hcd:usb1
NMI:        436        172   Non-maskable interrupts
LOC:    1810724    1760209   Local timer interrupts
RES:     171199     167417   Rescheduling interrupts
CAL:        140       6288   function call interrupts
TLB:       4071       1963   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

Thanks
Amruth p.v


--- On Thu, 8/7/08, Oliver Neukum <oliver@neukum.org> wrote:

> From: Oliver Neukum <oliver@neukum.org>
> Subject: Re: USB Serial device disconnect causes IRQ disable
> To: "amruth" <amruth_pv@yahoo.com>
> Cc: linux-usb@vger.kernel.org
> Date: Thursday, August 7, 2008, 3:10 AM
> Am Mittwoch 06 August 2008 22:58:08 schrieb amruth:
> > Hi
> > All
> > After disconnecting the usb serial device randomly. I
> am getting the following error.
> > 
> > usr/src/linux-2.6.26/drivers/usb/serial/usb-serial.c:
> serial is OK
> > /usr/src/linux-2.6.26/drivers/usb/serial/usb-serial.c:
> after rteturn serial
> > /usr/src/linux-2.6.26/drivers/usb/serial/usb-serial.c:
> before unregister serial
> > magtek ttyUSB0: Magtek 75/Excella USB card reader
> converter now disconnected from ttyUSB0
> > /usr/src/linux-2.6.26/drivers/usb/serial/usb-serial.c:
> port_release - ttyUSB0
> > /usr/src/linux-2.6.26/drivers/usb/serial/usb-serial.c:
> after unregister serial
> 
> If you have a spurious interrupt sharing a line with a
> legitimate source
> of interrupts, you'll see nothing while the legitimate
> source operates.
> Is there another device sharing irq 23? What does
> /proc/interrupts say?
> 
> 	Regards
> 		Oliver


      

