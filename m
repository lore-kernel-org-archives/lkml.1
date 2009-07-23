Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZGWUXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZGWUXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 16:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZGWUXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 16:23:32 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56502 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZGWUXb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 16:23:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: 31-rc3-mmotm0716 - dead USB trackball mouse kills entire system
In-Reply-To: Your message of "Thu, 23 Jul 2009 14:19:59 EDT."
             <Pine.LNX.4.44L0.0907231416170.3509-100000@iolanthe.rowland.org>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.44L0.0907231416170.3509-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248380585_2742P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Jul 2009 16:23:05 -0400
Message-ID: <7895.1248380585@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248380585_2742P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jul 2009 14:19:59 EDT, Alan Stern said:

> > The =22can't reset device=22 is apparently new with mm-0716 - I've no=
t seen it
> > before in at least the 6 weeks my logs go back.
>=20
> I don't think it is new.  You might try using an older kernel with your=
=20
> decaying trackball to see.

Umm.. I've *been* using it with older kernels for *months*.  Not a *singl=
e*
hit in my logs, which go back till June 10.  Except for today, when I sta=
rted
running -0716, and now I've gotten hit by the same messages, and then
the same hang 4 times today.

So either the codepath in -0716 is different from -0702 and -0604 and -05=
17 and
every other -mm before, or the trackball spontaneously developed a *diffe=
rent*
behavior overnight at the same time I upgraded the kernel.

See the logs below...

> This is a bug.  For more discussion see this thread:
>=20
> 	http://marc.info/?t=3D124807676700001&r=3D1&w=3D2
>=20
> You should try the patch given there.

OK, will do that, see if it improves things...

The logs back to June 10 (and I was on vacation Jun 20-26):

