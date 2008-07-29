Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbYG2McT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbYG2McT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYG2McI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:32:08 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35137 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYG2McH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:32:07 -0400
Subject: Re: [BUG] wireless : cpu stuck for 61s
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20080729055731.GA3265@darkstar> (sfid-20080729_075630_082047_A76939B2)
References: <20080729055731.GA3265@darkstar>
	 (sfid-20080729_075630_082047_A76939B2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kyWXSlAmbCdnLeYTI2Qr"
Date: Tue, 29 Jul 2008 14:32:04 +0200
Message-Id: <1217334724.10489.47.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kyWXSlAmbCdnLeYTI2Qr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 13:57 +0800, Dave Young wrote:
> While set my wlan0 to ad-hoc mode and then set the essid to something,
> this bug triggered.
>=20
> I suspect it's related to debugfs or mutex? But I'm not sure.
>=20
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493] BUG: soft lockup - CPU#0 =
stuck for 61s! [events/0:9]
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493]=20
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493] Pid: 9, comm: events/0 Ta=
inted: G        W (2.6.26-smp #3)
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EIP: 0060:[<c0450bc3>] EF=
LAGS: 00000246 CPU: 0
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EIP is at mutex_lock_nest=
ed+0x1b3/0x280
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493] EAX: 00000000 EBX: f7bf52=
84 ECX: f7c7e000 EDX: f7bf52a8
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493] ESI: f7bf5288 EDI: 000002=
46 EBP: f7c7fedc ESP: f7c7fe9c
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  DS: 007b ES: 007b FS: 00=
d8 GS: 0000 SS: 0068
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493] CR0: 8005003b CR2: b800c5=
ac CR3: 36e71000 CR4: 000006d0
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493] DR0: 00000000 DR1: 000000=
00 DR2: 00000000 DR3: 00000000
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493] DR6: ffff0ff0 DR7: 000004=
00
> Jul 29 13:01:46 darkstar kernel: [ 8033.736493]  [<c02375a6>] ? debugfs_c=
reate_file+0x46/0x210

It looks like it's getting stuck on
mutex_lock(&parent->d_inode->i_mutex);

inside debugfs_create_by_name, but I have no idea why that would happen.

johannes

--=-kyWXSlAmbCdnLeYTI2Qr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjw3BAAoJEKVg1VMiehFYOZwP/11dY3jSjsgijyXBZjeB+Kn6
dCiil4c110dgMF/Q1e1vO/RaGc9pQPfx0vagFPGFYVszGUF36EXmPBMlB2XdT22k
K3HCnmxFYxqPekWnxS1RNAJO5B6jxQzu0qpnIm5inO9XH/HrEv4MJh2e2A7+1PHb
clHVn1dl4srQBytqPxvRomKMjIggvUGywYSP0yLYxO3S5VzQlWu1mkeOqS6jHgaz
O30MusmWIFdmXkArYlpSJvRc9oKpjKph77xb5FpP/EhWjWyAERaDZQcuTO/0VDZL
laJYI6c1cNmEZY7If7jv19huPYiAZMtCW3F5U/DkNHEPZRK/+SQgtzhWEp2MGqmk
fpTanM9koK2XXS0wk+dySLavTcXRRDduQ+225Iv58A2MSIOisOB4TzTFpGkxdfsI
YPn8AzdV8/bxwfSVy3RLehE2MppoUkneAzSvufm+XYyOk/4mmUBRTlmIYZrIZMhG
/k/Ui6blIaN1fcaQ1uFDod13Bz0UdBletodXf8dgIwdon7bZS6TUziTqCBz6zEj9
98Zf35D/1Yu0G85rBfNqHw4cluehpnqf2xkuFe6Bz3+hFrCPWoPw1O8lH+Tpx1E+
ykCakCZfDdZnKEeKR/RS+zETrBlOUny8ipeeFviaZRDqYGzGWEvigINmZoegTUeY
5UfVH0Rbx/uu/kF5Hfs8
=/HPO
-----END PGP SIGNATURE-----

--=-kyWXSlAmbCdnLeYTI2Qr--

