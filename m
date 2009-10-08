Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbZJHBNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbZJHBNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 21:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbZJHBN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 21:13:29 -0400
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:38537
	"EHLO QMTA03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754124AbZJHBN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 21:13:26 -0400
Date: Wed, 7 Oct 2009 20:12:47 -0500
From: Tim Walberg <twalberg@comcast.net>
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Stefan Lippers-Hollmann <s.L-H@gmx.de>, linux-wireless@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Disassociating atheros wlan with 2.6.31
Message-ID: <20091008011247.GC22458@comcast.net>
Reply-To: Tim Walberg <twalberg@comcast.net>
Mail-Followup-To: Tim Walberg <twalberg@comcast.net>,
	Kristoffer Ericson <kristoffer.ericson@gmail.com>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	linux-wireless@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20090924121617.c0c7222d.kristoffer.ericson@gmail.com> <4ABBB9D3.4020200@gmail.com> <200909242155.49890.s.L-H@gmx.de> <4ABBD170.6060702@gmail.com> <20091004174535.777d233c.kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adlATi0AGRzVk0TM"
Content-Disposition: inline
In-Reply-To: <20091004174535.777d233c.kristoffer.ericson@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--adlATi0AGRzVk0TM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Another confirmed instance of this on ath9k - on 2.6.31.2 and 2.6.31.3 - di=
dn't
happen on 2.6.30.6 or 2.6.30.9. A couple other interesting facts:

- it seems to be related (at least in my case) to heavy transmit load -
  I can download a kernel tarball without it failing, but if I try to
  copy it to another system, it fails within 2 seconds reliably...
- running 'rmmod ath9k ath mac80211 cfg80211' followed by 'modprobe ath9k'
  clears it up

No indication in dmesg except:

	wlan<n>: no probe response from AP AA:BB:DD:EE:FF:GG - disassociating

and suddenly no packets going in either direction.

I'm in the process of moving back to 2.6.30.x for now...





On 10/04/2009 17:45 +0200, Kristoffer Ericson wrote:
>>	Hi,
>>=09
>>	Did a bisect or more exactly tried to do a bisect. Ive managed to bisect=
 myself
