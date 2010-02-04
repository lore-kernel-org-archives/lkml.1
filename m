Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0BDIcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:32:24 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:49171 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0BDIcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:32:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YtO1mz3NGNebhYjeGiBlukNJS2JaWMyCgOLHRoqJQ2PDWb9aB3XSvd+PH1k0pvJKne
         8HSjtRXRb3bh/2OrwFwmsMUvRe09J6Mf8DGXxeFn6GGtjr5L6wkYHmSVZSaJJiAWkyex
         0EciN4m1XALR8TK4+48s0qFGSVuo1FEj6l9vc=
MIME-Version: 1.0
In-Reply-To: <20100127015947.GA11685@kroah.com>
References: <5c343a41001220840x6ce6bd29q3b69bbc978b1899f@mail.gmail.com>
	 <20100126170125.d199e52c.akpm@linux-foundation.org>
	 <20100127015947.GA11685@kroah.com>
Date: Thu, 4 Feb 2010 08:32:21 +0000
Message-ID: <5c343a41002040032w54bb9953nd6bfe60a06553625@mail.gmail.com>
Subject: Re: usbmc seems broken
From: Neil Kalo <neilkalo@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Steve Holland <sdh4@iastate.edu>,
       Oliver Neukum <oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upgraded to: 2.6.32.7-37.fc12.i686.PAE

Still no joy. Plugging in the meter gives:

Feb  4 08:27:04 localhost kernel: usb 4-1: new full speed USB device
using ohci_hcd and address 2
Feb  4 08:27:04 localhost kernel: usb 4-1: New USB device found,
idVendor=05e6, idProduct=2100
Feb  4 08:27:04 localhost kernel: usb 4-1: New USB device strings:
Mfr=2, Product=3, SerialNumber=1
Feb  4 08:27:04 localhost kernel: usb 4-1: Product: 2100 Multimeter
Feb  4 08:27:04 localhost kernel: usb 4-1: Manufacturer: KEITHLEY INSTRUMENTS
Feb  4 08:27:04 localhost kernel: usb 4-1: SerialNumber: 1160791
Feb  4 08:27:04 localhost kernel: usb 4-1: configuration #1 chosen from 1 choice
Feb  4 08:27:04 localhost kernel: usbcore: registered new interface
driver usbtmc

But "cat /dev/usbtmc0" gives:
cat: /dev/usbtmc0: Connection timed out

And in the logs:
Feb  4 08:27:35 localhost kernel: usbtmc 4-1:1.0: Unable to read data,
error -110

The very old driver still works:

Feb  4 08:31:02 localhost kernel: USBTMC: MKDEV
Feb  4 08:31:02 localhost kernel: USBTMC: CDEV_ADD f900000 1
Feb  4 08:31:02 localhost kernel: usbcore: registered new interface
driver USBTMC

[root@mc22 usbtmc-module]# cat /dev/usbtmc0
Minor Number    Manufacturer    Product Serial Number
001     KEITHLEY INSTRUMENTS    2100 Multimeter 1160791

On Wed, Jan 27, 2010 at 1:59 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jan 26, 2010 at 05:01:25PM -0800, Andrew Morton wrote:
>> (cc's added)
>>
>> On Fri, 22 Jan 2010 16:40:06 +0000
>> Neil Kalo <neilkalo@gmail.com> wrote:
>>
>> > I cannot get usbtmc to work with my device. I am using fedora 12:
>> > 2.6.31.12-174.2.3.fc12.i686.PAE
>> >
>> > Jan 22 15:40:26 localhost kernel: usb 4-1: new full speed USB device
>> > using ohci_hcd and address 4
>> > Jan 22 15:40:26 localhost kernel: usb 4-1: New USB device found,
>> > idVendor=05e6, idProduct=2100
>> > Jan 22 15:40:26 localhost kernel: usb 4-1: New USB device strings:
>> > Mfr=2, Product=3, SerialNumber=1
>> > Jan 22 15:40:26 localhost kernel: usb 4-1: Product: 2100 Multimeter
>> > Jan 22 15:40:26 localhost kernel: usb 4-1: Manufacturer: KEITHLEY INSTRUMENTS
>> > Jan 22 15:40:26 localhost kernel: usb 4-1: SerialNumber: 1160791
>> > Jan 22 15:40:26 localhost kernel: usb 4-1: configuration #1 chosen from 1 choice
>> > Jan 22 15:40:26 localhost kernel: usbtmc 4-1:1.0: can't read capabilities
>
> This was a bug in this version of the driver.
>
> Please upgrade to 2.6.32, the problem is fixed.
>
> If you are curious, commit id d0a38365d9585bf3fb71f7c57fd532441a14f3e8
> solved the problem.
>
> Hope this helps,
>
> greg k-h
>
