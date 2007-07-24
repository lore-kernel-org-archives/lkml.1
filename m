Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbXGXLz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbXGXLz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 07:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757996AbXGXLzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 07:55:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:57144 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710AbXGXLzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 07:55:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A1ShBJrkNuj6iY+end+U348UPv3hRDH+lqY3GBEFII3VIjoUgFLCVdRTDeuedEN2gkszrNbFI9an4kBttscAgCZnvLr/LzRJ91bnsckR3lxtNEnZ13GPTVrbtVyTlfGrqk6Y238oDAR2Kg76ncU2cSRLqsA3E5xIO6TRrjCYLwk=
Message-ID: <3ae72650707240455v4aed880fna2a6878ff5b9f7e3@mail.gmail.com>
Date: Tue, 24 Jul 2007 13:55:17 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Simon Arlott" <simon@fire.lp0.eu>
Subject: Re: sysfs/udev broken in latest git?
Cc: "Greg KH" <gregkh@suse.de>, "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <17994.simon.1185277788@5ec7c279.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A59EAA.9030105@simon.arlott.org.uk>
	 <20070724072540.GA835@suse.de>
	 <20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>
	 <20070724084654.GB13152@suse.de>
	 <3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>
	 <17994.simon.1185277788@5ec7c279.invalid>
X-Google-Sender-Auth: 678feaeb39760714
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Simon Arlott <simon@fire.lp0.eu> wrote:
> On Tue, July 24, 2007 10:20, Kay Sievers wrote:
> > On 7/24/07, Greg KH <gregkh@suse.de> wrote:
> >> On Tue, Jul 24, 2007 at 10:03:14AM +0200, Cornelia Huck wrote:
> >> > On Tue, 24 Jul 2007 00:25:40 -0700,
> >> > Greg KH <gregkh@suse.de> wrote:
> >> >
> >> > > On Tue, Jul 24, 2007 at 07:39:38AM +0100, Simon Arlott wrote:
> >> > > > The following commit appears to break some of my udev rules (I don't
> >> > > > have the time to finish the bisect right now, but there's only four
> >> > > > changes showing in "git bisect visualize" - this one is tagged
> >> > > > bisect/bad, and the other three are docs/docs/unrelated).
> >> > > >
> >> > > > Neither of these symlinks get created by udev on kernels marked bad
> >> > > > (see bisect log below):
> >> > > >
> >> > > > ACTION=="add", \
> >> > > >         KERNEL=="event*", \
> >> > > >         SUBSYSTEM=="input", \
> >> > > >         SYSFS{description}=="i8042 KBD port", \
> >> > > >         NAME="input/%k", \
> >> > > >         SYMLINK="input/i8042-kbd", \
> >> > > >         MODE="0640", \
> >> > > >         GROUP="event"
> >> > > >
> >> > > > ACTION=="add", \
> >> > > >         KERNEL=="event*", \
> >> > > >         SUBSYSTEM=="input", \
> >> > > >         SYSFS{manufacturer}=="Logitech", \
> >> > > >         SYSFS{product}=="USB-PS/2 Optical Mouse", \
> >> > > >         NAME="input/%k", \
> >> > > >         SYMLINK="input/logitech-mouse", \
> >> > > >         MODE="0640", \
> >> > > >         GROUP="event"
> >
> > Simon, please run:
> >   udevinfo --attribute-walk --path=<devpath>
> > for the mouse on the working and the non-working kernel.
>
> On the working kernel:
>
>   looking at device '/devices/pci0000:00/0000:00:0c.0/usb2/2-2/2-2:1.0':

Please start with the event* device your rule catches, not the usb one.

Thanks,
Kay