% egrep -h 'USB disc=7Creset device' mess* =7C grep -e '-8.3'
Jun 10 12:05:22 turing-police kernel: =5B93125.340042=5D usb 1-8.3: USB d=
isconnect, address 7
Jun 11 16:26:48 turing-police kernel: =5B195210.844332=5D usb 1-8.3: USB =
disconnect, address 8
Jun 11 16:56:12 turing-police kernel: =5B196975.450198=5D usb 1-8.3: USB =
disconnect, address 9
Jun 12 12:20:58 turing-police kernel: =5B266860.805915=5D usb 1-8.3: USB =
disconnect, address 10
Jun 12 12:20:58 turing-police kernel: =5B266861.317793=5D usb 1-8.3: USB =
disconnect, address 11
Jun 12 12:21:00 turing-police kernel: =5B266862.853911=5D usb 1-8.3: USB =
disconnect, address 13
Jun 13 00:04:40 turing-police kernel: =5B309083.085168=5D usb 1-8.3: USB =
disconnect, address 15
Jun 13 00:19:00 turing-police kernel: =5B309943.499877=5D usb 1-8.3: USB =
disconnect, address 16
Jun 13 21:00:08 turing-police kernel: =5B384411.506588=5D usb 1-8.3: USB =
disconnect, address 17
Jun 14 02:39:04 turing-police kernel: =5B404747.349968=5D usb 1-8.3: USB =
disconnect, address 18
Jun 15 11:34:12 turing-police kernel: =5B  130.073577=5D usb 1-8.3: USB d=
isconnect, address 7
Jun 16 11:28:07 turing-police kernel: =5B 7224.839479=5D usb 1-8.3: USB d=
isconnect, address 7
Jun 16 11:33:36 turing-police kernel: =5B 7553.542989=5D usb 1-8.3: USB d=
isconnect, address 8
Jun 16 12:44:40 turing-police kernel: =5B11817.473391=5D usb 1-8.3: USB d=
isconnect, address 9
Jun 16 14:07:39 turing-police kernel: =5B16796.411826=5D usb 1-8.3: USB d=
isconnect, address 10
Jun 16 14:36:44 turing-police kernel: =5B18541.305681=5D usb 1-8.3: USB d=
isconnect, address 11
Jun 16 15:11:47 turing-police kernel: =5B20644.855582=5D usb 1-8.3: USB d=
isconnect, address 12
Jun 16 16:23:58 turing-police kernel: =5B24975.602702=5D usb 1-8.3: USB d=
isconnect, address 14
Jun 17 14:48:21 turing-police kernel: =5B12850.443754=5D usb 1-8.3: USB d=
isconnect, address 6
Jun 18 15:11:55 turing-police kernel: =5B15216.375804=5D usb 1-8.3: USB d=
isconnect, address 5
Jun 18 16:20:42 turing-police kernel: =5B19342.578643=5D usb 1-8.3: USB d=
isconnect, address 6
Jun 18 16:25:16 turing-police kernel: =5B19616.498551=5D usb 1-8.3: USB d=
isconnect, address 7
Jun 19 10:18:42 turing-police kernel: =5B  435.712336=5D usb 1-8.3: USB d=
isconnect, address 6
Jun 26 21:25:42 turing-police kernel: =5B 1023.223891=5D usb 1-8.3: USB d=
isconnect, address 6
Jun 26 22:12:18 turing-police kernel: =5B 3818.996721=5D usb 1-8.3: USB d=
isconnect, address 7
Jun 27 01:04:11 turing-police kernel: =5B14131.683456=5D usb 1-8.3: USB d=
isconnect, address 8
Jun 27 09:25:54 turing-police kernel: =5B44234.915415=5D usb 1-8.3: USB d=
isconnect, address 10
Jun 27 11:28:31 turing-police kernel: =5B51591.295831=5D usb 1-8.3: USB d=
isconnect, address 11
Jun 29 15:05:58 turing-police kernel: =5B19491.827368=5D usb 1-8.3: USB d=
isconnect, address 6
Jun 29 15:05:59 turing-police kernel: =5B19492.851261=5D usb 1-8.3: USB d=
isconnect, address 7
Jun 29 15:42:29 turing-police kernel: =5B21683.439937=5D usb 1-8.3: USB d=
isconnect, address 8
Jun 29 15:48:50 turing-police kernel: =5B22064.111496=5D usb 1-8.3: USB d=
isconnect, address 9
Jun 29 16:23:31 turing-police kernel: =5B24145.644821=5D usb 1-8.3: USB d=
isconnect, address 10
Jun 29 16:59:37 turing-police kernel: =5B26311.402052=5D usb 1-8.3: USB d=
isconnect, address 11
Jun 29 18:18:01 turing-police kernel: =5B31015.595575=5D usb 1-8.3: USB d=
isconnect, address 12
Jun 29 19:10:49 turing-police kernel: =5B34183.724930=5D usb 1-8.3: USB d=
isconnect, address 15
Jun 29 21:51:55 turing-police kernel: =5B43848.890868=5D usb 1-8.3: USB d=
isconnect, address 20
Jun 29 22:10:23 turing-police kernel: =5B44957.650230=5D usb 1-8.3: USB d=
isconnect, address 29
Jun 30 11:55:54 turing-police kernel: =5B 4831.052171=5D usb 1-8.3: USB d=
isconnect, address 6
Jun 30 15:10:30 turing-police kernel: =5B16507.465867=5D usb 1-8.3: USB d=
isconnect, address 7
Jul  2 13:11:54 turing-police kernel: =5B 7093.765139=5D usb 1-8.3: USB d=
isconnect, address 5
Jul  2 13:24:23 turing-police kernel: =5B 7843.076442=5D usb 1-8.3: USB d=
isconnect, address 6
Jul  2 14:03:02 turing-police kernel: =5B10161.665586=5D usb 1-8.3: USB d=
isconnect, address 7
Jul  2 15:51:35 turing-police kernel: =5B 5852.438552=5D usb 1-8.3: USB d=
isconnect, address 5
Jul  2 18:20:12 turing-police kernel: =5B14769.420729=5D usb 1-8.3: USB d=
isconnect, address 6
Jul  2 21:39:05 turing-police kernel: =5B 1644.983724=5D usb 1-8.3: USB d=
isconnect, address 6
Jul  2 22:38:32 turing-police kernel: =5B 5212.596444=5D usb 1-8.3: USB d=
isconnect, address 7
Jul  2 22:42:12 turing-police kernel: =5B 5431.732078=5D usb 1-8.3: USB d=
isconnect, address 8
Jul  2 22:43:35 turing-police kernel: =5B 5514.931740=5D usb 1-8.3: USB d=
isconnect, address 9
Jul  2 22:46:46 turing-police kernel: =5B 5706.675404=5D usb 1-8.3: USB d=
isconnect, address 10
Jul  2 22:54:17 turing-police kernel: =5B 6157.235123=5D usb 1-8.3: USB d=
isconnect, address 11
Jul  3 00:40:51 turing-police kernel: =5B12551.590521=5D usb 1-8.3: USB d=
isconnect, address 12
Jul  3 04:41:35 turing-police kernel: =5B26995.348790=5D usb 1-8.3: USB d=
isconnect, address 13
Jul  3 04:54:14 turing-police kernel: =5B27754.644344=5D usb 1-8.3: USB d=
isconnect, address 14
Jul  3 05:37:13 turing-police kernel: =5B30332.816530=5D usb 1-8.3: USB d=
isconnect, address 19
Jul  3 06:09:58 turing-police kernel: =5B  855.410519=5D usb 1-8.3: USB d=
isconnect, address 6
Jul  3 11:20:07 turing-police kernel: =5B19463.514881=5D usb 1-8.3: USB d=
isconnect, address 7
Jul  3 11:20:31 turing-police kernel: =5B19488.346840=5D usb 1-8.3: USB d=
isconnect, address 8
Jul  3 11:40:13 turing-police kernel: =5B20669.529547=5D usb 1-8.3: USB d=
isconnect, address 9
Jul  3 12:17:10 turing-police kernel: =5B22886.486471=5D usb 1-8.3: USB d=
isconnect, address 10
Jul  3 16:11:42 turing-police kernel: =5B36958.528807=5D usb 1-8.3: USB d=
isconnect, address 11
Jul  3 16:13:48 turing-police kernel: =5B37085.240866=5D usb 1-8.3: USB d=
isconnect, address 12
Jul  3 17:06:06 turing-police kernel: =5B40222.779998=5D usb 1-8.3: USB d=
isconnect, address 13
Jul  3 17:12:54 turing-police kernel: =5B40631.099400=5D usb 1-8.3: USB d=
isconnect, address 14
Jul  6 11:43:47 turing-police kernel: =5B 3292.581525=5D usb 1-8.3: USB d=
isconnect, address 7
Jul  6 15:55:33 turing-police kernel: =5B18398.609861=5D usb 1-8.3: USB d=
isconnect, address 8
Jul  6 15:55:34 turing-police kernel: =5B18399.633879=5D usb 1-8.3: USB d=
isconnect, address 9
Jul  6 16:20:52 turing-police kernel: =5B19917.199664=5D usb 1-8.3: USB d=
isconnect, address 16
Jul  6 19:37:06 turing-police kernel: =5B31691.647785=5D usb 1-8.3: USB d=
isconnect, address 18
Jul  7 13:15:15 turing-police kernel: =5B10368.686517=5D usb 1-8.3: USB d=
isconnect, address 6
Jul  7 13:20:42 turing-police kernel: =5B10695.597919=5D usb 1-8.3: USB d=
isconnect, address 7
Jul  7 13:46:18 turing-police kernel: =5B12232.439811=5D usb 1-8.3: USB d=
isconnect, address 8
Jul  8 12:22:37 turing-police kernel: =5B11966.920540=5D usb 1-8.3: USB d=
isconnect, address 6
Jul  8 12:23:18 turing-police kernel: =5B12008.648501=5D usb 1-8.3: USB d=
isconnect, address 7
Jul  8 12:29:33 turing-police kernel: =5B12383.688085=5D usb 1-8.3: USB d=
isconnect, address 8
Jul  8 13:01:59 turing-police kernel: =5B14329.542468=5D usb 1-8.3: USB d=
isconnect, address 9
Jul  8 14:00:05 turing-police kernel: =5B17815.233490=5D usb 1-8.3: USB d=
isconnect, address 10
Jul  8 14:06:47 turing-police kernel: =5B18217.152988=5D usb 1-8.3: USB d=
isconnect, address 11
Jul  8 15:01:42 turing-police kernel: =5B21511.868495=5D usb 1-8.3: USB d=
isconnect, address 14
Jul  8 15:55:06 turing-police kernel: =5B24715.820705=5D usb 1-8.3: USB d=
isconnect, address 15
Jul  8 16:59:17 turing-police kernel: =5B28567.109854=5D usb 1-8.3: USB d=
isconnect, address 17
Jul  8 17:27:27 turing-police kernel: =5B30257.626040=5D usb 1-8.3: USB d=
isconnect, address 18
Jul  9 11:38:23 turing-police kernel: =5B 3296.205121=5D usb 1-8.3: USB d=
isconnect, address 6
Jul  9 11:38:46 turing-police kernel: =5B 3319.757056=5D usb 1-8.3: USB d=
isconnect, address 7
Jul  9 13:50:46 turing-police kernel: =5B11239.107773=5D usb 1-8.3: USB d=
isconnect, address 8
Jul  9 14:48:14 turing-police kernel: =5B14687.194044=5D usb 1-8.3: USB d=
isconnect, address 9
Jul  9 15:24:35 turing-police kernel: =5B16868.796504=5D usb 1-8.3: USB d=
isconnect, address 11
Jul  9 15:45:28 turing-police kernel: =5B18120.955889=5D usb 1-8.3: USB d=
isconnect, address 15
Jul  9 15:45:54 turing-police kernel: =5B18147.258735=5D usb 1-8.3: USB d=
isconnect, address 19
Jul  9 17:18:20 turing-police kernel: =5B23693.746921=5D usb 1-8.3: USB d=
isconnect, address 20
Jul  9 17:25:27 turing-police kernel: =5B24120.242364=5D usb 1-8.3: USB d=
isconnect, address 21
Jul 10 15:31:33 turing-police kernel: =5B17313.732647=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 10 16:44:31 turing-police kernel: =5B21691.327035=5D usb 1-8.3: USB d=
isconnect, address 7
Jul 10 17:06:21 turing-police kernel: =5B23001.533485=5D usb 1-8.3: USB d=
isconnect, address 9
Jul 10 17:28:37 turing-police kernel: =5B24337.339792=5D usb 1-8.3: USB d=
isconnect, address 12
Jul 12 02:07:34 turing-police kernel: =5B16675.255886=5D usb 1-8.3: USB d=
isconnect, address 5
Jul 12 02:38:31 turing-police kernel: =5B18532.020360=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 12 02:41:12 turing-police kernel: =5B18693.044003=5D usb 1-8.3: USB d=
isconnect, address 7
Jul 12 02:57:36 turing-police kernel: =5B19677.106322=5D usb 1-8.3: USB d=
isconnect, address 8
Jul 12 06:54:00 turing-police kernel: =5B33860.828804=5D usb 1-8.3: USB d=
isconnect, address 9
Jul 12 10:02:25 turing-police kernel: =5B45166.466061=5D usb 1-8.3: USB d=
isconnect, address 10
Jul 12 13:04:12 turing-police kernel: =5B56073.128083=5D usb 1-8.3: USB d=
isconnect, address 14
Jul 12 15:58:29 turing-police kernel: =5B66530.647876=5D usb 1-8.3: USB d=
isconnect, address 15
Jul 12 15:58:41 turing-police kernel: =5B66541.911830=5D usb 1-8.3: USB d=
isconnect, address 16
Jul 12 16:35:09 turing-police kernel: =5B68729.940201=5D usb 1-8.3: USB d=
isconnect, address 20
Jul 12 16:41:56 turing-police kernel: =5B69137.491817=5D usb 1-8.3: USB d=
isconnect, address 22
Jul 12 17:21:53 turing-police kernel: =5B71533.917784=5D usb 1-8.3: USB d=
isconnect, address 26
Jul 12 17:24:57 turing-police kernel: =5B71718.677972=5D usb 1-8.3: USB d=
isconnect, address 32
Jul 13 10:32:00 turing-police kernel: =5B  305.107104=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 13 10:46:02 turing-police kernel: =5B 1147.620721=5D usb 1-8.3: USB d=
isconnect, address 7
Jul 13 12:54:05 turing-police kernel: =5B 8830.665678=5D usb 1-8.3: USB d=
isconnect, address 8
Jul 13 14:17:52 turing-police kernel: =5B13857.780833=5D usb 1-8.3: USB d=
isconnect, address 9
Jul 16 11:28:50 turing-police kernel: =5B 1481.182088=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 16 11:36:03 turing-police kernel: =5B 1914.203339=5D usb 1-8.3: USB d=
isconnect, address 8
Jul 16 13:31:34 turing-police kernel: =5B 8844.879249=5D usb 1-8.3: USB d=
isconnect, address 9
Jul 16 13:31:55 turing-police kernel: =5B 8866.128241=5D usb 1-8.3: USB d=
isconnect, address 10
Jul 16 14:17:42 turing-police kernel: =5B11613.526380=5D usb 1-8.3: USB d=
isconnect, address 12
Jul 16 14:21:22 turing-police kernel: =5B11833.175214=5D usb 1-8.3: USB d=
isconnect, address 13
Jul 16 14:23:42 turing-police kernel: =5B11972.951501=5D usb 1-8.3: USB d=
isconnect, address 14
Jul 16 17:40:37 turing-police kernel: =5B23788.560389=5D usb 1-8.3: USB d=
isconnect, address 15
Jul 16 18:18:04 turing-police kernel: =5B26035.469728=5D usb 1-8.3: USB d=
isconnect, address 16
Jul 16 18:18:56 turing-police kernel: =5B26087.437651=5D usb 1-8.3: USB d=
isconnect, address 17
Jul 16 19:12:39 turing-police kernel: =5B29310.821758=5D usb 1-8.3: USB d=
isconnect, address 18
Jul 18 22:20:41 turing-police kernel: =5B 7676.887799=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 18 22:22:14 turing-police kernel: =5B 7770.071194=5D usb 1-8.3: USB d=
isconnect, address 10
Jul 18 22:37:00 turing-police kernel: =5B 8656.341954=5D usb 1-8.3: USB d=
isconnect, address 14
Jul 18 22:44:24 turing-police kernel: =5B 9100.625554=5D usb 1-8.3: USB d=
isconnect, address 16
Jul 18 23:22:26 turing-police kernel: =5B11382.480949=5D usb 1-8.3: USB d=
isconnect, address 17
Jul 19 00:03:31 turing-police kernel: =5B13846.907699=5D usb 1-8.3: USB d=
isconnect, address 18
Jul 19 00:41:49 turing-police kernel: =5B16145.094099=5D usb 1-8.3: USB d=
isconnect, address 20
Jul 19 00:42:03 turing-police kernel: =5B16159.430078=5D usb 1-8.3: USB d=
isconnect, address 22
Jul 19 02:13:44 turing-police kernel: =5B21660.092639=5D usb 1-8.3: USB d=
isconnect, address 23
Jul 19 04:26:04 turing-police kernel: =5B29600.175535=5D usb 1-8.3: USB d=
isconnect, address 25
Jul 19 04:44:13 turing-police kernel: =5B30689.388720=5D usb 1-8.3: USB d=
isconnect, address 26
Jul 19 05:54:54 turing-police kernel: =5B34930.068836=5D usb 1-8.3: USB d=
isconnect, address 27
Jul 19 06:04:20 turing-police kernel: =5B35496.470907=5D usb 1-8.3: USB d=
isconnect, address 30
Jul 19 06:24:10 turing-police kernel: =5B36686.240777=5D usb 1-8.3: USB d=
isconnect, address 32
Jul 19 06:43:30 turing-police kernel: =5B37846.332557=5D usb 1-8.3: USB d=
isconnect, address 34
Jul 19 08:10:54 turing-police kernel: =5B43090.536690=5D usb 1-8.3: USB d=
isconnect, address 35
Jul 19 10:12:07 turing-police kernel: =5B50362.758575=5D usb 1-8.3: USB d=
isconnect, address 37
Jul 19 10:26:29 turing-police kernel: =5B51224.705710=5D usb 1-8.3: USB d=
isconnect, address 42
Jul 19 10:45:52 turing-police kernel: =5B52387.922763=5D usb 1-8.3: USB d=
isconnect, address 47
Jul 19 12:29:31 turing-police kernel: =5B58606.687039=5D usb 1-8.3: USB d=
isconnect, address 51
Jul 19 15:41:37 turing-police kernel: =5B 9546.144532=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 20 10:27:45 turing-police kernel: =5B  337.102606=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 20 16:00:29 turing-police kernel: =5B17718.907516=5D usb 1-8.3: USB d=
isconnect, address 7
Jul 20 18:38:17 turing-police kernel: =5B27187.565715=5D usb 1-8.3: USB d=
isconnect, address 8
Jul 20 23:50:39 turing-police kernel: =5B 9143.247247=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 21 00:13:46 turing-police kernel: =5B  177.370154=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 21 00:13:46 turing-police kernel: =5B  177.882155=5D usb 1-8.3: USB d=
isconnect, address 7
Jul 21 00:35:47 turing-police kernel: =5B 1498.840131=5D usb 1-8.3: USB d=
isconnect, address 8
Jul 21 11:29:25 turing-police kernel: =5B 4938.192870=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 21 11:29:40 turing-police kernel: =5B 4953.552882=5D usb 1-8.3: USB d=
isconnect, address 7
Jul 21 14:40:27 turing-police kernel: =5B16401.091948=5D usb 1-8.3: USB d=
isconnect, address 8
Jul 21 14:40:50 turing-police kernel: =5B16423.875944=5D usb 1-8.3: USB d=
isconnect, address 15
Jul 21 15:23:05 turing-police kernel: =5B18958.272869=5D usb 1-8.3: USB d=
isconnect, address 17
Jul 21 16:58:44 turing-police kernel: =5B24697.784315=5D usb 1-8.3: USB d=
isconnect, address 22
Jul 21 16:59:13 turing-police kernel: =5B24726.456264=5D usb 1-8.3: USB d=
isconnect, address 25
Jul 21 16:59:34 turing-police kernel: =5B24747.704236=5D usb 1-8.3: USB d=
isconnect, address 30
Jul 22 14:20:55 turing-police kernel: =5B  305.300116=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 22 14:20:58 turing-police kernel: =5B  308.116101=5D usb 1-8.3: USB d=
isconnect, address 7
Jul 22 15:05:21 turing-police kernel: =5B 2971.280561=5D usb 1-8.3: USB d=
isconnect, address 8
Jul 22 15:11:26 turing-police kernel: =5B 3336.335856=5D usb 1-8.3: USB d=
isconnect, address 9
Jul 22 15:40:31 turing-police kernel: =5B 5081.229340=5D usb 1-8.3: USB d=
isconnect, address 10
Jul 22 16:12:04 turing-police kernel: =5B 6973.834721=5D usb 1-8.3: USB d=
isconnect, address 13
Jul 22 16:12:08 turing-police kernel: =5B 6978.186714=5D usb 1-8.3: USB d=
isconnect, address 16
Jul 23 11:10:29 turing-police kernel: =5B  571.965568=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 11:10:29 turing-police kernel: =5B  571.981570=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 11:10:29 turing-police kernel: =5B  571.997698=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 11:10:29 turing-police kernel: =5B  572.013568=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 11:10:29 turing-police kernel: =5B  572.029694=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 11:10:29 turing-police kernel: =5B  572.045696=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 11:10:29 turing-police kernel: =5B  572.061567=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 11:10:29 turing-police kernel: =5B  572.077698=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 11:10:29 turing-police kernel: =5B  572.088910=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 23 13:37:45 turing-police kernel: =5B 8344.568219=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 13:37:45 turing-police kernel: =5B 8344.584389=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 13:37:45 turing-police kernel: =5B 8344.600383=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 13:37:45 turing-police kernel: =5B 8344.616382=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 13:37:45 turing-police kernel: =5B 8344.632382=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 13:37:45 turing-police kernel: =5B 8344.648374=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 13:37:45 turing-police kernel: =5B 8344.664386=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 13:37:45 turing-police kernel: =5B 8344.680360=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 13:37:45 turing-police kernel: =5B 8344.683602=5D usb 1-8.3: USB d=
isconnect, address 6
Jul 23 15:44:33 turing-police kernel: =5B 1488.250528=5D drivers/hid/usbh=
id/hid-core.c: can't reset device, 0000:00:1d.7-8.3/input0, status -71
Jul 23 15:44:33 turing-police kernel: =5B 1488.261742=5D usb 1-8.3: USB d=
isconnect, address 6


--==_Exmh_1248380585_2742P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKaMapcC3lWbTT17ARAkEsAKDuXBewW9+JhGK1uyYAnjn8GexeNQCfS3SP
VIPgv08U/nX0FuE+0IjD4cU=
=2DwM
-----END PGP SIGNATURE-----

--==_Exmh_1248380585_2742P--
