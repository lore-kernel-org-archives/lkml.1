Return-Path: <linux-kernel-owner+w=401wt.eu-S933348AbXGXLuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbXGXLuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbXGXLtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:49:55 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:54703 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbXGXLty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:49:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=W7T37r/UP00gwxCy+q4WZ4KnAbBMiEI3hjbfYT7yCY2/7zQnz3VIgbiEiQhTjz4C0U4wsX/SXmmnnmMoPLtxqWT2ACjIplaR2poESHqzcfO781U8Qr1T4aqDqqy+ylLV;
Message-ID: <17994.simon.1185277788@5ec7c279.invalid>
In-Reply-To: <3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>
References: <46A59EAA.9030105@simon.arlott.org.uk>
    <20070724072540.GA835@suse.de>
    <20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>
    <20070724084654.GB13152@suse.de>
    <3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>
Date: Tue, 24 Jul 2007 12:49:48 +0100
Subject: Re: sysfs/udev broken in latest git?
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Greg KH" <gregkh@suse.de>, "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, July 24, 2007 10:20, Kay Sievers wrote:
> On 7/24/07, Greg KH <gregkh@suse.de> wrote:
>> On Tue, Jul 24, 2007 at 10:03:14AM +0200, Cornelia Huck wrote:
>> > On Tue, 24 Jul 2007 00:25:40 -0700,
>> > Greg KH <gregkh@suse.de> wrote:
>> >
>> > > On Tue, Jul 24, 2007 at 07:39:38AM +0100, Simon Arlott wrote:
>> > > > The following commit appears to break some of my udev rules (I don't
>> > > > have the time to finish the bisect right now, but there's only four
>> > > > changes showing in "git bisect visualize" - this one is tagged
>> > > > bisect/bad, and the other three are docs/docs/unrelated).
>> > > >
>> > > > Neither of these symlinks get created by udev on kernels marked bad
>> > > > (see bisect log below):
>> > > >
>> > > > ACTION=="add", \
>> > > >         KERNEL=="event*", \
>> > > >         SUBSYSTEM=="input", \
>> > > >         SYSFS{description}=="i8042 KBD port", \
>> > > >         NAME="input/%k", \
>> > > >         SYMLINK="input/i8042-kbd", \
>> > > >         MODE="0640", \
>> > > >         GROUP="event"
>> > > >
>> > > > ACTION=="add", \
>> > > >         KERNEL=="event*", \
>> > > >         SUBSYSTEM=="input", \
>> > > >         SYSFS{manufacturer}=="Logitech", \
>> > > >         SYSFS{product}=="USB-PS/2 Optical Mouse", \
>> > > >         NAME="input/%k", \
>> > > >         SYMLINK="input/logitech-mouse", \
>> > > >         MODE="0640", \
>> > > >         GROUP="event"
>
> Simon, please run:
>   udevinfo --attribute-walk --path=<devpath>
> for the mouse on the working and the non-working kernel.

