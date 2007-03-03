Return-Path: <linux-kernel-owner+w=401wt.eu-S2992933AbXCCC4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992933AbXCCC4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 21:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992934AbXCCC4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 21:56:38 -0500
Received: from scrye.com ([216.17.180.1]:59675 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992933AbXCCC4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 21:56:37 -0500
X-Greylist: delayed 1147 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 21:56:37 EST
Date: Fri, 2 Mar 2007 19:37:15 -0700
From: Kevin Fenzi <kevin@scrye.com>
To: linux-kernel@vger.kernel.org
Subject: usbserial not working/oops on removal
Message-ID: <20070302193715.568098a6@ningauble.scrye.com>
Organization: Scrye
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_MqDNCLLcnd3mNeL.lTTSkfq;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_MqDNCLLcnd3mNeL.lTTSkfq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

I'm seeing some oddity with the latest fedora development kernel and a
usbserial device.=20

2.6.20-1.2949.fc7 #1 SMP Mon Feb 26 18:33:03 EST 2007 x86_64 x86_64
x86_64 GNU/Linux

Its a evdo device.=20

Doing:=20

modprobe usbserial vendor=3D0x413c product=3D0x8128 debug=3D1

gets:=20

drivers/usb/serial/usb-serial.c: Had to override the open usb serial operat=
ion with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the write usb serial opera=
tion with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the close usb serial opera=
tion with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the write_room usb serial =
operation with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the chars_in_buffer usb se=
rial operation with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the read_bulk_callback usb=
 serial operation with the generic one.
drivers/usb/serial/usb-serial.c: Had to override the write_bulk_callback us=
b serial operation with the generic one.
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
drivers/usb/serial/usb-serial.c: static descriptor matches
drivers/usb/serial/usb-serial.c: found interrupt in on endpoint 0
drivers/usb/serial/usb-serial.c: found bulk in on endpoint 1
drivers/usb/serial/usb-serial.c: found bulk out on endpoint 2
usbserial_generic 1-2.2:1.0: generic converter detected
drivers/usb/serial/usb-serial.c: usb_serial_probe - setting up 1 port struc=
tures for this device
drivers/usb/serial/usb-serial.c: the device claims to support interrupt in =
transfers, but read_int_callback is not defined
drivers/usb/serial/usb-serial.c: get_free_serial 1
drivers/usb/serial/usb-serial.c: get_free_serial - minor base =3D 0
drivers/usb/serial/usb-serial.c: usb_serial_probe - registering ttyUSB255
Attempt to register invalid tty line number  (255).
usb 1-2.2: generic converter now attached to ttyUSB255
drivers/usb/serial/usb-serial.c: static descriptor matches
drivers/usb/serial/usb-serial.c: found bulk in on endpoint 0
drivers/usb/serial/usb-serial.c: found bulk out on endpoint 1
usbserial_generic 1-2.2:1.1: generic converter detected
drivers/usb/serial/usb-serial.c: usb_serial_probe - setting up 1 port struc=
tures for this device
drivers/usb/serial/usb-serial.c: get_free_serial 1
drivers/usb/serial/usb-serial.c: get_free_serial - minor base =3D 1
drivers/usb/serial/usb-serial.c: usb_serial_probe - registering ttyUSB255
usb-serial ttyUSB255: Error registering port device, continuing
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
usbcore: deregistering interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: usb_serial_disconnect
drivers/usb/serial/usb-serial.c: destroy_serial - generic
drivers/usb/serial/generic.c: usb_serial_generic_shutdown
drivers/usb/serial/generic.c: generic_cleanup - port 255
drivers/usb/serial/usb-serial.c: return_serial

On a updated fc6 kernel it works fine and gives me a ttyUSB0, ttyUSB1. =20
Trying to rmmod the module gets:=20

Unable to handle kernel NULL pointer dereference at 0000000000000048 RIP:=20
 [<ffffffff80466693>] klist_del+0x16/0x50
PGD 626f0067 PUD 601bc067 PMD 0=20
Oops: 0000 [1] SMP=20
last sysfs file: /class/net/eth0/carrier
CPU 1=20
Modules linked in: usbserial kvm_intel kvm i915 drm autofs4 hidp rfcomm l2c=
ap sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_=
conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables acpi_cpufre=
q dm_multipath video sbs i2c_ec button bay dock battery asus_acpi ac ipv6 p=
arport_pc lp parport aes cbc blkcipher sha256 dm_crypt snd_hda_intel snd_hd=
a_codec snd_seq_dummy hci_usb bluetooth snd_seq_oss snd_seq_midi_event rtc_=
cmos fw_ohci snd_seq tg3 rtc_core fw_core serio_raw snd_seq_device rtc_lib =
snd_pcm_oss iTCO_wdt iTCO_vendor_support snd_mixer_oss snd_pcm snd_timer sn=
d soundcore shpchp i2c_i801 snd_page_alloc i2c_core sr_mod cdrom sg joydev =
dm_snapshot dm_zero dm_mirror dm_mod ata_piix ata_generic libata sd_mod scs=
i_mod ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd
Pid: 3256, comm: rmmod Not tainted 2.6.20-1.2949.fc7 #1
RIP: 0010:[<ffffffff80466693>]  [<ffffffff80466693>] klist_del+0x16/0x50
RSP: 0018:ffff8100606d1c88  EFLAGS: 00010296
RAX: ffff8100760cf2b8 RBX: 0000000000000000 RCX: 0000000000000001
RDX: ffff81004f4c6778 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff8100606d1ca8 R08: 000000000000022a R09: 0000000000000001
R10: ffffffff884479d2 R11: 0000003000000018 R12: ffff8100760cf4a8
R13: ffff81004f4c6768 R14: ffff81007e386710 R15: ffff81007e386710
FS:  00002aaaab0136f0(0000) GS:ffff810003f5fcc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000048 CR3: 000000005e918000 CR4: 00000000000026e0
Process rmmod (pid: 3256, threadinfo ffff8100606d0000, task ffff81006536508=
0)
Stack:  0000000000000001 ffff8100760cf458 ffff8100760cf458 ffff81004f4c6768
 ffff8100606d1cd8 ffffffff803b7d60 ffff8100760cf458 ffff81004f4c6768
 ffff81004f4c6768 0000000000000000 ffff8100606d1cf8 ffffffff803b7f6f
Call Trace:
 [<ffffffff803b7d60>] device_del+0x23/0x221
 [<ffffffff803b7f6f>] device_unregister+0x11/0x1e
 [<ffffffff88447d83>] :usbserial:destroy_serial+0x9a/0xf7
 [<ffffffff88447ce9>] :usbserial:destroy_serial+0x0/0xf7
 [<ffffffff80235ce2>] kref_put+0x71/0x7d
 [<ffffffff88447b4a>] :usbserial:usb_serial_put+0x14/0x16
 [<ffffffff88447be1>] :usbserial:usb_serial_disconnect+0x95/0xc1
 [<ffffffff803d3dc2>] usb_unbind_interface+0x47/0x87
 [<ffffffff803ba2a3>] __device_release_driver+0x93/0xb3
 [<ffffffff803ba8a4>] driver_detach+0xdb/0x11d
 [<ffffffff803b9dc1>] bus_remove_driver+0x75/0x98
 [<ffffffff803ba921>] driver_unregister+0x15/0x21
 [<ffffffff803d3746>] usb_deregister+0x9a/0xa8
 [<ffffffff884499c3>] :usbserial:usb_serial_generic_deregister+0x10/0x1e
 [<ffffffff8844a2dd>] :usbserial:usb_serial_exit+0x9/0x3b
 [<ffffffff802aa22d>] delete_module+0x15a/0x188
 [<ffffffff802aa2af>] sys_delete_module+0x54/0x65
 [<ffffffff802636ff>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff80222902>] __up_read+0x1a/0x83
 [<ffffffff8025c11e>] system_call+0x7e/0x83


Code: 4c 8b 6b 48 e8 ac d5 df ff 4c 89 e7 e8 39 ff ff ff 85 c0 74=20
RIP  [<ffffffff80466693>] klist_del+0x16/0x50
 RSP <ffff8100606d1c88>
CR2: 0000000000000048

lsusb -v on the device:=20

Bus 001 Device 005: ID 413c:8128 Dell Computer Corp.=20
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  idVendor           0x413c Dell Computer Corp.
  idProduct          0x8128=20
  bcdDevice            0.00
  iManufacturer           1 Novatel Wireless Inc.
  iProduct                2 Novatel Wireless EXPD CDMA
  iSerial                 0=20
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           62
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0=20
    bmAttributes         0xa0
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           3
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              3 Data Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval             128
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
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              3 Data Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0

Happy to provide more info, or file a bug in the fedora bugzilla if it
looks like thats a good idea.=20

kevin

--Sig_MqDNCLLcnd3mNeL.lTTSkfq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF6N9e3imCezTjY0ERAgC9AJ41cLqKXg5YMjAZsxbMNGV4ft2SZQCeKAs/
1N2foV8l+c0AiCEOm0DRFx8=
=ZUgX
-----END PGP SIGNATURE-----

--Sig_MqDNCLLcnd3mNeL.lTTSkfq--
