Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZBPMxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZBPMxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZBPMxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:53:23 -0500
Received: from mail.klingt.org ([86.59.21.178]:32965 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbZBPMxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:53:22 -0500
Message-ID: <499961AF.8030909@klingt.org>
Date: Mon, 16 Feb 2009 13:53:03 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc4 regression
References: <1229869416.6911.1.camel@thinkpad> <49932C35.3020300@klingt.org> <20090213190740.GD25042@erda.amd.com> <20090216112313.359ef437@thinkpad> <20090216113349.GF25042@erda.amd.com>
In-Reply-To: <20090216113349.GF25042@erda.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9273A80606A3B163A40B7A1C"
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (klingt.org [127.0.0.1]); Mon, 16 Feb 2009 13:53:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9273A80606A3B163A40B7A1C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>>> still, I can not reproduce this with my tests with v2.6.29-rc4. The
>>> regression on the systems I have runs fine on rc4. On the system you
>>> have, is commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8 the first ba=
d
>>> one? If so, I will split the patch into smaller pieces to find the
>>> change that introduces the bug.
>> i got revision df13b31c286b3e91c556167954eda088d90a4295 working, by no=
t
>> resetting the counter width:
>>
>> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_=
model_ppro.c
>> index 12e207a..f0e019d 100644
>> --- a/arch/x86/oprofile/op_model_ppro.c
>> +++ b/arch/x86/oprofile/op_model_ppro.c
>> @@ -76,12 +76,14 @@ static void ppro_setup_ctrs(struct op_msrs const *=
 const msrs)
>>  			return;
>>  	}
>> =20
>> +#if 0
>>  	if (cpu_has_arch_perfmon) {
>>  		union cpuid10_eax eax;
>>  		eax.full =3D cpuid_eax(0xa);
>>  		if (counter_width < eax.split.bit_width)
>>  			counter_width =3D eax.split.bit_width;
>>  	}
>> +#endif
>>
>>
>> this tweak did not work on later kernels, that i tested, though, and i=
=20
>> haven't had time to look into it in more detail.

hm, i just tried to compile 2.6.28 with this patch applied, and there
the NMIs are delivered correctly.

> Thanks Tim, on later kernels, is it the behaviour you mentioned that
> no NMIs are delivered and you do not receive any NMI?

on the current 2.6.29-rc5, no NMIs are delivered. however i have also
applied the performance counter branch from tip, maybe that interferes
with oprofile?
will try to compile a clean linus/master with this patch later ...

tim

--=20
tim@klingt.org
http://tim.klingt.org

Nothing exists until or unless it is observed. An artist is making
something exist by observing it. And his hope for other people is that
they will also make it exist by observing it. I call it 'creative
observation.' Creative viewing.
  William S. Burroughs


--------------enig9273A80606A3B163A40B7A1C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmZYbIACgkQdL+4qsZfVssM/ACfWBOmJQVIEHtDlTd8r/ko8sjd
B/4AnRVL3NG8VGUoLiGLujb4lqmgKhAE
=pOxr
-----END PGP SIGNATURE-----

--------------enig9273A80606A3B163A40B7A1C--
