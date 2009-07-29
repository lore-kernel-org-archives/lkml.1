Return-Path: <linux-kernel-owner+w=401wt.eu-S1751266AbZG2Ds7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbZG2Ds7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 23:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbZG2Ds7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 23:48:59 -0400
Received: from mail-yx0-f190.google.com ([209.85.210.190]:61679 "EHLO
	mail-yx0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZG2Ds6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 23:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=u3xbEOWX6PbOZ9cfZDPVHc6iuTi1FwTtiBsAZfNlQJzbmeY2++TRD4vic+jSIqKqln
         V2e6cQLlRX5yNEhb16EHlCc6tXh3Xk+Kh/W3/jAq5eWYSmn7QtPHKBho1K4gBsDvPaR5
         bDkC1mw1Vr8EjbKIhX2IQetwKWM6xkIrDKM+g=
Message-ID: <4A6FC6A5.9030508@gmail.com>
Date: Tue, 28 Jul 2009 23:48:53 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [regression] sched_getaffinity fails with EINVAL in 2.6.31-rc4
References: <4A6DE0DC.2070207@gmail.com> <alpine.DEB.2.00.0907271108350.8408@chino.kir.corp.google.com> <200907291118.53912.rusty@rustcorp.com.au>
In-Reply-To: <200907291118.53912.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig199504FE185C731B55E537D6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig199504FE185C731B55E537D6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Rusty Russell wrote:
> On Tue, 28 Jul 2009 03:42:15 am David Rientjes wrote:
>> On Mon, 27 Jul 2009, Gregory Haskins wrote:
>>
>>> I am not sure when this started, but noticed that sched_getaffinity i=
s
>>> not working in -rc4.
>>>
>>> [pid  6254] sched_getaffinity(0, 128, 0x7f80586b1fe0) =3D -1 EINVAL
>>> (Invalid argument)
>>>
>>> Here is a simple program for reproduction:
>>>
>>> #include <sched.h>
>>>
>>> int main(void)
>>> {
>>> 	cpu_set_t mask;
>>> 	int ret;
>>>
>>> 	ret =3D sched_getaffinity(0, sizeof(mask), &mask);
>>> 	if (ret < 0)
>>> 		perror("getaffinity");
>>>
>>> 	return ret;
>>> }
>>>
>>> If I get time, I will bisect this later today.
>>>
>> It's most likely due to the cpumask changes.  I don't know what cpu_se=
t_t=20
>> is, but it's probably smaller than CONFIG_NR_CPUS rounded up to a mult=
iple=20
>> of sizeof(long).
>=20
> It's simply that you finally ran this on a kernel which had
> CONFIG_NR_CPUS > 1024.

Indeed.  I thought I had replied to the list that I figured that out,
but I think it might have been a trimmed list from someone elses reply.

Long story short, MAXSMP=3Dy crept in, which set NR_CPUS=3D4096.  Backing=

this off < 1024 indeed fixes the issue.

Thanks to all who replied!
-Greg


--------------enig199504FE185C731B55E537D6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkpvxqUACgkQP5K2CMvXmqGdUQCcCesANaiV5ZsKsRjPBjD2iP93
6hMAmgNNqKxAp+Wm+8x9blM6u2RH7msF
=T7V1
-----END PGP SIGNATURE-----

--------------enig199504FE185C731B55E537D6--
