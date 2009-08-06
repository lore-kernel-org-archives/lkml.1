Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZHFVkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZHFVkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbZHFVkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:40:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:39212 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbZHFVka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Il1S36U1IhBrHW2afMf+cyJt5Ggs9SwCsxiJ/qp1JDagVgLafgfGOg7IWKsZDNbnAI
         7OvcgCAwNJqblpeyDI+/Mh3xX0HONrfliaGUCVOvLt0NazWaUjpzeCKOKYmzmnk8K3J3
         ZMggczgPwL93dt8+GMLYPzArHZW25aWTCMDA8=
MIME-Version: 1.0
In-Reply-To: <200908061604.30382.gustavo@compunauta.com>
References: <ac71f2bb0908061315o1449e91dge1d5a63a2a4b986a@mail.gmail.com>
	 <200908061604.30382.gustavo@compunauta.com>
Date: Thu, 6 Aug 2009 22:40:29 +0100
Message-ID: <ac71f2bb0908061440x7667a31eoc40808de4b9e33be@mail.gmail.com>
Subject: Re: serio / atkbd / PS/2 Strangeness with Serial port adapter
From: Matt Causey <matt.causey@gmail.com>
To: Gustavo Guillermo Perez <gustavo@compunauta.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You missed the serial io port driver.
>
Missed it?  Do you mean it's missing from lsmod?  That's because its
in the kernel:

blah / # zgrep CONFIG_SERIO= /proc/config.gz
CONFIG_SERIO=y

Or did you mean something else?

--
Matt








