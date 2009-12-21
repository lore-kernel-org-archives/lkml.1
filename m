Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZLUKXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZLUKXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 05:23:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZLUKXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 05:23:05 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:54918 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZLUKXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 05:23:04 -0500
Message-ID: <4B2F4C58.8010303@web.de>
Date: Mon, 21 Dec 2009 11:22:16 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Roland McGrath <roland@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, utrace-devel@redhat.com,
       Avi Kivity <avi@redhat.com>
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by   08d68323d1f0c34452e614263b212ca556dae47f
References: <20091218005650.GA20667@redhat.com>	<20091218030601.GB16470@nowhere>	<20091218172747.GA10924@redhat.com>	<20091218200503.2CA0DF9A4@magilla.sf.frob.com> <20091218223230.GA1853@redhat.com>
In-Reply-To: <20091218223230.GA1853@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB71F4A750A7B927C62E233E2"
X-Provags-ID: V01U2FsdGVkX19FMEt65taKExI/Lsq4GYbyvdZX4vz3fj8mCSMq
	6vyNEe2OOct4WfaDf6RXNOweNC6qttlBrg8r4eNlAeSbGzwjUJ
	4133L33uI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB71F4A750A7B927C62E233E2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Oleg Nesterov wrote:
> On 12/18, Roland McGrath wrote:
>>> Please find the trivial test-case below. It hangs, because
>>> PTRACE_SINGLESTEP doesn't trigger the trap.
>> 2.6.33-rc1 x86-64 works for me with either -m64 or -m32 version of tha=
t test.
>>
>>> (not sure this matters, but I did the testing under kvm)
>> Apparently it does.  You should hack some printks into do_debug() and =
see
>> how kvm is differing from real hardware.  (Actually you can probably d=
o
>> this with a notifier added by a module, not that you are shy about
>> recompiling!)
>>
>> Probably kvm's emulation of the hardware behavior wrt the DR6 bits is =
not
>> sufficiently faithful.  Conceivably, kvm is being consistent with some=

>> older hardware and we have encoded assumptions that only newer hardwar=
e
>> meets.  But I'd guess it's just a plain kvm bug.
>=20
> OK, thanks.
>=20
> Hmm. Now I see how wrong I was when I said this code is "obviously wron=
g" ;)
>=20
> I'll add the debugging printk's and report the output. Sorry for delay,=

> can't do this today.

Can't reproduce, runs fine here with with 2.6.33-rc1 as both host&guest
and qemu-kvm latest git. Host uses kvm-intel.

Can you specify your setup in more details? Which host kernel did you
use, which qemu-kvm version? Are you on AMD or Intel? Any specific guest
kernel config switch that may influence this?

Jan


--------------enigB71F4A750A7B927C62E233E2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAksvTFwACgkQitSsb3rl5xRR6ACgouxLgkKDT5nsxIm687Yqyzb9
VCQAoMrlktOFi5xXsrHA+G0k2kbzV0AC
=hS6O
-----END PGP SIGNATURE-----

--------------enigB71F4A750A7B927C62E233E2--