>>	into a deadend so far (must have marked good in wrong place). The disass=
ociation happens
>>	at seemingly regular intervalls but once I started bisecting it started
>>	to be more irregular. Perhaps it was simply due to me not being able
>>	to user internet (and share) since my 3G modem oopsed all the time.
>>	Suspecting its load sensitive.
>>=09
>>	Anyhow heres what I got so far. The bad versions should be correct
>>	while the good versions might not be. Reason being that I didnt wait
>>	long enough for the disassociation to appear and thus faulty marking
>>	something as good.=20
>>	Using the bad should however narrow it down somewhat. From what
>>	I can see between my last good and bad is only non-related stuff,
>>	so must be atleast one "good" mistake in there.
>>=09
>>	git bisect start
>>	# good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
>>	git bisect good 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
>>	# bad: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
>>	git bisect bad 74fca6a42863ffacaf7ba6f1936a9f228950f657
>>	# good: [925d74ae717c9a12d3618eb4b36b9fb632e2cef3] V4L/DVB (11736): vide=
obuf: modify return value of VIDIOC_REQBUFS ioctl
>>	git bisect good 925d74ae717c9a12d3618eb4b36b9fb632e2cef3
>>	# bad: [a380137900fca5c79e6daa9500bdb6ea5649188e] ixgbe: Fix device capa=
bilities of 82599 single speed fiber NICs.
>>	git bisect bad a380137900fca5c79e6daa9500bdb6ea5649188e
>>	# bad: [1dbb5765acc7a6fe4bc1957c001037cc9d02ae03] Staging: android: lowm=
emorykiller: fix up remaining checkpatch warnings
>>	git bisect bad 1dbb5765acc7a6fe4bc1957c001037cc9d02ae03
>>	# bad: [2b1b62e841867326fa260a581d97941c32abc35b] MIPS: Cavium-Octeon: A=
dd more board type constants.
>>	git bisect bad 2b1b62e841867326fa260a581d97941c32abc35b
>>	# good: [517d08699b250021303f9a7cf0d758b6dc0748ed] Merge branch 'akpm'
>>	git bisect good 517d08699b250021303f9a7cf0d758b6dc0748ed
>>	# good: [5e2c217eee18a4627a32c49f57f47dbac67dcf23] V4L/DVB (11958): usbv=
ision-core.c: vfree does its own NULL check
>>	git bisect good 5e2c217eee18a4627a32c49f57f47dbac67dcf23
>>	# bad: [a9349315f65cd6a16e8fab1f6cf0fd40f379c4db] V4L/DVB (11819): Siano=
: smscore - fix get_common_buffer bug
>>	git bisect bad a9349315f65cd6a16e8fab1f6cf0fd40f379c4db
>>	# good: [06f837cadbcdedb45f0702cb57c99c404ae921e6] V4L/DVB (11784): cx88=
: Fix race condition between cx8800 startup and hald
>>	git bisect good 06f837cadbcdedb45f0702cb57c99c404ae921e6
>>	# good: [1339f9108a84710969903e892dcf1849ae1215cf] V4L/DVB (11726): Modi=
fy the file license to match all other Siano's files
>>	git bisect good 1339f9108a84710969903e892dcf1849ae1215cf
>>=09
>>	Best wishes
>>	Kristoffer Ericson
>>=09
>>	On Thu, 24 Sep 2009 13:07:12 -0700
>>	"Justin P. Mattock" <justinmattock@gmail.com> wrote:
>>=09
>>	> Stefan Lippers-Hollmann wrote:
>>	> > Hi
>>	> >
>>	> > CCing linux-wireless@vger.kernel.org, as it's not very likely to get
>>	> > noticed here by wireless developers.
>>	> >
>>	> > On Thursday 24 September 2009, Justin P. Mattock wrote:
>>	> >   =20
>>	> >> Kristoffer Ericson wrote:
>>	> >>     =20
>>	> >>> Greetings,
>>	> >>>
>>	> >>> When moving from vanilla 2.6.30->2.6.31 I noticed that I get dissa=
sociated from
>>	> >>> my wlan hub with regular intervalls. This did not happen on 2.6.30.
>>	> >>> I cant see any pattern aside from that it happens at regular inter=
valls
>>	> >>> (around 10-15mins). It works again when I re-identifies myself.
>>	> >>>
>>	> >>> Got an Asus 1000HE with Atheros chipset.
>>	> >>> Havent had time to bisect it, just wanted to check
>>	> >>> if this is an known issue. Ive ruled out faulty wlan hub
>>	> >>> since everything works fine when going back to 2.6.30.
>>	> >>>
>>	> >>> nothing much on dmesg:
>>	> >>> uhci_hcd 0000:00:1d.1: UHCI Host Controller
>>	> >>> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number=
 3
>>	> >>> uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d480
>>	> >>> usb usb3: configuration #1 chosen from 1 choice
>>	> >>> hub 3-0:1.0: USB hub found
>>	> >>> hub 3-0:1.0: 2 ports detected
>>	> >>> uhci_hcd 0000:00:1d.2: PCI INT C ->   GSI 18 (level, low) ->   IRQ=
 18
>>	> >>> uhci_hcd 0000:00:1d.2: setting latency timer to 64
>>	> >>> uhci_hcd 0000:00:1d.2: UHCI Host Controller
>>	> >>> uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number=
 4
>>	> >>> uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
>>	> >>> usb usb4: configuration #1 chosen from 1 choice
>>	> >>> hub 4-0:1.0: USB hub found
>>	> >>> hub 4-0:1.0: 2 ports detected
>>	> >>> uhci_hcd 0000:00:1d.3: PCI INT D ->   GSI 16 (level, low) ->   IRQ=
 16