> kernel/drivers/input/serio
>> Things are working well - except for one problem.  One the new image,
>> some of the input devices don't work we expected.  We have a number of
>> different barcode scanners that attach to these terminals.  Many of the new
>> ones are USB HID compliant devices - which is great.  Most of them are
>> actually serial port devices, that connect to the terminal via a
>> serial --> PS/2 'wedge'.  The PS/2 wedge devices are the ones that
>> don't work correctly.
>>
>> If we connect the scanner to the thin client, and boot the image, the
>> scanner does not work.  It does not show up at all as an input device:
>>
>> blablahostname / # cat /proc/bus/input/devices
>> I: Bus=0003 Vendor=046d Product=c001 Version=0110
>> N: Name="Logitech USB Mouse"
>> P: Phys=usb-0000:00:03.0-1/input0
>> S: Sysfs=/devices/pci0000:00/0000:00:03.0/usb2/2-1/2-1:1.0/input/input0
>> U: Uniq=
>> H: Handlers=mouse0 event0
>> B: EV=17
>> B: KEY=70000 0 0 0 0 0 0 0 0
>> B: REL=103
>> B: MSC=10
>>
>> I: Bus=0003 Vendor=03f0 Product=0024 Version=0110
>> N: Name="CHICONY HP Basic USB Keyboard"
>> P: Phys=usb-0000:00:03.1-2/input0
>> S: Sysfs=/devices/pci0000:00/0000:00:03.1/usb3/3-2/3-2:1.0/input/input1
>> U: Uniq=
>> H: Handlers=kbd event1
>> B: EV=120013
>> B: KEY=10000 7 ff9f207a c14057ff febeffdf ffefffff ffffffff fffffffe
>> B: MSC=10
>> B: LED=7
>>
>> I: Bus=0010 Vendor=001f Product=0001 Version=0100
>> N: Name="PC Speaker"
>> P: Phys=isa0061/input0
>> S: Sysfs=/devices/platform/pcspkr/input/input2
>> U: Uniq=
>> H: Handlers=kbd event2
>> B: EV=40001
>> B: SND=6
>>
>> So, I enabled debugging on the contoller driver(serio.c), and I see
>> that the device generates noise when connected:
>>
>> [  458.875614] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [444989]
>> [  458.908119] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 0,
>> 1, timeout) [445022]
>> [  458.908144] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [445022]
>> [  458.940151] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 0,
>> 1, timeout) [445054]
>> [  458.940225] drivers/input/serio/i8042.c: d4 -> i8042 (command) [445054]
>> [  458.940234] drivers/input/serio/i8042.c: f2 -> i8042 (parameter)
>> [445054] [  458.972190] drivers/input/serio/i8042.c: fe <- i8042
>> (interrupt, 1, 12, timeout) [445086]
>> [  458.972204] drivers/input/serio/i8042.c: d4 -> i8042 (command) [445086]
>> [  458.972212] drivers/input/serio/i8042.c: ed -> i8042 (parameter)
>> [445086] [  459.004227] drivers/input/serio/i8042.c: fe <- i8042
>> (interrupt, 1, 12, timeout) [445118]
>> [20171.684870] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 0,
>> 1) [20162195]
>>
>> However - the atkbd driver does not pick the device up at all.
>>
>> So, I did find a workaround (which is NOT acceptable for this
>> deployment).  Remember the PS/2 'wedge' I mentioned?  Well, it has an
>> extra PS/2 port for your keyboard.  If I connect a PS/2 keyboard to
>> that thing, suddenly my scanner starts working.
>>
>> We see some chatter from the controller driver, then one of these:
>>
>> [23811.805578] input: AT Translated Set 2 keyboard as
>> /devices/platform/i8042/serio0/input/input6
>>
>> Aaaand a new device is registered as an input device:
>>
>> yayayayhostname# cat /proc/bus/input/devices
>> I: Bus=0003 Vendor=046d Product=c001 Version=0110
>> N: Name="Logitech USB Mouse"
>> P: Phys=usb-0000:00:03.0-1/input0
>> S: Sysfs=/devices/pci0000:00/0000:00:03.0/usb2/2-1/2-1:1.0/input/input0
>> U: Uniq=
>> H: Handlers=mouse0 event0
>> B: EV=17
>> B: KEY=70000 0 0 0 0 0 0 0 0
>> B: REL=103
>> B: MSC=10
>>
>> I: Bus=0003 Vendor=03f0 Product=0024 Version=0110
>> N: Name="CHICONY HP Basic USB Keyboard"
>> P: Phys=usb-0000:00:03.1-2/input0
>> S: Sysfs=/devices/pci0000:00/0000:00:03.1/usb3/3-2/3-2:1.0/input/input1
>> U: Uniq=
>> H: Handlers=kbd event1
>> B: EV=120013
>> B: KEY=10000 7 ff9f207a c14057ff febeffdf ffefffff ffffffff fffffffe
>> B: MSC=10
>> B: LED=7
>>
>> I: Bus=0010 Vendor=001f Product=0001 Version=0100
>> N: Name="PC Speaker"
>> P: Phys=isa0061/input0
>> S: Sysfs=/devices/platform/pcspkr/input/input2
>> U: Uniq=
>> H: Handlers=kbd event2
>> B: EV=40001
>> B: SND=6
>>
>> I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
>> N: Name="AT Translated Set 2 keyboard"
>> P: Phys=isa0060/serio0/input0
>> S: Sysfs=/devices/platform/i8042/serio0/input/input6
>> U: Uniq=
>> H: Handlers=kbd event3
>> B: EV=120013
>> B: KEY=4 2000000 3803078 f800d001 feffffdf ffefffff ffffffff fffffffe
>> B: MSC=10
>> B: LED=7
>>
>> Here is an lsmod, and I've attached .config in case it's helpful:
>>
>> Module                  Size  Used by
>> ppdev                   6276  0
>> parport_pc             26512  1
>> lp                      8560  0
>> parport                26824  3 ppdev,parport_pc,lp
>> pcspkr                  2176  0
>> atkbd                  15508  0
>> ohci_hcd               28308  0
>>
>> So, I don't get it.  We had this all working fine with the (now
>> ancient version) LTSP configuration, linux 2.4, etc.  Did some drastic
>> things change in 2.6 with keyboard management?
>>
>> I am completely out of ideas.  The only thing I can figure is that the
>> PS/2 wedge thing isn't doing the right thing, and as a result the 2.6
>> version of the atkbd driver isn't binding it?   Maybe there is some
>> udev magic I need to know?
>>
>> Apologies if I've missed something obvious here.  Any help would be
>> much appreciated!
>> Thanks!
>
>
>
> --
> Gustavo Guillermo Pérez
> www.compunauta.com
> Anuncios Gratis: http://anuncios.compunauta.net/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
