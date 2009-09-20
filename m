Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZITQ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZITQ23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZITQ22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:28:28 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43052 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbZITQ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:28:26 -0400
X-Sasl-enc: 0s/2DvKcdh5lTNt37teGLfNTdJDGWiVzjfLysuYJb+gg 1253464108
Message-ID: <4AB6581F.5040908@imap.cc>
Date: Sun, 20 Sep 2009 18:28:15 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"
 ?
References: <4AB630AD.90207@imap.cc> <20090920150549.GC11621@kroah.com>
In-Reply-To: <20090920150549.GC11621@kroah.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF1A7A13A155D947A53B0F895"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF1A7A13A155D947A53B0F895
Content-Type: multipart/mixed;
 boundary="------------080307010501060407080900"

This is a multi-part message in MIME format.
--------------080307010501060407080900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Greg KH schrieb:
> Can you provide a log message that shows the problem you are having wit=
h
> the 2.6.31 kernel?

Attached. Currently only from an Nvidia-tainted kernel, though.
If you need it reproduced on an untainted kernel it'll have to
wait until I can reboot the machine.

The Oops location according to gdb is:

(gdb) info line *ipaq_open+0x1cf
Line 656 of "drivers/usb/serial/ipaq.c" starts at address 0x986 <ipaq_ope=
n+457>
   and ends at 0x98f <ipaq_open+466>.

The lsusb output of the device:

ts@xenon:~> sudo lsusb -v -d 0bb4:

Bus 003 Device 002: ID 0bb4:0bce High Tech Computer Corp. Vario MDA
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         1 ?
  bDeviceProtocol         1 Microsoft ActiveSync
  bMaxPacketSize0        64
  idVendor           0x0bb4 High Tech Computer Corp.
  idProduct          0x0bce Vario MDA
  bcdDevice            0.00
  iManufacturer           1 HTC
  iProduct                2 Generic RNDIS
  iSerial                 3 66460e0b-5ccf-7103-e800-0050bf3f5173
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           62
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0=20
    bmAttributes         0xc0
      Self Powered
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       239 Miscellaneous Device
      bInterfaceSubClass      1 ?
      bInterfaceProtocol      1 Microsoft ActiveSync
      iInterface              0=20
      ** UNRECOGNIZED:  05 24 01 00 01
      ** UNRECOGNIZED:  04 24 02 00
      ** UNRECOGNIZED:  05 24 02 00 01
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass        10 CDC Data
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0=20
      iInterface              0=20
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
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)

--------------080307010501060407080900
Content-Type: text/plain;
 name="mdabug.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="mdabug.txt"

Sep 20 14:17:08 xenon kernel: [48089.284422] usb usb2: usb resume
Sep 20 14:17:08 xenon kernel: [48089.284431] ehci_hcd 0000:00:1a.7: resum=
e root hub
Sep 20 14:17:08 xenon kernel: [48089.406220] ehci_hcd 0000:00:1a.7: port =
4 full speed --> companion
Sep 20 14:17:08 xenon kernel: [48089.406231] ehci_hcd 0000:00:1a.7: GetSt=
atus port 4 status 003801 POWER OWNER sig=3Dj CONNECT
Sep 20 14:17:08 xenon kernel: [48089.418015] hub 2-0:1.0: hub_resume
Sep 20 14:17:08 xenon kernel: [48089.418068] ehci_hcd 0000:00:1a.7: GetSt=
atus port 4 status 003002 POWER OWNER sig=3Dse0 CSC
Sep 20 14:17:08 xenon kernel: [48089.518032] usb usb3: usb resume
Sep 20 14:17:08 xenon kernel: [48089.518038] usb usb3: wakeup_rh
Sep 20 14:17:08 xenon kernel: [48089.518050] hub 2-0:1.0: state 7 ports 4=
 chg 0000 evt 0000
Sep 20 14:17:08 xenon kernel: [48089.550035] hub 3-0:1.0: hub_resume
Sep 20 14:17:08 xenon kernel: [48089.550080] uhci_hcd 0000:00:1a.1: port =
2 portsc 0093,00
Sep 20 14:17:08 xenon kernel: [48089.550086] hub 3-0:1.0: port 2: status =
0101 change 0001
Sep 20 14:17:09 xenon kernel: [48089.651031] hub 3-0:1.0: state 7 ports 2=
 chg 0004 evt 0000
