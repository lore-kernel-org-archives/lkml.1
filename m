Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbYGFFfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbYGFFfh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 01:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYGFFf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 01:35:29 -0400
Received: from mx33.mail.ru ([194.67.23.194]:18030 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbYGFFf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 01:35:28 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
Date: Sun, 6 Jul 2008 09:35:20 +0400
User-Agent: KMail/1.9.9
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <200807051108.20183.arvidjaar@mail.ru> <200807060859.58971.arvidjaar@mail.ru> <alpine.LFD.1.10.0807052212200.3016@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807052212200.3016@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1303995.QB4Be2PazE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807060935.21678.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1303995.QB4Be2PazE
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 06 July 2008, Linus Torvalds wrote:
>=20
> On Sun, 6 Jul 2008, Andrey Borzenkov wrote:
>=20
> > On Sunday 06 July 2008, Linus Torvalds wrote:
> > >=20
> > > But Andrey - if you are on-line and have access to the machine, one t=
hing=20
> > > to try would be to just do a=20
> > >=20
> > > 	git revert e872154921a6b5
> > >=20
> > > in case it really was that particular commit. It seems to revert clea=
nly=20
> > > (although I didn't actually check if the result then compiled/worked).
> >=20
> > Looks much better; I am writing this now under 2.6.26-rc8 with above
> > commit reverted.
>=20
> Ok, that's certainly pretty conclusive. Thanks for the great console logs=
=20
> making it so straightforward to narrow it down to this (even if it was=20
> just a wild guess - with your extensive logs it was still fairly=20
> informed).
>=20
> Greg, Alan, David - at this point I think the commit should just be=20
> reverted. We're past -rc9, and unless either of you can see some obvious=
=20
> alternate fix (eg some bug in the commit that explains Adrey's problems=20
> that can just be fixed), I'm not seeing any good alternatives.
>=20
> I don't know what the hardware details are, but based on the bootup=20
> messages it seems to be a Toshiba motherboatd with an ALI 1535 chipset - =
I=20
> think it's a Toshiba Portege 4000 (which would mean that the OHCI=20
> controlle is the ALI M5237).
>=20

yes

{pts/0}% lspci -nn
00:00.0 Host bridge [0600]: ALi Corporation M1644/M1644T Northbridge+Triden=
t [10b9:1644] (rev 01)
00:01.0 PCI bridge [0604]: ALi Corporation PCI to AGP Controller [10b9:5247]
00:02.0 USB Controller [0c03]: ALi Corporation USB 1.1 Controller [10b9:523=
7] (rev 03)
00:04.0 IDE interface [0101]: ALi Corporation M5229 IDE [10b9:5229] (rev c3)
00:06.0 Multimedia audio controller [0401]: ALi Corporation M5451 PCI AC-Li=
nk Controller Audio Device [10b9:5451] (rev 01)
00:07.0 ISA bridge [0601]: ALi Corporation M1533/M1535 PCI to ISA Bridge [A=
laddin IV/V/V+] [10b9:1533]
00:08.0 Bridge [0680]: ALi Corporation M7101 Power Management Controller [P=
MU] [10b9:7101]
00:0a.0 Ethernet controller [0200]: Intel Corporation 82557/8/9/0/1 Etherne=
t Pro 100 [8086:1229] (rev 08)
00:10.0 CardBus bridge [0607]: Texas Instruments PCI1410 PC card Cardbus Co=
ntroller [104c:ac50] (rev 01)
00:11.0 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI to=
 Cardbus Bridge with ZV Support [1179:0617] (rev 32)
00:11.1 CardBus bridge [0607]: Toshiba America Info Systems ToPIC100 PCI to=
 Cardbus Bridge with ZV Support [1179:0617] (rev 32)
00:12.0 System peripheral [0880]: Toshiba America Info Systems SD TypA Cont=
roller [1179:0805] (rev 03)
01:00.0 VGA compatible controller [0300]: Trident Microsystems CyberBlade X=
PAi1 [1023:8820] (rev 82)

Handle 0x0001, DMI type 1, 25 bytes
System Information
        Manufacturer: TOSHIBA
        Product Name: PORTEGE 4000
        Version: PP400E-0CJPX-0V
        Serial Number: Z1109698G
        UUID: 440FA000-001B-11D6-8000-C3D0A1109698
        Wake-up Type: Power Switch



> For all I know, that may not be the best possible chipset out there, but=
=20
> it's not something extremely odd either. The machine may be a bit long in=
=20
> the tooth by now (I think it's a 750MHz PIII in there), but that may also=
=20
> explain why most developers wouldn't have seen this issue..
>=20
> Hmm?
>=20
> 			Linus
>=20
>=20



--nextPart1303995.QB4Be2PazE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhwWZkACgkQR6LMutpd94xqSgCfUd9ppQIf6jyEqI3ylsU393Jr
O8AAmwYX4L7bg9mTd3Zyfs9H66gLYORT
=Wes4
-----END PGP SIGNATURE-----

--nextPart1303995.QB4Be2PazE--
