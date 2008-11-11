Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYKKOE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYKKOE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756078AbYKKOED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:04:03 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:6864 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbYKKOEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type;
        b=fs/1mQTxOJhLs82rYtyRLqLAxcugnE+DsycN+ladMb+0ygfJU5OdE/fPKT6pVmICdp
         MK698LXzLcBDaqeTKLFcaueNsxKxgKTHkQIvw48VgtjKfTDo/nvYfYVRp9D6LIBBw7Zd
         +97/pHzRtjcfM6vT9K4akNXfek3nJjUmi3qyU=
Message-ID: <491991BE.9080405@gmail.com>
Date: Tue, 11 Nov 2008 09:07:58 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [RFC PATCH v3 3/5] sched: nominate preferred wakeup cpu
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com>	 <20081110183326.562.37718.stgit@drishya.in.ibm.com> <1226411019.7685.1767.camel@twins>
In-Reply-To: <1226411019.7685.1767.camel@twins>
X-Enigmail-Version: 0.95.7
OpenPGP: id=CBD79AA1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3AA5332198A408DDF351AA4B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3AA5332198A408DDF351AA4B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Tue, 2008-11-11 at 00:03 +0530, Vaidyanathan Srinivasan wrote:
>  =20
>> When the system utilisation is low and more cpus are idle,
>> then the process waking up from sleep should prefer to
>> wakeup an idle cpu from semi-idle cpu package (multi core
>> package) rather than a completely idle cpu package which
>> would waste power.
>>
>> Use the sched_mc balance logic in find_busiest_group() to
>> nominate a preferred wakeup cpu.
>>
>> This info can be sored in appropriate sched_domain, but
>> updating this info in all copies of sched_domain is not
>> practical.  For now lets try with a per-cpu variable
>> pointing to a common storage in partition sched domain
>> attribute.  Global variable may not work in partitioned
>> sched domain case.
>>    =20
>
> Would it make sense to place the preferred_wakeup_cpu stuff in the
> root_domain structure we already have?
>  =20

=46rom the description, this is exactly what the root-domains were create=
d
to solve.

Vaidyanathan,  just declare your object in "struct root_domain" and
initialize it in init_rootdomain() in kernel/sched.c, and then access it
via rq->rd to take advantage of this infrastructure.  It will
automatically follow any partitioning that happens to be configured.

-Greg



--------------enig3AA5332198A408DDF351AA4B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkZkb4ACgkQP5K2CMvXmqEmeACgjAcMrXZN1VHXJ6HmK/6+QTg2
llMAn0BsPxua4QNRBJwWCNG6SUEsXAJO
=XoPM
-----END PGP SIGNATURE-----

--------------enig3AA5332198A408DDF351AA4B--
