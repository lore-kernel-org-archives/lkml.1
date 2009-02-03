Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZBCURT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZBCURT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZBCURI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:17:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43752 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZBCURF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:17:05 -0500
Date: Tue, 3 Feb 2009 15:14:33 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable]  A patch in 2.6.27.9 caused device names to change
Message-ID: <20090203151433.4674d681@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <1233672611.11344.6.camel@localhost.localdomain>
References: <20090202170238.348af36a@dhcp-100-2-144.bos.redhat.com>
	<20090203000529.GC9467@kroah.com>
	<1233672611.11344.6.camel@localhost.localdomain>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Feb 2009 09:50:11 -0500
Dan Williams <dcbw@redhat.com> wrote:

> On Mon, 2009-02-02 at 16:05 -0800, Greg KH wrote:
> > On Mon, Feb 02, 2009 at 05:02:38PM -0500, Chuck Ebbert wrote:
> > > This patch:
> > > http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.27.9/usb-option-add-pantech-cards.patch;hb=HEAD
> > > 
> > > replaced my wireless adapter's /dev/ttyACM0 interface with three interfaces:
> > > /dev/ttyUSB[012]
> > > 
> > > That broke my ppp connection scripts. And I have to use /dev/ttyUSB1 to connect,
> > > not USB0. Also it looks like Network Manager only knows how to use the first
> > > interface in its auto-connect mode, so people using that also lost their
> > > connections.
> > 
> > Ugh, that sucks.
> > 
> > That is what is also in upstream, so 2.6.29-rc also fails for you?
> >

I didn't try it, but it should. I don't have a problem with that, just with
changing the driver in a stable kernel update.
 
> > Dan, what's with replacing working devices with the cdc-acm driver with
> > option device ids?  Is there some reason you did this?
> 
> For a long time we've been operating under the assumption that mobile
> broadband devices should be driven by option and sierra, since those
> drivers had the necessary buffering optimizations to support
> higher-speed mobile broadband devices.  That was true at least up until
> 2.6.24.
> 
> Furthermore, up until this point, I have not seen mobile broadband
> adapters (that aren't cellphones connected via USB) that *are* CDC-ACM
> compliant.  Everything previously has advertised proprietary interfaces,
> some of which are serial ports and some of which are not.
> 
> Most mobile broadband cards *do* have more than one TTY, the others are
> used for additional control ports or proprietary access for stuff like
> GPS and flashing the firmware.
> 
> Can we get the 'lsusb -v' output for this card?  I'm quite curious how
> many endpoints and interfaces the device actually has.
> 

Bus 002 Device 005: ID 106c:3711 Curitel Communications, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            2 Communications
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x106c Curitel Communications, Inc.
  idProduct          0x3711 
  bcdDevice            1.00
  iManufacturer           1 PANTECH
  iProduct                2 PANTECH USB MODEM
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          113
    bNumInterfaces          4
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         2 Communications
      bInterfaceSubClass      2 Abstract (modem)
      bInterfaceProtocol      1 AT-commands (v.25ter)
      iInterface              0 
      CDC Header:
        bcdCDC               1.09
      CDC Call Management:
        bmCapabilities       0x03
          call management
          use DataInterface
        bDataInterface          1
      CDC ACM:
        bmCapabilities       0x0f
          connection notifications
          sends break
          line coding and serial state
          get/set/clear comm features
      CDC Union:
        bMasterInterface        0
        bSlaveInterface         1 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               9
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 
      iInterface              3 Data Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x89  EP 9 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x07  EP 7 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

