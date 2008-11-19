Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbYKSM1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbYKSM1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 07:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYKSM1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 07:27:17 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:47311 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbYKSM1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:27:16 -0500
Message-ID: <492406FD.3030001@novell.com>
Date: Wed, 19 Nov 2008 07:30:53 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: Nish Aravamudan <nish.aravamudan@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dimitri Sivanich <sivanich@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Using cpusets for configuration/isolation [Was Re: RT sched:
 cpupri_vec lock contention with def_root_domain and no load balance]
References: <29495f1d0811071123x37d910a8w6c1604b8159954ec@mail.gmail.com>	 <4923731E.7010601@qualcomm.com> <29495f1d0811181811r1a7476ceyb5cb4a86e11e7651@mail.gmail.com> <4923A0A8.5050009@qualcomm.com>
In-Reply-To: <4923A0A8.5050009@qualcomm.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7417EBFA28F8CD6B80881887"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7417EBFA28F8CD6B80881887
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Max Krasnyansky wrote:
> Nish Aravamudan wrote:
>  =20
>> On Tue, Nov 18, 2008 at 5:59 PM, Max Krasnyansky <maxk@qualcomm.com> w=
rote:
>>    =20
>>> I do not see how 'partfs' that you described would be different from
>>> 'cpusets' that we have now. Just ignore 'tasks' files in the cpusets =
and you
>>> already have your 'partfs'. You do _not_ have to use cpuset for assig=
ning
>>> tasks if you do not want to. Just use them to define sets of cpus and=
 keep
>>> all the tasks in the 'root' set. You can then explicitly pin your thr=
eads
>>> down with pthread_set_affinity().
>>>      =20
>> I guess you're right. It still feels a bit kludgy, but that is probabl=
y just me.
>>
>> I have wondered, though, if it makes sense to provide an "isolated"
>> file in /sys/devices/system/cpu/cpuX/ to do most of the offline
>> sequence, break sched_domains and remove a CPU from the load balancer
>> (rather than turning the load balancer off), rather than requiring a
>> user to explicitly do an offline/online.=20
>>    =20
> I do not see any benefits in exposing a special 'isolated' bit and have=
 it do
> the same thing that the cpu hotplug already does. As I explained in oth=
er
> threads cpu hotplug is a _perfect_ fit for the isolation purposes. In o=
rder to
> isolate a CPU dynamically (ie at runtime) we need to flush pending work=
, flush
> chaches, move tasks and timers, etc. Which is _exactly_ what cpu hotplu=
g code
> does when it brings CPU down. There is no point in reimplementing it.
>
> btw It sounds like you misunderstood the meaning of the
> cpuset.sched_load_balance flag. It's does not turn really turn load bal=
ancer
> off, it simply causes cpus in different cpusets to be put into separate=
 sched
> domains. In other words it already does exactly what you're asking for.=

>  =20

On a related note, please be advised I have a bug in this area:

http://bugzilla.kernel.org/show_bug.cgi?id=3D12054

-Greg


>  =20
>> I guess it can all be rather
>> transparently masked via a userspace tool, but we don't have a common
>> one yet.
>>    =20
> I do :). It's called 'syspart'
> 	http://git.kernel.org/?p=3Dlinux/kernel/git/maxk/syspart.git;a=3Dsumma=
ry
> I'll push an updated version in a couple of days.
>
>  =20
>> I do have a question, though: is your recommendation to just turn the
>> load balancer off in the cpuset you create that has the isolated CPUs?=

>> I guess the conceptual issue I was having was that the root cpuset (I
>> think) always contains all CPUs and all memory nodes. So even if you
>> put some CPUs in a cpuset under the root one, and isolate them using
>> hotplug + disabling the load balancer in that cpuset, those CPUs are
>> still available to tasks in the root cpuset? Maybe I'm just missing a
>> step in the configuration, but it seems like as long as the global
>> (root cpuset) load balancer is on, a CPU can't be guaranteed to stay
>> isolated?
>>    =20
> Take a look at what 'syspart' does. In short yes, of course we need to =
set
> sched_load_balance flag in root cpuset to 0.
>
> Max
>
>
>
>
>
>  =20



--------------enig7417EBFA28F8CD6B80881887
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkkBv4ACgkQlOSOBdgZUxn66QCcDEJSAXQjLoEdVgprwRoaE/ay
AYMAn2SPipKCUvFUmpoN8Xs9tXTLMYes
=uakt
-----END PGP SIGNATURE-----

--------------enig7417EBFA28F8CD6B80881887--
