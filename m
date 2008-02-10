Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYBJUYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYBJUYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYBJUYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:24:00 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:46091 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbYBJUX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:23:59 -0500
Message-ID: <47AF5D58.8030303@web.de>
Date: Sun, 10 Feb 2008 21:23:52 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [0/6] kgdb light
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <47AEFB40.5070208@web.de> <20080210193153.GC13733@uranus.ravnborg.org>
In-Reply-To: <20080210193153.GC13733@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBA1B0D6773F5B317BC4D4BAB"
X-Provags-ID: V01U2FsdGVkX1+rh7mxos7/7Z+gRxrosbmPtKdHdCGB3sDdTorc
	IkcKuwpRlqSIiiqSU3KeOsdA96NmRYCNL/DgcwLWLvSdESqpdI
	2QMMLhcmo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBA1B0D6773F5B317BC4D4BAB
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Sam Ravnborg wrote:
> On Sun, Feb 10, 2008 at 02:25:20PM +0100, Jan Kiszka wrote:
>> Sam Ravnborg wrote:
>>> ...
>>> +extern int kgdb_may_fault;
>>> I searched but I could not find any places this
>>> variable were set to anuthing else than 0 neither where it was tested=
=2E
>> This is a leftover from the old jmp-on-fault logic that was missed by
>> this tree. I have a patch under test that kills this (and further 150
>> LOC) from the core.
>>
>>> diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
>>> new file mode 100644
>>> index 0000000..00263c0
>>> --- /dev/null
>>> +++ b/lib/Kconfig.kgdb
>>> @@ -0,0 +1,37 @@
>>> +
>>> +menuconfig KGDB
>>> +	bool "KGDB: kernel debugging with remote gdb"
>>> +	select FRAME_POINTER
>>> +	depends on HAVE_ARCH_KGDB
>>> +	depends on DEBUG_KERNEL && EXPERIMENTAL
>>> +	help
>>> +	  If you say Y here, it will be possible to remotely debug the
>>> +	  kernel using gdb.  Documentation of kernel debugger is available
>>> +	  at http://kgdb.sourceforge.net as well as in DocBook form
>>> +	  in Documentation/DocBook/.  If unsure, say N.
>>> +
>>> +config HAVE_ARCH_KGDB_SHADOW_INFO
>>> +	bool
>>> +
>>>
>>> Please add:
>>> config HAVE_ARCH_KGDB
>>> 	bool
>>>
>>> So we later in x86/Kconfig can do:
>>> config X86
>>> 	select HAVE_ARCH_KGDB
>>>
>>> And we can get rid of (from x86/Kconfig):
>>> +config HAVE_ARCH_KGDB
>>> +	def_bool y
>>>
>>>
>>> Back to Kconfig.kgdb:
>>>
>>> +config KGDBOC
>>> +	tristate "KGDB: use kgdb over the serial console"
>>> +	depends on KGDB
>>>
>>> Can we have a more descriptive name here.
>>> For example:
>>> config KGDB_SERIAL_CONSOLE
>>> It is only used in one place so there is no
>>> specific need for such a magic short name.
>>>
>> Is the patch below OK? I also added an "if KGB" to unbreak kgdb's
>> kconfig menu again and included two minor cleanups I posted yesterday.=

>=20
> Looks OK - but I think Ingo already addressed this.

Should be merged meanwhile.

At this chance: Is it necessary that prompt-less configs like=20
HAVE_ARCH_KGDB break the menu indention? I had to work around this via=20
"if KGDB" (or even "depends on"). This is easy to miss IMHO.

Jan


--------------enigBA1B0D6773F5B317BC4D4BAB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHr11YniDOoMHTA+kRAsnFAJ0f5bhJ1xy5znF2PIBAU3C0P4KsogCdHxWj
RHZRW3Cf0i6iMO9bgJZGFWw=
=IIqu
-----END PGP SIGNATURE-----

--------------enigBA1B0D6773F5B317BC4D4BAB--
