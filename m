Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbXKBLu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbXKBLu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 07:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbXKBLuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 07:50:13 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:48103 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbXKBLuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 07:50:10 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [2.6.24-rc1][BUG] Oops on battery removal
Date: Fri, 2 Nov 2007 12:49:57 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <200711020803.49608.eike-kernel@sf-tec.de> <200711020937.33672.eike-kernel@sf-tec.de> <472AEDEC.1090606@suse.de>
In-Reply-To: <472AEDEC.1090606@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4937473.g82rgmyeHN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711021250.03555.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4937473.g82rgmyeHN
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alexey Starikovskiy wrote:
> Rolf Eike Beer wrote:
> > Rolf Eike Beer wrote:
> >> Hi,
> >>
> >> this happened while I removed my battery on bootup. Complete dmesg is
> >> attached. Kernel is 2.6.24-rc1-git of yesterday (last commit was
> >> d919fd433b5823d1cf9d0688eb2eec183de9b74c).
> >
> > Ok, I found out that it has nothing to do with the actual removal as it
> > seems. When I start the laptop with battery already detached I get the
> > same error.

> Please check if this patch helps.

It made things worse:

Nov  2 12:37:20 donald kernel: ACPI: EC: non-query interrupt received,=20
switching to interrupt mode
Nov  2 12:37:20 donald acpid: received event "battery BAT1 00000080 0000000=
0"
Nov  2 12:37:20 donald acpid: notifying client 2856[101:102]
Nov  2 12:37:20 donald acpid: notifying client 2911[0:0]
Nov  2 12:37:20 donald acpid: notifying client 3048[0:0]
Nov  2 12:37:20 donald acpid: completed event "battery BAT1 00000080 000000=
00"
Nov  2 12:37:20 donald kernel: WARNING:=20
at /home/eike/repos/linux-2.6/lib/kref.c:33 kref_get()
Nov  2 12:37:20 donald kernel:  [<c0104edd>] show_trace_log_lvl+0x1a/0x2f
Nov  2 12:37:20 donald kernel:  [<c010576e>] show_trace+0x12/0x14
Nov  2 12:37:20 donald kernel:  [<c010585b>] dump_stack+0x16/0x18
Nov  2 12:37:20 donald kernel:  [<c01d1d3c>] kref_get+0x37/0x43
Nov  2 12:37:20 donald kernel:  [<c01d10af>] kobject_get+0x12/0x17
Nov  2 12:37:20 donald kernel:  [<c0231509>] get_device+0x13/0x1d
Nov  2 12:37:20 donald kernel:  [<c02319e8>] device_remove_file+0xe/0x2a
Nov  2 12:37:20 donald kernel:  [<f8be7043>] sysfs_remove_battery+0x17/0x22=
=20
[battery]
Nov  2 12:37:20 donald kernel:  [<f8be71a2>] acpi_battery_update+0x3f/0x255=
=20
[battery]
Nov  2 12:37:20 donald kernel:  [<f8be73ed>] acpi_battery_read+0x11/0x20=20
[battery]
Nov  2 12:37:20 donald powersaved[3048]: WARNING (filter_function:201) Hal=
=20
service stopped. Battery information no longer available
Nov  2 12:37:20 donald kernel:  [<f8be741c>] acpi_battery_read_state+0xf/0x=
11=20
[battery]
Nov  2 12:37:20 donald kernel:  [<c01889ca>] seq_read+0xea/0x264
Nov  2 12:37:20 donald kernel:  [<c019fddb>] proc_reg_read+0x63/0x76
Nov  2 12:37:20 donald kernel:  [<c0172631>] vfs_read+0xa6/0x12f
Nov  2 12:37:20 donald kernel:  [<c0172a2a>] sys_read+0x3d/0x61
Nov  2 12:37:20 donald kernel:  [<c0103f12>] sysenter_past_esp+0x5f/0x85
Nov  2 12:37:20 donald kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
Nov  2 12:37:20 donald kernel: WARNING:=20
at /home/eike/repos/linux-2.6/lib/kref.c:33 kref_get()
Nov  2 12:37:20 donald kernel:  [<c0104edd>] show_trace_log_lvl+0x1a/0x2f
Nov  2 12:37:20 donald kernel:  [<c010576e>] show_trace+0x12/0x14
Nov  2 12:37:20 donald kernel:  [<c010585b>] dump_stack+0x16/0x18
Nov  2 12:37:20 donald kernel:  [<c01d1d3c>] kref_get+0x37/0x43
Nov  2 12:37:20 donald kernel:  [<c01d10af>] kobject_get+0x12/0x17
Nov  2 12:37:20 donald kernel:  [<c0231509>] get_device+0x13/0x1d
Nov  2 12:37:20 donald kernel:  [<c02319e8>] device_remove_file+0xe/0x2a
Nov  2 12:37:20 donald kernel:  [<f8b9b3dd>]=20
power_supply_remove_attrs+0x16/0x37 [power_supply]
Nov  2 12:37:20 donald kernel:  [<f8b9b012>] power_supply_unregister+0x12/0=
x1d=20
[power_supply]
Nov  2 12:37:20 donald kernel:  [<f8be704b>] sysfs_remove_battery+0x1f/0x22=
=20
[battery]
Nov  2 12:37:20 donald kernel:  [<f8be71a2>] acpi_battery_update+0x3f/0x255=
=20
[battery]
Nov  2 12:37:20 donald kernel:  [<f8be73ed>] acpi_battery_read+0x11/0x20=20
[battery]
Nov  2 12:37:20 donald kernel:  [<f8be741c>] acpi_battery_read_state+0xf/0x=
11=20
[battery]
Nov  2 12:37:20 donald kernel:  [<c01889ca>] seq_read+0xea/0x264
Nov  2 12:37:20 donald kernel:  [<c019fddb>] proc_reg_read+0x63/0x76
Nov  2 12:37:20 donald kernel:  [<c0172631>] vfs_read+0xa6/0x12f
Nov  2 12:37:20 donald kernel:  [<c0172a2a>] sys_read+0x3d/0x61
Nov  2 12:37:20 donald kernel:  [<c0103f12>] sysenter_past_esp+0x5f/0x85
Nov  2 12:37:20 donald kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D

tons more of stuff like this, system us unusable with this kernel now. In t=
he=20
meantime I upgraded to current git, last commit is now=20
b4d367fb20ed19be4a53fa88b407248aeb8bd461

Eike

--nextPart4937473.g82rgmyeHN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHKw7rXKSJPmm5/E4RAnnTAJ0Yd4IAwHwEQT5o9PmFko2ca7MqHQCcCs3e
kL9Kq7VIC2/NNW+L+9IEz6U=
=j933
-----END PGP SIGNATURE-----

--nextPart4937473.g82rgmyeHN--
