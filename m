Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYDNEts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYDNEts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbYDNEte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:49:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:64321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801AbYDNEtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IuBiPKBYg3IOmMjoBuaS821RPVl+TZIRfYpj/GKewoRLDXoIeh3ldKGROzIjMVDjwdlxKhZBbIWbiYyQlsybG5kEEqZxO8nw1Qqim7xaN3ESCFSx0pVCwc8iMfZfhiqGa5Q3hbnxzOq/aItEcHDIExZcQtNfN3AevwH7ZFzNpwA=
From: Alexia Death <alexiadeath@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Problem: non-SDHC 2GB SD cards are unreadable
Date: Mon, 14 Apr 2008 07:49:56 +0300
User-Agent: KMail/1.9.9
References: <200804132326.07713.alexiadeath@gmail.com> <200804140245.33171.arnd@arndb.de>
In-Reply-To: <200804140245.33171.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140749.57049.alexiadeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008 03:45:32 you wrote:
> You are apparently using a SCSI device, so I assume it is a USB
> based card reader, not a directly attached SD/MMC reader.
You are correct.

> My guess is that the problem is the way that the card is presented
> to the USB mass storage driver by the reader. 
Yes, Ive come to a conclusion that because reader does not do anything about 
the speciality of the 2GB cards they wont be readable because Linux usb 
storage does not know about them either.

> Generally, there is no problem with 2GB SD cards,
It seems that in case of non-USB card readers, ie the ones built-in to laptops 
the speciality is taken care of by the reader driver...

> so it would be good if you can try a different card reader with your cards.
I have no different reader to try but I did try connecting the camera. It 
works.
[1249166.105850] scsi 6:0:0:0: Direct-Access     PENTAX   DIGITAL_CAMERA   
1.20 PQ: 0 ANSI: 0
[1249166.117440] sd 6:0:0:0: [sdb] 3985409 512-byte hardware sectors (2041 MB)
[1249166.122416] sd 6:0:0:0: [sdb] Write Protect is off
[1249166.122431] sd 6:0:0:0: [sdb] Mode Sense: 0a 0a 00 01
[1249166.122438] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[1249166.137400] sd 6:0:0:0: [sdb] 3985409 512-byte hardware sectors (2041 MB)
[1249166.142390] sd 6:0:0:0: [sdb] Write Protect is off
[1249166.142406] sd 6:0:0:0: [sdb] Mode Sense: 0a 0a 00 01
[1249166.142412] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[1249166.142430]  sdb: sdb1
[1249166.176608] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[1249166.176735] sd 6:0:0:0: Attached scsi generic sg2 type 0

As you can see the camera rewrites the hw sectors description and presents it 
quite differently than the card presents itself. Strangely enough my 
cardreader/photobank itself has no problem copying from these cards but still 
presents the cards to the pc "as is".

On Monday 14 April 2008 02:28:13 Gene Heskett wrote:
> I ask because my own camera with much smaller cards, has a similar problem,
> and everything Just Works(TM) if I plug the usb cable directly into the
> camera and mount it as a vfat file system.  I haven't had the memory card
> out of my camera in a couple of years.
That is interesting. I did not know there could be problems with smaller 
cards.  However keeping the cards in the camera is not  solution for me. I 
have a card reader to avoid tying the camera down for the copy duration.

On Monday 14 April 2008 03:45:32 you wrote:
> Also, please supply the "lsusb -v" output for the card reader.
My cardreader/photobank is of pretty average sort:

Bus 001 Device 015: ID 0424:223a Standard Microsystems Corp. 8-in-1 Card 
Reader
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x0424 Standard Microsystems Corp.
  idProduct          0x223a 8-in-1 Card Reader
  bcdDevice            2.23
  iManufacturer           1 DCB
  iProduct                2     DCB201
  iSerial                 3 000111111111
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           39
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower               96mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
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
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
        ** UNRECOGNIZED:  07 21 07 e8 03 fe ff
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

Bus 001 Device 001: ID 0000:0000
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            9 Hub
  bDeviceSubClass         0 Unused
  bDeviceProtocol         0 Full speed (or root) hub
  bMaxPacketSize0        64
  idVendor           0x0000
  idProduct          0x0000
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.24-8-generic uhci_hcd
  iProduct                2 UHCI Host Controller
  iSerial                 1 0000:00:1d.0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval             255
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             2
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood        1 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0103 power enable connect
   Port 2: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled


