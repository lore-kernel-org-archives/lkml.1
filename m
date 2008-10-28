Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYJ1QYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYJ1QYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYJ1QYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:24:37 -0400
Received: from mail.gmx.net ([213.165.64.20]:39757 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752496AbYJ1QYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:24:35 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1/8C9otVNj8w8nmSv+tFUUR97FkIKoOyLCkITdlZA
	DWesdk2neGhLdk
Date: Tue, 28 Oct 2008 17:24:18 +0100
From: Mirco Tischler <mt-ml@gmx.de>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
Message-ID: <20081028172418.3c8e91f1@mtlp.12.dimension>
In-Reply-To: <1225171414.2917.229.camel@debian.sh.intel.com>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	<1225157618.2917.215.camel@debian.sh.intel.com>
	<20081027213217.53558319@infradead.org>
	<1225171414.2917.229.camel@debian.sh.intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QYcKPLFonHn/Ijg6q/W=P3d";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QYcKPLFonHn/Ijg6q/W=P3d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2008 13:23:34 +0800, Zhu Yi wrote:
> On Mon, 2008-10-27 at 22:32 -0600, Arjan van de Ven wrote:
> > I had this same issue
> >=20
> > turning on CONFIG_WIRELESS_OLD_REGULATORY fixed it for me....
>=20
> Arjan,
>=20
> This is a different bug. He has the wireless worked sometimes.
>=20
> I think your problem relates to 5GHz channel usage. We have already a
> patch queued to resolve the problem. We will have regulatory framework
> reworked to better solve the problem. But I guess it will be in .29 time
> frame.
>=20
> Thanks,
> -yi
I tested Arjan's solution nevertheless and it seems to do the job. I can't =
find
the "TX Power requested" line anymore on dmesg output with that config opti=
on
enabled anymore and it connects without problems.
This is how it looks now:
[  777.680750] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux,1.3=
.27kds=20
[  777.680753] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[  777.680878] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ=
 18
[  777.680908] iwlagn 0000:06:00.0: setting latency timer to 64
[  777.680977] iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=3D0x4
[  777.731255] iwlagn: Tunable channels: 13 802.11bg, 19 802.11a channels
[  777.732432] phy1: Selected rate control algorithm 'iwl-agn-rs'
[  781.764539] iwlagn 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ=
 18
[  781.764821] iwlagn 0000:06:00.0: irq 41 for MSI/MSI-X
[  781.764919] iwlagn 0000:06:00.0: firmware: requesting iwlwifi-4965-2.uco=
de
[  781.980719] Registered led device: iwl-phy1:radio
[  781.980764] Registered led device: iwl-phy1:assoc
[  781.980808] Registered led device: iwl-phy1:RX
[  781.980856] Registered led device: iwl-phy1:TX
[  782.014001] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  783.633713] wlan0: authenticate with AP 00:c0:a8:e5:e5:a5
[  783.635637] wlan0: authenticated
[  783.635644] wlan0: associate with AP 00:c0:a8:e5:e5:a5
[  783.642770] wlan0: RX AssocResp from 00:c0:a8:e5:e5:a5 (capab=3D0x431 st=
atus=3D0
aid=3D1)=20
[  783.642776] wlan0: associated [  783.669684] ADDRCONF(NETDEV_CHANGE): wl=
an0:
link becomes ready

I tested it quickly and not very thoroughly on the wpa-eap encrypted networ=
k at
university and it showed the same behaviour: no connection without
CONFIG_WIRELESS_OLD_REGULATORY and no problems with it enabled.

Thanks
Mirco

--Sig_/QYcKPLFonHn/Ijg6q/W=P3d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkHPL4ACgkQz+diZ7c2xfjQnACeMmJUXCPSWQKkVDfR80db4Rwj
7k4An1TJLd7OuByRyuO02uRpSkWVdDH+
=ODct
-----END PGP SIGNATURE-----

--Sig_/QYcKPLFonHn/Ijg6q/W=P3d--