>>	> >>> uhci_hcd 0000:00:1d.3: setting latency timer to 64
>>	> >>> uhci_hcd 0000:00:1d.3: UHCI Host Controller
>>	> >>> uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number=
 5
>>	> >>> uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d880
>>	> >>> usb usb5: configuration #1 chosen from 1 choice
>>	> >>> hub 5-0:1.0: USB hub found
>>	> >>> hub 5-0:1.0: 2 ports detected
>>	> >>> input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/=
input/input7
>>	> >>> usb 1-4: new high speed USB device using ehci_hcd and address 3
>>	> >>> usb 1-4: configuration #1 chosen from 1 choice
>>	> >>> hub 1-4:1.0: USB hub found
>>	> >>> hub 1-4:1.0: 4 ports detected
>>	> >>> usb 1-5: new high speed USB device using ehci_hcd and address 4
>>	> >>> usb 1-5: configuration #1 chosen from 1 choice
>>	> >>> usb 1-8: new high speed USB device using ehci_hcd and address 6
>>	> >>> usb 1-8: configuration #1 chosen from 1 choice
>>	> >>> Initializing USB Mass Storage driver...
>>	> >>> scsi4 : SCSI emulation for USB Mass Storage devices
>>	> >>> usbcore: registered new interface driver usb-storage
>>	> >>> USB Mass Storage support registered.
>>	> >>> usb-storage: device found at 4
>>	> >>> usb-storage: waiting for device to settle before scanning
>>	> >>> HDA Intel 0000:00:1b.0: PCI INT A ->   GSI 16 (level, low) ->   IR=
Q 16
>>	> >>> HDA Intel 0000:00:1b.0: setting latency timer to 64
>>	> >>> usb 2-2: new full speed USB device using uhci_hcd and address 2
>>	> >>> ath9k 0000:01:00.0: PCI INT A ->   GSI 19 (level, low) ->   IRQ 19
>>	> >>> ath9k 0000:01:00.0: setting latency timer to 64
>>	> >>> usb 2-2: configuration #1 chosen from 1 choice
>>	> >>> input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/inpu=
t/input8
>>	> >>> usbcore: registered new interface driver usbserial
>>	> >>> USB Serial support registered for generic
>>	> >>> usb 5-1: new full speed USB device using uhci_hcd and address 2
>>	> >>> usb 5-1: configuration #1 chosen from 1 choice
>>	> >>> usb 1-4.1: new full speed USB device using ehci_hcd and address 7
>>	> >>> ath: EEPROM regdomain: 0x60
>>	> >>> ath: EEPROM indicates we should expect a direct regpair map
>>	> >>> ath: Country alpha2 being used: 00
>>	> >>> ath: Regpair used: 0x60
>>	> >>> Bluetooth: Core ver 2.15
>>	> >>> NET: Registered protocol family 31
>>	> >>> Bluetooth: HCI device and connection manager initialized
>>	> >>> Bluetooth: HCI socket layer initialized
>>	> >>> Bluetooth: Generic Bluetooth USB driver ver 0.5
>>	> >>> usb 1-4.1: configuration #1 chosen from 1 choice
>>	> >>> usb 1-4.2: new low speed USB device using ehci_hcd and address 8
>>	> >>> usb 1-4.2: configuration #1 chosen from 1 choice
>>	> >>> usb 1-4.4: new low speed USB device using ehci_hcd and address 9
>>	> >>> usbcore: registered new interface driver hiddev
>>	> >>> input: HID 04d9:1203 as /devices/pci0000:00/0000:00:1d.7/usb1/1-4/=
1-4.2/1-4.2:1.0/input/input9
>>	> >>> generic-usb 0003:04D9:1203.0001: input,hidraw0: USB HID v1.11 Keyb=
oard [HID 04d9:1203] on usb-0000:00:1d.7-4.2/input0
>>	> >>> input: HID 04d9:1203 as /devices/pci0000:00/0000:00:1d.7/usb1/1-4/=
1-4.2/1-4.2:1.1/input/input10
>>	> >>> generic-usb 0003:04D9:1203.0002: input,hidraw1: USB HID v1.11 Devi=
ce [HID 04d9:1203] on usb-0000:00:1d.7-4.2/input1
>>	> >>> usbcore: registered new interface driver usbhid
>>	> >>> usbhid: v2.6:USB HID core driver
>>	> >>> usb 1-4.4: configuration #1 chosen from 1 choice
>>	> >>> input: B16_b_02 USB-PS/2 Optical Mouse as /devices/pci0000:00/0000=
:00:1d.7/usb1/1-4/1-4.4/1-4.4:1.0/input/input11
>>	> >>> generic-usb 0003:046D:C025.0003: input,hidraw2: USB HID v1.10 Mous=
e [B16_b_02 USB-PS/2 Optical Mouse] on usb-0000:00:1d.7-4.4/input0
>>	> >>> usbcore: registered new interface driver btusb
>>	> >>> usbcore: registered new interface driver usbserial_generic
>>	> >>> usbserial: USB Serial Driver core
>>	> >>> USB Serial support registered for GSM modem (1-port)
>>	> >>> option 2-2:1.0: GSM modem (1-port) converter detected
>>	> >>> usb 2-2: GSM modem (1-port) converter now attached to ttyUSB0
>>	> >>> option 2-2:1.1: GSM modem (1-port) converter detected
>>	> >>> usb 2-2: GSM modem (1-port) converter now attached to ttyUSB1
>>	> >>> usbcore: registered new interface driver option
>>	> >>> option: v0.7.2:USB Driver for GSM modems
>>	> >>> USB Serial support registered for pl2303
>>	> >>> pl2303 1-4.1:1.0: pl2303 converter detected
>>	> >>> usb 1-4.1: pl2303 converter now attached to ttyUSB2
>>	> >>> usbcore: registered new interface driver pl2303
>>	> >>> pl2303: Prolific PL2303 USB to serial adaptor driver
>>	> >>> phy0: Selected rate control algorithm 'ath9k_rate_control'
>>	> >>> Registered led device: ath9k-phy0::radio
>>	> >>> Registered led device: ath9k-phy0::assoc
>>	> >>> Registered led device: ath9k-phy0::tx
>>	> >>> Registered led device: ath9k-phy0::rx
>>	> >>> phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=3D0xf88800=
00, irq=3D19
>>	> >>> scsi 4:0:0:0: Direct-Access     Single   Flash Reader     1.00 PQ:=
 0 ANSI: 0