On the working kernel:

  looking at device '/devices/pci0000:00/0000:00:0c.0/usb2/2-2/2-2:1.0':
    KERNEL=="2-2:1.0"
    SUBSYSTEM=="usb"
    DRIVER=="usbhid"
    ATTR{modalias}=="usb:v046DpC044d2710dc00dsc00dp00ic03isc01ip02"
    ATTR{bInterfaceProtocol}=="02"
    ATTR{bInterfaceSubClass}=="01"
    ATTR{bInterfaceClass}=="03"
    ATTR{bNumEndpoints}=="01"
    ATTR{bAlternateSetting}==" 0"
    ATTR{bInterfaceNumber}=="00"

  looking at parent device '/devices/pci0000:00/0000:00:0c.0/usb2/2-2':
    KERNELS=="2-2"
    SUBSYSTEMS=="usb"
    DRIVERS=="usb"
    ATTRS{product}=="USB-PS/2 Optical Mouse"
    ATTRS{manufacturer}=="Logitech"
    ATTRS{quirks}=="0x0"
    ATTRS{maxchild}=="0"
    ATTRS{version}==" 2.00"
    ATTRS{devnum}=="3"
    ATTRS{busnum}=="2"
    ATTRS{speed}=="1.5"
    ATTRS{bMaxPacketSize0}=="8"
    ATTRS{bNumConfigurations}=="1"
    ATTRS{bDeviceProtocol}=="00"
    ATTRS{bDeviceSubClass}=="00"
    ATTRS{bDeviceClass}=="00"
    ATTRS{bcdDevice}=="2710"
    ATTRS{idProduct}=="c044"
    ATTRS{idVendor}=="046d"
    ATTRS{bMaxPower}==" 98mA"
    ATTRS{bmAttributes}=="a0"
    ATTRS{bConfigurationValue}=="1"
    ATTRS{bNumInterfaces}==" 1"
    ATTRS{configuration}==""
    ATTRS{dev}=="189:130"

  looking at parent device '/devices/pci0000:00/0000:00:0c.0/usb2':
    KERNELS=="usb2"
    SUBSYSTEMS=="usb"
    DRIVERS=="usb"
    ATTRS{serial}=="0000:00:0c.0"
    ATTRS{product}=="UHCI Host Controller"
    ATTRS{manufacturer}=="Linux 2.6.22-git uhci_hcd"
    ATTRS{quirks}=="0x0"
    ATTRS{maxchild}=="2"
    ATTRS{version}==" 1.10"
    ATTRS{devnum}=="1"
    ATTRS{busnum}=="2"
    ATTRS{speed}=="12"
    ATTRS{bMaxPacketSize0}=="64"
    ATTRS{bNumConfigurations}=="1"
    ATTRS{bDeviceProtocol}=="00"
    ATTRS{bDeviceSubClass}=="00"
    ATTRS{bDeviceClass}=="09"
    ATTRS{bcdDevice}=="0206"
    ATTRS{idProduct}=="0000"
    ATTRS{idVendor}=="0000"
    ATTRS{bMaxPower}=="  0mA"
    ATTRS{bmAttributes}=="e0"
    ATTRS{bConfigurationValue}=="1"
    ATTRS{bNumInterfaces}==" 1"
    ATTRS{configuration}==""
    ATTRS{dev}=="189:128"

  looking at parent device '/devices/pci0000:00/0000:00:0c.0':
    KERNELS=="0000:00:0c.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="uhci_hcd"
    ATTRS{msi_bus}==""
    ATTRS{broken_parity_status}=="0"
    ATTRS{enable}=="1"
    ATTRS{modalias}=="pci:v00001106d00003038sv00001106sd00003038bc0Csc03i00"
    ATTRS{local_cpus}=="1"
    ATTRS{irq}=="11"
    ATTRS{class}=="0x0c0300"
    ATTRS{subsystem_device}=="0x3038"
    ATTRS{subsystem_vendor}=="0x1106"
    ATTRS{device}=="0x3038"
    ATTRS{vendor}=="0x1106"

  looking at parent device '/devices/pci0000:00':
    KERNELS=="pci0000:00"
    SUBSYSTEMS==""
    DRIVERS==""
    ATTRS{uevent}==""

I can't run it on the non-working kernel until this evening...

> And make sure you have only one rule for input devices or  use
> SYMLINK+="", otherwise it overwrites any earlier rule. And if you have
> an earlier rule which already names the device, this one will be
> ignored because it has NAME= in it.

These rules are before the other event* rules.

>> > > Ugh, I thought this was all fixed up properly :(
>> >
>> > I thought this as well :(
>> >
>> > But I'm a bit confused: The patch in git has
>> >
>> > +       /* only bus-device parents get a "device"-link */
>> > +       if (dev->parent && dev->parent->bus) {
>> > +               error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
>> > +                                         "device");
>> >
>> > and
>> >
>> > -               if (parent) {
>> > -                       sysfs_create_link(&dev->kobj, &dev->parent->kobj,
>> > -                                                       "device");
>> >
>> > which really look like two different things. (My original patch didn't
>> > have the check for the parent's bus.) Don't know what happened here :(
>>
>> Ugh, this might be a merge issue with Kay's block layer device work that
>> was in my tree, but I had to merge by hand around this area.
>>
>> > (Simon: Do the links reappear if you change
>> >       if (dev->parent && dev->parent->bus)
>> > to
>> >       if (dev->parent)
>> > in device_add_class_symlinks()?)
>>
>> Yeah, that would be good to find out.
>>
>> Kay, did I mess up the merge here?
>
> It looks fine to me. "device" links must never point to anything else
> than a bus device.


-- 
Simon Arlott
