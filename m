Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYBGHsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYBGHsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYBGHsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:48:09 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:57028 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbYBGHsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:48:07 -0500
Message-ID: <47AAB7AB.5000903@web.de>
Date: Thu, 07 Feb 2008 08:47:55 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] KGDB: Major refactoring
References: <47A8F275.9090901@web.de> <20080207001336.GA22986@elte.hu> <47AA5165.4070201@windriver.com>
In-Reply-To: <47AA5165.4070201@windriver.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig86A769B41996F209E89E558B"
X-Provags-ID: V01U2FsdGVkX1+lc/lVdceiDrtVO+0dFFTtFt+hdLLbZ6+05Q7Y
	TL/1jN+m6e200pgEbs/O0Pgi3x5DNnQyibHeD+yeGFVoTRkPDO
	aclT6EHtY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig86A769B41996F209E89E558B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Jason Wessel wrote:
> Ingo Molnar wrote:
>> * Jan Kiszka <jan.kiszka@web.de> wrote:
>>
>>  =20
>>> As most changes are tightly coupled, this refactoring patch for
>>> KGDB_8250 as well as the core and the new KGDBOC driver comes as a
>>> single chunk. The changes are:
>>>  - Reorganized configuration: I/O drivers can be independently
>>>    configured as module or built-in
>>>  - Dynamic reconfiguration for KGDB_8250 (just like for KGDBOC)
>>>  - Reworked KGDB_8250 configuration string format
>>>  - attachwait removed, arming the debugger via assigning an I/O drive=
r
>>>    implies "attachwait"
>>>  - Cleaned up I/O driver managment of the core
>>>  - Matured the various boot-up, configure, unconfigure code paths for=

>>>    both I/O drivers
>>>  - IRQ vs. KGDB_CONSOLE-output SMP race fixed for KGDB_8250
>>>  - Reduced and cleaned up hooks into serial_core/8250
>>>  - Kconfig cleanups
>>>    =20
>> great stuff! I've picked these cleanups up into x86.git. (will pick up=
=20
>> Jason's commits too)
>>
>> Could you try something else too perhaps, which would be way useful fo=
r=20
>> me: to add a sysctl flag (or something like that) to change kgdboc to =

>> accept a Ctrl-C and break into kgdb mode? [this means a simple Ctrl-C =
on=20
>> a kgdboc line would break into KGDB as well - but that would be an=20
>> acceptable price.] Right now kgdboc just hangs when gdb attaches - i=20
>> have to generate a SysRq sequence via a terminal emulator to break it =

>> into KGDB mode.
>>  =20
>=20
> FYI, even if you were to hack in a control-c vs sysrq, gdb will still

And quite a bit of "hacking" would be required here, because the sysrq
hook is built upon the assumption that a hardware break starts the
sequence, not that just a single special character comes in. Changing
this means changing the drivers, not just some central hook function.

> hang on connect because it does not issue a break of any kind when it
> connects.  It assumes the connection is in a usable state.
>=20
> The proxy spliter automatically sends the break (or in the current case=

> the sysrq g)
>> This would make kgdboc way more practical without having to resort to =
a=20
>> protocol splitting proxy, etc.
>>
>> 	Ingo
>>  =20
>=20
>=20
> Jason.

Jan


--------------enig86A769B41996F209E89E558B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHqre0niDOoMHTA+kRAkeqAJ0f2CK1iKt3DUrAVJpJIGP1BI5WTwCfVqUN
ylrNF/DV3t6AWbWCYPClqJg=
=BCob
-----END PGP SIGNATURE-----

--------------enig86A769B41996F209E89E558B--