>>	> >>> sd 4:0:0:0: Attached scsi generic sg1 type 0
>>	> >>> sd 4:0:0:0: [sdb] 15954944 512-byte logical blocks: (8.16 GB/7.60 =
GiB)
>>	> >>> usb-storage: device scan complete
>>	> >>> sd 4:0:0:0: [sdb] Write Protect is off
>>	> >>> sd 4:0:0:0: [sdb] Mode Sense: 03 00 00 00
>>	> >>> sd 4:0:0:0: [sdb] Assuming drive cache: write through
>>	> >>> sd 4:0:0:0: [sdb] Assuming drive cache: write through
>>	> >>>    sdb: sdb1
>>	> >>> sd 4:0:0:0: [sdb] Assuming drive cache: write through
>>	> >>> sd 4:0:0:0: [sdb] Attached SCSI removable disk
>>	> >>> EXT3-fs warning: maximal mount count reached, running e2fsck is re=
commended
>>	> >>> EXT3 FS on sda1, internal journal
>>	> >>> Bluetooth: L2CAP ver 2.13
>>	> >>> Bluetooth: L2CAP socket layer initialized
>>	> >>> Bluetooth: SCO (Voice Link) ver 0.6
>>	> >>> Bluetooth: SCO socket layer initialized
>>	> >>> Bluetooth: BNEP (Ethernet Emulation) ver 1.3
>>	> >>> Bridge firewalling registered
>>	> >>> Bluetooth: RFCOMM TTY layer initialized
>>	> >>> Bluetooth: RFCOMM socket layer initialized
>>	> >>> Bluetooth: RFCOMM ver 1.11
>>	> >>> ATL1E 0000:03:00.0: irq 27 for MSI/MSI-X
>>	> >>> fuse init (API version 7.12)
>>	> >>> ip_tables: (C) 2000-2006 Netfilter Core Team
>>	> >>> nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
>>	> >>> CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please u=
se
>>	> >>> nf_conntrack.acct=3D1 kernel parameter, acct=3D1 nf_conntrack modu=
le option or
>>	> >>> sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
>>	> >>> wlan0: authenticate with AP 00:14:7c:ae:d1:90
>>	> >>> wlan0: authenticated
>>	> >>> wlan0: associate with AP 00:14:7c:ae:d1:90
>>	> >>> wlan0: RX AssocResp from 00:14:7c:ae:d1:90 (capab=3D0x431 status=
=3D0 aid=3D5)
>>	> >>> wlan0: associated
>>	> >>> PPP generic driver version 2.4.2
>>	> >>> NET: Registered protocol family 10
>>	> >>> lo: Disabled Privacy Extensions
>>	> >>> ADDRCONF(NETDEV_UP): eth0: link is not ready
>>	> >>> PPP BSD Compression module registered
>>	> >>> PPP Deflate Compression module registered
>>	> >>> wlan0: no IPv6 routers present
>>	> >>> CE: hpet increasing min_delta_ns to 15000 nsec
>>	> >>> wlan0: no probe response from AP 00:14:7c:ae:d1:90 - disassociating
>>	> >>> wlan0: authenticate with AP 00:14:7c:ae:d1:90
>>	> >>> wlan0: authenticated
>>	> >>> wlan0: associate with AP 00:14:7c:ae:d1:90
>>	> >>> wlan0: RX AssocResp from 00:14:7c:ae:d1:90 (capab=3D0x431 status=
=3D0 aid=3D5)
>>	> >>> wlan0: associated
>>	> >>> wlan0: authenticate with AP 00:14:7c:ae:d1:90
>>	> >>> wlan0: authenticated
>>	> >>> wlan0: associate with AP 00:14:7c:ae:d1:90
>>	> >>> wlan0: RX AssocResp from 00:14:7c:ae:d1:90 (capab=3D0x431 status=
=3D0 aid=3D5)
>>	> >>> wlan0: associated
>>	> >>> [kristoffer@boggieman wine.git]$
>>	> >>>
>>	> >>>
>>	> >>>
>>	> >>>       =20
>>	> >> yeah I'm seeing this with my macbook pro(ath9k)
>>	> >> while streaming music, all of a sudden things just crap out.
>>	> >> (not sure if this is why, or something else).
>>	> >>
>>	> >> Justin P. Mattock
>>	> >>     =20
>>	> >
>>	> > I'm getting similar reports for iwl3945 and 2.6.31.[01], but can't c=
onfirm
>>	> > this on my own (non-iwl{3945,agn}, non-ath9k) hardware yet.
>>	> >
>>	> > Regards
>>	> > 	Stefan Lippers-Hollmann
>>	> >
>>	> >   =20
>>	> I don't mind doing a bisect from 30 - present, but first I need to
>>	> do some other stuff.
>>	>=20
>>	> Justin P. Mattock
>>=09
>>=09
>>	--=20
>>	Kristoffer Ericson <kristoffer.ericson@gmail.com>
>>	--
>>	To unsubscribe from this list: send the line "unsubscribe linux-kernel" =
in
>>	the body of a message to majordomo@vger.kernel.org
>>	More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>	Please read the FAQ at  http://www.tux.org/lkml/
End of included message



--=20
twalberg@comcast.net

--adlATi0AGRzVk0TM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrNPI8ACgkQw+Wcj22rJWb2fACeNV14VlZkJ5jX6RbcJjqquvp7
Nh0AnjJxb9xXRHftL99U2WAMi5n/OZOp
=W57u
-----END PGP SIGNATURE-----

--adlATi0AGRzVk0TM--
