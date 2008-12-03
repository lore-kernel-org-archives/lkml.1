Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYLCLuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYLCLuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYLCLuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:50:00 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:36193 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYLCLt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:49:59 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :IWUQZkOgW+3CqJDygERk+CxWRHhOt44/ODBTDQK7pLSymoIa1YEVchgk6u1gmGQ8
Subject: "Artem Onair Comcard 11": Variation found!
From: Michael Jarosch <mitsch@riotmusic.de>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tFjHtfgvM+p52LoPtYpl"
Organization: Riot-Music
Date: Wed, 03 Dec 2008 12:49:55 +0100
Message-Id: <1228304996.8921.93.camel@cat>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tFjHtfgvM+p52LoPtYpl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi there!

I recently bought a WLAN-PCMCIA-adaptor from Ebay, named "ARtem Onair
Comcard 11", which is reported to work with linux on several places in
the internet. Well - my special card doesn't work. But this is not a
"How can I get my device to work with Linux" issue, I promise! I did
some investigation about this card, which I want to tell you, and I hope
that this will help someone of the kernel-team to get things right!

O.k. - here's what I found:

My card's got an alternate label on the backside, saying:
"CC-W11-EMB PC-ETS-128"

The modalias of the card looks like this:
#cat /sys/bus/pcmcia/devices/1.0/modalias
pcmcia:m0268c0003f06fn00pfn00pa7CE6F45Bpb427B2E41pc3284C1FFpd00000000

The PCMCIA-Subsystem of a recent Kernel (2.6.26) prints out:
#pccard ident
Socket 1:
     product info: "ARtem", "Onair", "Version 1.0", ""
     manfid: 0x0268, 0x0003
     function: 6 (network)

When I plug this card to my Debian Laptop, there won't happen that much.
No module is loaded. The kernel just prints out some stuff
to /var/log/syslog, saying:

kernel: pccard: PCMCIA card inserted into slot 1
kernel: cs: memory probe 0xa0000000-0xa0ffffff: clean.
kernel: pcmcia: registering new device pcmcia1.0

No big surprise: There is no kernel module with a fitting modalias!


I also tried this card with Deli-Linux 0.7, a distro, which is specially
made for old Devices. It uses the 2.4.34.4 kernel. There's also no
module loading when plugging in the card - initially.
In the PCMCIA configuration file /etc/pcmcia/config I found something
interesting:

card "ARtem Onair Version 1.0"
   #version "ARtem", "Onair", "Version 1.0"
   manfid 0x0268, 0x0001
   bind "orinoco_cs"

which says to me that another Version of the ARtem Onair card with the
same chipset, but another manfid would just work. I edited the file and
changed the manfid from 0x0001 to 0x0003 and restarted the
pcmcia-daemon. When I now plug the card in, the modules "orinoco_cs",
"orinoco" and "hermes" are loaded and I get a network device, named
eth0. Now I can do some configuration with iwconfig. I also tried
changing the driver to "wavelan_cs" (because of an entry on
tuxmobil.org, look here: http://tuxmobil.org/pcmcia_ci10339.html ) -
looks the same to me.

I don't know if this card does perfectly work with this driver. Scanning
(with "iwlist eth0 scanning") is not supported and I can get no
WEP-connection with any accesspoints at home - simply because there
aren't any accesspoints that supports WEP. There would be some WPA2-APs,
but the package wpa-supplicant is not included in Deli-Linux. So: I
haven't managed to get a wifi-connection with this card and these
drivers!

BUT: It doesn't seem to my that support for this card on a recent kernel
is far away. And maybe someone with better capabilities than me should
get this thing done.

I'm very interested in helping! I want this device working, so don't
hesitate asking me!

greetings
Mitsch Jarosch

--=-tFjHtfgvM+p52LoPtYpl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk2cmMACgkQNFzJVOwishnAqgCdE1L65qlW4fQfKo8G5prMEYB0
m9EAn2u4opxMTySw0tPnlZ7/DsLAc0/2
=3dgr
-----END PGP SIGNATURE-----

--=-tFjHtfgvM+p52LoPtYpl--

