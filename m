Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXFSJJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXFSJJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 05:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbXFSJJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 05:09:08 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:23735 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbXFSJJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 05:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VuzSIjJJeyei04TYwxzkfVEfxL8GnD29uXLNhIidxqFWwH1pIQK2KOUJR1QG9f4WvrMUIW8bfOm0WUml8N3c7oUe6ll5U+geGqPrb7sEFeoxXJ+4Sak6Bg4eAQxllLtkVxjM+a+0XsdVHssHH6lUBZu+ZZ1AqudgmmyaadS3Zdk=
Message-ID: <3ae72650706190209i77b577aaue7324825587358b4@mail.gmail.com>
Date: Tue, 19 Jun 2007 11:09:05 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [Linux-usb-users] Stable identification of identical USB hardware
Cc: "Joerg Pommnitz" <pommnitz@yahoo.com>, linux-kernel@vger.kernel.org,
       linux-usb-users@lists.sourceforge.net
In-Reply-To: <20070618203312.GA13990@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <157636.91774.qm@web51404.mail.re2.yahoo.com>
	 <20070618203312.GA13990@kroah.com>
X-Google-Sender-Auth: 52bf3ebbafc37d6d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Jun 18, 2007 at 08:35:35AM -0700, Joerg Pommnitz wrote:
> > I want to be able to distinguish between two (or more) mostly
> > identical USB serial devices. The devices in question are UMTS modems.
> > AFAIK they are identical except for the SIM card and the point of
> > attachment. Externally the cards are CardBus devices with an
> > integrated USB host adapter. The actual UMTS device is (internally)
> > connected to the USB host adapter.
> >
> > If I have to cardbus sockets, how do I get from what I know ("the card
> > is in socket 0") to "I have to talk to ttyUSB2 to talk to the card"? I
> > suspect I have to follow the thread from /sys/bus/pci to
> > /sys/bus/usb/devices, but how exactly?
>
> Walk up the "chain" of devices in sysfs and in udev.  The udev man pages
> and documentation should show you how to do this.  If you have specific
> questions about this, please ask them on the linux-hotplug-devel mailing
> list.

This should create a symlink for the serial device in the first slot:
  KERNEL="ttyUSB*", SUBSYSTEMS=="pcmcia", KERNELS=="0.0",
SYMLINK+="serial-slot0"

You find the keys used with udevinfo. Here is an example for a PCMCIA
CF Memory card:
  udevinfo --attribute-walk --name hda4
  ...

  looking at device '/block/hda/hda4':
    KERNEL=="hda4"
    SUBSYSTEM=="block"
  ...

  looking at parent device '/devices/pci0000:00/0000:00:1e.0/0000:04:00.0/0.0':
    KERNELS=="0.0"
    SUBSYSTEMS=="pcmcia"
    DRIVERS=="ide-cs"
  ...

  looking at parent device '/devices/pci0000:00/0000:00:1e.0/0000:04:00.0':
    KERNELS=="0000:04:00.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="yenta_cardbus"
  ...

Kay
