Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbXIKIH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbXIKIH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758908AbXIKIHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:07:15 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37555 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbXIKIHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:07:13 -0400
Message-ID: <46E64C9D.2000509@bull.net>
Date: Tue, 11 Sep 2007 10:06:53 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 0/4] Virtual Machine Time Accounting
References: <46E5325D.1020902@bull.net> <46E53D96.4050409@qumranet.com> <46E541DD.4080202@bull.net> <200709101910.36923.alistair@devzero.co.uk>
In-Reply-To: <200709101910.36923.alistair@devzero.co.uk>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/09/2007 10:12:51,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/09/2007 10:12:53,
	Serialize complete at 11/09/2007 10:12:53
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE7F8ECE37E4EFA38186A7FF6"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE7F8ECE37E4EFA38186A7FF6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Alistair John Strachan wrote:
> On Monday 10 September 2007 14:08:45 Laurent Vivier wrote:
>> Avi Kivity wrote:
>>> Ingo Molnar wrote:
>>>> * Laurent Vivier <Laurent.Vivier@bull.net> wrote:
>>>>> Ingo, please, could you have a look to these patches ?
>>>>>
>>>>> The aim of these four patches is to introduce Virtual Machine time
>>>>> accounting.
>>>>>
>>>>> [PATCH 1/4] as recent CPUs introduce a third running state, after
>>>>> "user" and "system", we need a new field, "guest", in cpustat to
>>>>> store the time used by the CPU to run virtual CPU. Modify /proc/sta=
t
>>>>> to display this new field.
>>>> the concept certainly looks sane to me.
>>>>
>>>> The heavy-handed use of #ifdefs uglifies the code to a large degree,=

>>>> but this is not a fundamental problem: since basically all distros
>>>> have KVM enabled (and lguest benefits from this too), could you just=

>>>> make all this new code unconditional?
>>> I imagine the embedded people will complain... perhaps move all the c=
ode
>>> to a #ifdef section above with a full implementation and a stub
>>> implementation.
>> I'm going to repost patches without #ifdefs for readability.
>> Then we could discuss if we should introduce #ifdefs and how.
>=20
> If you could provide a summary of the size increase from your latest po=
st=20
> (i.e., size of the kernel before and after) that might lay rest to some=
=20
> theoretical complaints.

These patches add:

* at data structures level:

- one cputime64_t (8 bytes) per cpu
- two cputime_t (2 * 4 bytes) per signal_struct and one cputime_t per tas=
k_struct

* at processing level:

- display and convert one more value in show_stat() (fs/proc/proc_misc.c)=

- display and convert two more values in do_task_stat() (fs/proc/array.c)=

- manage (copy and add) one more value in __exit_signal() (kernel/exit.c)=

- initialize three more fields in copy_signal (kernel/fork.c)
- add a bit test in account_system_time() and if the bit is set call a ne=
w
function (46 bytes on x86_64).

Size of stripped kernel before (on x86_64):
vmlinux 7305064 bytes (not stripped 52643888 bytes)
Size of stripped kernel after:
vmlinux 7305064 bytes (not stripped 52677180 bytes)

means 0 bytes added ????

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth


--------------enigE7F8ECE37E4EFA38186A7FF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFG5kyh9Kffa9pFVzwRAudfAKCl8p/kMDImi5LL8G4l4QbtpIScSgCgv4ay
/LH17Qo2QDWOwRe6gTbYg9Y=
=xEXH
-----END PGP SIGNATURE-----

--------------enigE7F8ECE37E4EFA38186A7FF6--