Sep 20 14:17:09 xenon kernel: [48089.651068] hub 3-0:1.0: port 2, status =
0101, change 0000, 12 Mb/s
Sep 20 14:17:09 xenon kernel: [48089.753045] usb 3-2: new full speed USB =
device using uhci_hcd and address 3
Sep 20 14:17:09 xenon kernel: [48089.896066] usb 3-2: skipped 3 descripto=
rs after interface
Sep 20 14:17:09 xenon kernel: [48089.901060] usb 3-2: default language 0x=
0409
Sep 20 14:17:09 xenon kernel: [48089.917067] usb 3-2: udev 3, busnum 3, m=
inor =3D 258
Sep 20 14:17:09 xenon kernel: [48089.917072] usb 3-2: New USB device foun=
d, idVendor=3D0bb4, idProduct=3D0bce
Sep 20 14:17:09 xenon kernel: [48089.917076] usb 3-2: New USB device stri=
ngs: Mfr=3D1, Product=3D2, SerialNumber=3D3
Sep 20 14:17:09 xenon kernel: [48089.917080] usb 3-2: Product: Generic RN=
DIS
Sep 20 14:17:09 xenon kernel: [48089.917083] usb 3-2: Manufacturer: HTC
Sep 20 14:17:09 xenon kernel: [48089.917086] usb 3-2: SerialNumber: 66460=
e0b-5ccf-7103-e800-0050bf3f5173
Sep 20 14:17:09 xenon kernel: [48089.917215] PM: Adding info for usb:3-2
Sep 20 14:17:09 xenon kernel: [48089.917245] usb 3-2: uevent
Sep 20 14:17:09 xenon kernel: [48089.917278] usb 3-2: usb_probe_device
Sep 20 14:17:09 xenon kernel: [48089.917283] usb 3-2: configuration #1 ch=
osen from 1 choice
Sep 20 14:17:09 xenon kernel: [48089.920075] usb 3-2: adding 3-2:1.0 (con=
fig #1, interface 0)
Sep 20 14:17:09 xenon kernel: [48089.920124] PM: Adding info for usb:3-2:=
1.0
Sep 20 14:17:09 xenon kernel: [48089.920135] usb 3-2:1.0: uevent
Sep 20 14:17:09 xenon kernel: [48089.920181] usbserial_generic 3-2:1.0: u=
sb_probe_interface
Sep 20 14:17:09 xenon kernel: [48089.920185] usbserial_generic 3-2:1.0: u=
sb_probe_interface - got id
Sep 20 14:17:09 xenon kernel: [48089.920213] ipaq 3-2:1.0: usb_probe_inte=
rface
Sep 20 14:17:09 xenon kernel: [48089.920221] ipaq 3-2:1.0: usb_probe_inte=
rface - got id
Sep 20 14:17:09 xenon kernel: [48089.920233] ipaq 3-2:1.0: PocketPC PDA c=
onverter detected
Sep 20 14:17:09 xenon kernel: [48089.922096] PM: Adding info for No Bus:e=
p_81
Sep 20 14:17:09 xenon kernel: [48089.922126] PM: Adding info for usb-seri=
al:ttyUSB0
Sep 20 14:17:09 xenon kernel: [48089.922237] PM: Adding info for No Bus:t=
tyUSB0
Sep 20 14:17:09 xenon kernel: [48089.922260] usb 3-2: PocketPC PDA conver=
ter now attached to ttyUSB0
Sep 20 14:17:09 xenon kernel: [48089.922272] usb 3-2: adding 3-2:1.1 (con=
fig #1, interface 1)
Sep 20 14:17:09 xenon kernel: [48089.922311] PM: Adding info for usb:3-2:=
1.1
Sep 20 14:17:09 xenon kernel: [48089.922320] usb 3-2:1.1: uevent
Sep 20 14:17:09 xenon kernel: [48089.922359] usbserial_generic 3-2:1.1: u=
sb_probe_interface
Sep 20 14:17:09 xenon kernel: [48089.922364] usbserial_generic 3-2:1.1: u=
sb_probe_interface - got id
Sep 20 14:17:09 xenon kernel: [48089.922388] ipaq 3-2:1.1: usb_probe_inte=
rface
Sep 20 14:17:09 xenon kernel: [48089.922397] ipaq 3-2:1.1: usb_probe_inte=
rface - got id
Sep 20 14:17:09 xenon kernel: [48089.922409] ipaq 3-2:1.1: PocketPC PDA c=
onverter detected
Sep 20 14:17:09 xenon kernel: [48089.923468] PM: Adding info for No Bus:e=
p_82
Sep 20 14:17:09 xenon kernel: [48089.923504] PM: Adding info for No Bus:e=
p_03
Sep 20 14:17:09 xenon kernel: [48089.923530] PM: Adding info for usb-seri=
al:ttyUSB1
Sep 20 14:17:09 xenon kernel: [48089.924054] PM: Adding info for No Bus:t=
tyUSB1
Sep 20 14:17:09 xenon kernel: [48089.924108] usb 3-2: PocketPC PDA conver=
ter now attached to ttyUSB1
Sep 20 14:17:09 xenon kernel: [48089.924205] PM: Adding info for No Bus:e=
p_00
Sep 20 14:17:11 xenon kernel: [48092.000069] hub 2-0:1.0: hub_suspend
Sep 20 14:17:11 xenon kernel: [48092.000082] usb usb2: bus auto-suspend
Sep 20 14:17:11 xenon kernel: [48092.000086] ehci_hcd 0000:00:1a.7: suspe=
nd root hub
Sep 20 14:17:12 xenon kernel: [48093.107413] PPP generic driver version 2=
=2E4.2
Sep 20 14:17:12 xenon kernel: [48093.107559] PM: Adding info for No Bus:p=
pp
Sep 20 14:17:12 xenon pppd[30754]: pppd 2.4.4 started by root, uid 0
Sep 20 14:17:12 xenon pppd[30752]: pppd 2.4.4 started by root, uid 0
Sep 20 14:17:12 xenon kernel: [48093.158210] BUG: unable to handle kernel=
 NULL pointer dereference at 0000003c
Sep 20 14:17:12 xenon hal-synce-serial[30748] ERROR : failed to initializ=
e ppp connection, return code -9
Sep 20 14:17:12 xenon hal-synce-serial[30748] CRITICAL : failed to establ=
ish serial connection, aborting...
Sep 20 14:17:12 xenon kernel: [48093.158222] IP: [<f8fde968>] ipaq_open+0=
x1cf/0x34a [ipaq]
Sep 20 14:17:12 xenon kernel: [48093.158241] *pde =3D 00000000=20
Sep 20 14:17:12 xenon kernel: [48093.158248] Oops: 0002 [#1] PREEMPT SMP =

Sep 20 14:17:12 xenon kernel: [48093.158257] last sysfs file: /sys/block/=
sda/sda1/stat
Sep 20 14:17:12 xenon kernel: [48093.158262] Modules linked in: ppp_gener=
ic slhc rndis_host cdc_ether usbnet mii ipaq usbserial vboxnetadp vboxnet=
flt vboxdrv tun snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device iptable_=
filter ip_tables ip6table_filter ip6_tables x_tables af_packet ipv6 cpufr=
eq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq microcod=
e ohci_hcd ssb dm_crypt loop raid1 snd_hda_codec_idt snd_hda_intel nvidia=
(P) snd_hda_codec osst usb_storage snd_pcm snd_timer bas_gigaset snd giga=
set rtc_cmos ohci1394 rtc_core soundcore sr_mod kernelcapi parport_pc iee=
e1394 parport intel_agp snd_page_alloc cdrom crc_ccitt i2c_i801 rtc_lib a=
gpgart button iTCO_wdt i2c_core usb_libusual st iTCO_vendor_support usblp=
 sg usbhid hid linear ehci_hcd uhci_hcd sd_mod crc_t10dif usbcore dm_snap=
shot edd dm_mod ext3 mbcache jbd fan thermal processor aic7xxx scsi_trans=
port_spi pata_marvell ahci libata scsi_mod
Sep 20 14:17:12 xenon kernel: [48093.158443]=20
Sep 20 14:17:12 xenon kernel: [48093.158451] Pid: 30754, comm: pppd Taint=
ed: P           (2.6.31-vanilla #1)        =20
Sep 20 14:17:12 xenon kernel: [48093.158457] EIP: 0060:[<f8fde968>] EFLAG=
S: 00210286 CPU: 1
Sep 20 14:17:12 xenon kernel: [48093.158470] EIP is at ipaq_open+0x1cf/0x=
34a [ipaq]
Sep 20 14:17:12 xenon kernel: [48093.158475] EAX: 00000000 EBX: ebc5d400 =
ECX: 00000000 EDX: cfd58000
Sep 20 14:17:12 xenon kernel: [48093.158480] ESI: cfe83800 EDI: c1155400 =
EBP: ebc5ce14 ESP: ebc5cdf0
Sep 20 14:17:12 xenon kernel: [48093.158486]  DS: 007b ES: 007b FS: 00d8 =
GS: 0033 SS: 0068
Sep 20 14:17:12 xenon kernel: [48093.158493] Process pppd (pid: 30754, ti=
=3Debc5c000 task=3Df3c19b60 task.ti=3Debc5c000)
Sep 20 14:17:12 xenon kernel: [48093.158498] Stack:
Sep 20 14:17:12 xenon kernel: [48093.158501]  f5884000 f3d01900 00000100 =
00000001 00000064 c1155414 f8fe594c cfe83800
Sep 20 14:17:12 xenon kernel: [48093.158518] <0> f3d01900 ebc5ce3c f8f95c=
9e f5ac8c00 f5884000 f5884000 ebc5ce3c f3d01938
Sep 20 14:17:12 xenon kernel: [48093.158537] <0> f5884000 f5b11480 f58840=
00 ebc5ce6c c026a022 f5ac8c00 f3c558f0 00000000
Sep 20 14:17:12 xenon kernel: [48093.158557] Call Trace:
Sep 20 14:17:12 xenon kernel: [48093.158573]  [<f8f95c9e>] ? serial_open+=
0x130/0x1f7 [usbserial]
Sep 20 14:17:12 xenon kernel: [48093.158587]  [<c026a022>] ? tty_open+0x2=
95/0x399
Sep 20 14:17:12 xenon kernel: [48093.158597]  [<c0192ac5>] ? chrdev_open+=
0x10d/0x124
Sep 20 14:17:12 xenon kernel: [48093.158607]  [<c018efa3>] ? __dentry_ope=
n+0x150/0x22c
Sep 20 14:17:12 xenon kernel: [48093.158615]  [<c018fe69>] ? nameidata_to=
_filp+0x2c/0x43
Sep 20 14:17:12 xenon kernel: [48093.158622]  [<c01929b8>] ? chrdev_open+=
0x0/0x124
Sep 20 14:17:12 xenon kernel: [48093.158631]  [<c0199922>] ? do_filp_open=
+0x401/0x6f5
Sep 20 14:17:12 xenon kernel: [48093.158639]  [<c018adee>] ? __slab_alloc=
+0x67/0x3e1
Sep 20 14:17:12 xenon kernel: [48093.158649]  [<c01a0b79>] ? alloc_fd+0xc=
f/0xd9
Sep 20 14:17:12 xenon kernel: [48093.158657]  [<c018ed47>] ? do_sys_open+=
0x4a/0xe2
Sep 20 14:17:12 xenon kernel: [48093.158665]  [<c018ec46>] ? filp_close+0=
x51/0x5b
Sep 20 14:17:12 xenon kernel: [48093.158673]  [<c018ee21>] ? sys_open+0x1=
e/0x26
Sep 20 14:17:12 xenon kernel: [48093.158682]  [<c01032a4>] ? sysenter_do_=
call+0x12/0x38
Sep 20 14:17:12 xenon kernel: [48093.158688] Code: 86 58 01 00 00 85 c0 8=
b 96 48 01 00 00 75 16 89 d0 e8 e1 c0 1a c7 c7 86 48 01 00 00 00 00 00 00=
 e9 3c 01 00 00 8b 86 50 01 00 00 <89> 50 3c 8b 96 60 01 00 00 8b 86 58 0=
1 00 00 89 42 3c 8b 86 50=20
Sep 20 14:17:12 xenon kernel: [48093.158796] EIP: [<f8fde968>] ipaq_open+=
0x1cf/0x34a [ipaq] SS:ESP 0068:ebc5cdf0
Sep 20 14:17:12 xenon kernel: [48093.158814] CR2: 000000000000003c
Sep 20 14:17:12 xenon kernel: [48093.158821] ---[ end trace 9562154883978=
f47 ]---

--------------080307010501060407080900--

--------------enigF1A7A13A155D947A53B0F895
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKtlgqQ3+did9BuFsRAu7DAJ97WcrpmdV/SviRISGQqpL9N+3y8QCdGSBq
B7XKLBisHy3rY0Jm/473syw=
=NxIG
-----END PGP SIGNATURE-----

--------------enigF1A7A13A155D947A53B0F895--
