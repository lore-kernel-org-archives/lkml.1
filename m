Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYBJRj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYBJRj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYBJRjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:39:49 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:48435 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYBJRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:39:48 -0500
Message-ID: <47AF36D6.7050507@web.de>
Date: Sun, 10 Feb 2008 18:39:34 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
References: <20080210071304.GA3788@elte.hu>	 <20080210104709.GB10790@uranus.ravnborg.org>	 <20080210163603.GB28201@elte.hu> <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com>
In-Reply-To: <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3DC459D8E44DD780967D0F18"
X-Provags-ID: V01U2FsdGVkX19atdPmHgLJMo2pKDYdRy063lbHWt05n+7MCQS1
	P5gfYYjnhNWNOhQru3rZbjfpkD0kRdnquYvvglodEdZ8w0WFGu
	HfvWgrOwY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3DC459D8E44DD780967D0F18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ray Lee wrote:
> On Feb 10, 2008 8:36 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> +#ifdef CONFIG_64BIT
>> +       } else if ((count =3D=3D 8) && (((long)mem & 7) =3D=3D 0)) {
>> +               u64 tmp_ll;
>> +               if (probe_kernel_address(mem, tmp_ll))
>> +                       return ERR_PTR(-EINVAL);
>> +
>> +               mem +=3D 8;
>> +#ifdef __BIG_ENDIAN
>> +               *buf++ =3D hexchars[(tmp_ll >> 60) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 56) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 52) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 48) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 44) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 40) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 36) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 32) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 28) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 24) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 20) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 16) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 12) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 8) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 4) & 0xf];
>> +               *buf++ =3D hexchars[tmp_ll & 0xf];
>> +#else
>> +               *buf++ =3D hexchars[(tmp_ll >> 4) & 0xf];
>> +               *buf++ =3D hexchars[tmp_ll & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 12) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 8) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 20) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 16) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 28) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 24) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 36) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 32) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 44) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 40) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 52) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 48) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 60) & 0xf];
>> +               *buf++ =3D hexchars[(tmp_ll >> 56) & 0xf];
>> +#endif
>=20
> Am I missing something? (I'm due, so it's not really a rhetorical
> question :-) .) Wouldn't
>=20
> unsigned int void u64_to_hex(u64 val, unsigned char *buf)
> {
>          int i;
>          for (i=3D15; i>=3D0; i--) {
>                   buf[i] =3D hexchars[ val & 0x0f ];
>                   val >>=3D 4;
>          }
>          return 16;
> }
> ...
>          buf +=3D u64_to_hex(cpu_to_be64(tmp_ll), buf);
>=20
> be clearer both visually, and code-as-intent? (And equivalent helpers
> for u32, u16 -- though they could all be rolled into one.)

Yes, will come, I just produced some ETOOMANYCHANGESATONCE issue while
improving this. The code goes down by more than 150 lines!

Jan


--------------enig3DC459D8E44DD780967D0F18
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHrzbhniDOoMHTA+kRAmKhAJ43faMg8srS65FnzZ7r3FUnZx1hugCdEEm0
3aAZKunYOYbccAt5hsym3nY=
=z0IT
-----END PGP SIGNATURE-----

--------------enig3DC459D8E44DD780967D0F18--
