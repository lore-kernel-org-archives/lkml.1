Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYKUByI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYKUByI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 20:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKUBxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 20:53:55 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:49816 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYKUBxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 20:53:54 -0500
Message-ID: <4926158B.9020909@novell.com>
Date: Thu, 20 Nov 2008 20:57:31 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: Dimitri Sivanich <sivanich@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com> <4924C770.7050107@qualcomm.com>
In-Reply-To: <4924C770.7050107@qualcomm.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig22049E0F29953F089D560523"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig22049E0F29953F089D560523
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Max,


Max Krasnyansky wrote:
> Here comes a long text with a bunch of traces based on different cpuset=

> setups. This is an 8Core dual Xeon (L5410) box. 2.6.27.6 kernel.
> All scenarios assume
>    mount -t cgroup -ocpusets /cpusets
>    cd /cpusets
>  =20

Thank you for doing this.  Comments inline...


> ----
> Trace 1
> $ echo 0 > cpuset.sched_load_balance
>
> [ 1674.811610] cpusets: rebuild ndoms 0
> [ 1674.811627] CPU0 root domain default
> [ 1674.811629] CPU0 attaching NULL sched-domain.
> [ 1674.811633] CPU1 root domain default
> [ 1674.811635] CPU1 attaching NULL sched-domain.
> [ 1674.811638] CPU2 root domain default
> [ 1674.811639] CPU2 attaching NULL sched-domain.
> [ 1674.811642] CPU3 root domain default
> [ 1674.811643] CPU3 attaching NULL sched-domain.
> [ 1674.811646] CPU4 root domain default
> [ 1674.811647] CPU4 attaching NULL sched-domain.
> [ 1674.811649] CPU5 root domain default
> [ 1674.811651] CPU5 attaching NULL sched-domain.
> [ 1674.811653] CPU6 root domain default
> [ 1674.811655] CPU6 attaching NULL sched-domain.
> [ 1674.811657] CPU7 root domain default
> [ 1674.811659] CPU7 attaching NULL sched-domain.
>
> Looks fine.
>  =20

I have to agree.  The code is working "as designed" here since I do not
support the sched_load_balance=3D0 mode yet.  While technically not a bug=
,
a new feature to add support for it would be nice :)

> ----
> Trace 2
> $ echo 1 > cpuset.sched_load_balance
>
> [ 1748.260637] cpusets: rebuild ndoms 1
> [ 1748.260648] cpuset: domain 0 cpumask ff
> [ 1748.260650] CPU0 root domain ffff88025884a000
> [ 1748.260652] CPU0 attaching sched-domain:
> [ 1748.260654]  domain 0: span 0-7 level CPU
> [ 1748.260656]   groups: 0 1 2 3 4 5 6 7
> [ 1748.260665] CPU1 root domain ffff88025884a000
> [ 1748.260666] CPU1 attaching sched-domain:
> [ 1748.260668]  domain 0: span 0-7 level CPU
> [ 1748.260670]   groups: 1 2 3 4 5 6 7 0
> [ 1748.260677] CPU2 root domain ffff88025884a000
> [ 1748.260679] CPU2 attaching sched-domain:
> [ 1748.260681]  domain 0: span 0-7 level CPU
> [ 1748.260683]   groups: 2 3 4 5 6 7 0 1
> [ 1748.260690] CPU3 root domain ffff88025884a000
> [ 1748.260692] CPU3 attaching sched-domain:
> [ 1748.260693]  domain 0: span 0-7 level CPU
> [ 1748.260696]   groups: 3 4 5 6 7 0 1 2
> [ 1748.260703] CPU4 root domain ffff88025884a000
> [ 1748.260705] CPU4 attaching sched-domain:
> [ 1748.260706]  domain 0: span 0-7 level CPU
> [ 1748.260708]   groups: 4 5 6 7 0 1 2 3
> [ 1748.260715] CPU5 root domain ffff88025884a000
> [ 1748.260717] CPU5 attaching sched-domain:
> [ 1748.260718]  domain 0: span 0-7 level CPU
> [ 1748.260720]   groups: 5 6 7 0 1 2 3 4
> [ 1748.260727] CPU6 root domain ffff88025884a000
> [ 1748.260729] CPU6 attaching sched-domain:
> [ 1748.260731]  domain 0: span 0-7 level CPU
> [ 1748.260733]   groups: 6 7 0 1 2 3 4 5
> [ 1748.260740] CPU7 root domain ffff88025884a000
> [ 1748.260742] CPU7 attaching sched-domain:
> [ 1748.260743]  domain 0: span 0-7 level CPU
> [ 1748.260745]   groups: 7 0 1 2 3 4 5 6
>
> Looks perfect.
>  =20

Yep.

> ----
> Trace 3
> $ for i in 0 1 2 3 4 5 6 7; do mkdir par$i; echo $i > par$i/cpuset.cpus=
; done
> $ echo 0 > cpuset.sched_load_balance
>
> [ 1803.485838] cpusets: rebuild ndoms 1
> [ 1803.485843] cpuset: domain 0 cpumask ff
> [ 1803.486953] cpusets: rebuild ndoms 1
> [ 1803.486957] cpuset: domain 0 cpumask ff
> [ 1803.488039] cpusets: rebuild ndoms 1
> [ 1803.488044] cpuset: domain 0 cpumask ff
> [ 1803.489046] cpusets: rebuild ndoms 1
> [ 1803.489056] cpuset: domain 0 cpumask ff
> [ 1803.490306] cpusets: rebuild ndoms 1
> [ 1803.490312] cpuset: domain 0 cpumask ff
> [ 1803.491464] cpusets: rebuild ndoms 1
> [ 1803.491474] cpuset: domain 0 cpumask ff
> [ 1803.492617] cpusets: rebuild ndoms 1
> [ 1803.492622] cpuset: domain 0 cpumask ff
> [ 1803.493758] cpusets: rebuild ndoms 1
> [ 1803.493763] cpuset: domain 0 cpumask ff
> [ 1835.135245] cpusets: rebuild ndoms 8
> [ 1835.135249] cpuset: domain 0 cpumask 80
> [ 1835.135251] cpuset: domain 1 cpumask 40
> [ 1835.135253] cpuset: domain 2 cpumask 20
> [ 1835.135254] cpuset: domain 3 cpumask 10
> [ 1835.135256] cpuset: domain 4 cpumask 08
> [ 1835.135259] cpuset: domain 5 cpumask 04
> [ 1835.135261] cpuset: domain 6 cpumask 02
> [ 1835.135263] cpuset: domain 7 cpumask 01
> [ 1835.135279] CPU0 root domain default
> [ 1835.135281] CPU0 attaching NULL sched-domain.
> [ 1835.135286] CPU1 root domain default
> [ 1835.135288] CPU1 attaching NULL sched-domain.
> [ 1835.135291] CPU2 root domain default
> [ 1835.135294] CPU2 attaching NULL sched-domain.
> [ 1835.135297] CPU3 root domain default
> [ 1835.135299] CPU3 attaching NULL sched-domain.
> [ 1835.135303] CPU4 root domain default
> [ 1835.135305] CPU4 attaching NULL sched-domain.
> [ 1835.135308] CPU5 root domain default
> [ 1835.135311] CPU5 attaching NULL sched-domain.
> [ 1835.135314] CPU6 root domain default
> [ 1835.135316] CPU6 attaching NULL sched-domain.
> [ 1835.135319] CPU7 root domain default
> [ 1835.135322] CPU7 attaching NULL sched-domain.
> [ 1835.192509] CPU7 root domain ffff88025884a000
> [ 1835.192512] CPU7 attaching NULL sched-domain.
> [ 1835.192518] CPU6 root domain ffff880258849000
> [ 1835.192521] CPU6 attaching NULL sched-domain.
> [ 1835.192526] CPU5 root domain ffff880258848800
> [ 1835.192530] CPU5 attaching NULL sched-domain.
> [ 1835.192536] CPU4 root domain ffff88025884c000
> [ 1835.192539] CPU4 attaching NULL sched-domain.
> [ 1835.192544] CPU3 root domain ffff88025884c800
> [ 1835.192547] CPU3 attaching NULL sched-domain.
> [ 1835.192553] CPU2 root domain ffff88025884f000
> [ 1835.192556] CPU2 attaching NULL sched-domain.
> [ 1835.192561] CPU1 root domain ffff88025884d000
> [ 1835.192565] CPU1 attaching NULL sched-domain.
> [ 1835.192570] CPU0 root domain ffff88025884b000
> [ 1835.192573] CPU0 attaching NULL sched-domain.
>
> Looks perfectly fine too. Notice how each cpu ended up in a different r=
oot_domain.
>  =20

Yep, I concur.  This is how I intended it to work.  However, Dimitri
reports that this is not working for him and this is what piqued my
interest and drove the creation of a BZ report.

Dimitri, can you share your cpuset configuration with us, and also
re-run both it and Max's approach (assuming they differ) on your end to
confirm the problem still exists?  Max, perhaps you can post the patch
with your debugging instrumentation so we can equally see what happens
on Dimitri's side?
> ----
> Trace 4
> $ rmdir par*
> $ echo 1 > cpuset.sched_load_balance
>
> This trace looks the same as #2. Again all is fine.
>
> ----
> Trace 5
> $ mkdir par0
> $ echo 0-3 > par0/cpuset.cpus
> $ echo 0 > cpuset.sched_load_balance
>
> [ 2204.382352] cpusets: rebuild ndoms 1
> [ 2204.382358] cpuset: domain 0 cpumask ff
> [ 2213.142995] cpusets: rebuild ndoms 1
> [ 2213.143000] cpuset: domain 0 cpumask 0f
> [ 2213.143005] CPU0 root domain default
> [ 2213.143006] CPU0 attaching NULL sched-domain.
> [ 2213.143011] CPU1 root domain default
> [ 2213.143013] CPU1 attaching NULL sched-domain.
> [ 2213.143017] CPU2 root domain default
> [ 2213.143021] CPU2 attaching NULL sched-domain.
> [ 2213.143026] CPU3 root domain default
> [ 2213.143030] CPU3 attaching NULL sched-domain.
> [ 2213.143035] CPU4 root domain default
> [ 2213.143039] CPU4 attaching NULL sched-domain.
> [ 2213.143044] CPU5 root domain default
> [ 2213.143048] CPU5 attaching NULL sched-domain.
> [ 2213.143053] CPU6 root domain default
> [ 2213.143057] CPU6 attaching NULL sched-domain.
> [ 2213.143062] CPU7 root domain default
> [ 2213.143066] CPU7 attaching NULL sched-domain.
> [ 2213.181261] CPU0 root domain ffff8802589eb000
> [ 2213.181265] CPU0 attaching sched-domain:
> [ 2213.181267]  domain 0: span 0-3 level CPU
> [ 2213.181275]   groups: 0 1 2 3
> [ 2213.181293] CPU1 root domain ffff8802589eb000
> [ 2213.181297] CPU1 attaching sched-domain:
> [ 2213.181302]  domain 0: span 0-3 level CPU
> [ 2213.181309]   groups: 1 2 3 0
> [ 2213.181327] CPU2 root domain ffff8802589eb000
> [ 2213.181332] CPU2 attaching sched-domain:
> [ 2213.181336]  domain 0: span 0-3 level CPU
> [ 2213.181343]   groups: 2 3 0 1
> [ 2213.181366] CPU3 root domain ffff8802589eb000
> [ 2213.181370] CPU3 attaching sched-domain:
> [ 2213.181373]  domain 0: span 0-3 level CPU
> [ 2213.181384]   groups: 3 0 1 2
>
> Looks perfectly fine too. CPU0-3 are in root domain ffff8802589eb000. T=
he rest
> are in def_root_domain.
>
> -----
> Trace 6
> $ mkdir par1
> $ echo 4-5 > par1/cpuset.cpus
>
> [ 2752.979008] cpusets: rebuild ndoms 2
> [ 2752.979014] cpuset: domain 0 cpumask 30
> [ 2752.979016] cpuset: domain 1 cpumask 0f
> [ 2752.979024] CPU4 root domain ffff8802589ec800
> [ 2752.979028] CPU4 attaching sched-domain:
> [ 2752.979032]  domain 0: span 4-5 level CPU
> [ 2752.979039]   groups: 4 5
> [ 2752.979052] CPU5 root domain ffff8802589ec800
> [ 2752.979056] CPU5 attaching sched-domain:
> [ 2752.979060]  domain 0: span 4-5 level CPU
> [ 2752.979071]   groups: 5 4
>
> Looks correct too. CPUs 4 and 5 got added to a new root domain
> ffff8802589ec800 and nothing else changed.
>
> -----
>
> So. I think the only action item is for me to update 'syspart' to creat=
e a
> cpuset for each isolated cpu to avoid putting a bunch of cpus into the =
default
> root domain. Everything else looks perfectly fine.
>  =20

I agree.  We just need to make sure Dimitri can reproduce these findings
on his side to make sure it is not something like a different cpuset
configuration that causes the problem.  If you can, Max, could you also
add the rd->span to the instrumentation just so we can verify that it is
scoped appropriately?

> btw We should probably rename 'root_domain' to something else to avoid
> confusion. ie Most people assume that there should be only one root_rom=
ain.
>  =20

Agreed, but that is already true (depending on your perspective ;)  I
chose "root-domain" as short for root-sched-domain (meaning the top-most
sched-domain in the hierarchy).  There is only one root-domain per
run-queue.  There can be multiple root-domains per system.  The former
is how I intended it to be considered, and I think in this context
"root" is appropriate.  Just as you could consider that every Linux box
has a root filesystem, but there can be multiple root filesystems that
exist on, say, a single HDD for example.  Its simply a context to
govern/scope the rq behavior.

Early iterations of my patches actually had the rd pointer hanging off
the top sched-domain structure, actually.  This perhaps reinforced the
concept of "root" and thus allowed the reasoning for the chosen name to
be more apparent.  However, I quickly realized that there was no
advantage to walking up the sd hierarchy to find "root" and thus the rd
pointer...you could effectively hang the pointer on the rq directly for
the same result and with less overhead.  So I moved it in the later
patches which were ultimately accepted.

I don't feel strongly about the name either way, however.  So if people
have a name they prefer and the consensus is that it's less confusing, I
am fine with that.

> Also we should probably commit those prints that I added and enable the=
n under
> SCHED_DEBUG. Right now we're just printing sched_domains and it's not c=
lear
> which root_domain they belong to.
>  =20

Yes, please do!  (and please add the rd->span as indicated earlier, if
you would be so kind ;)

If Dimitri can reproduce your findings, we can close out the bug as FAD
and create a new-feature request for the sched_load_balance flag.  In
the meantime, the workaround for the new feature is to use per-cpu
exclusive cpusets which it sounds can be supported by your syspart tool.

Thanks Max,
-Greg



--------------enig22049E0F29953F089D560523
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkmFYsACgkQlOSOBdgZUxm0OQCfXcRENU9QYH/M2asvdi4mpHRc
ZPAAnRe/Eyy7uKtudTp7z563WW8mz8kF
=lAph
-----END PGP SIGNATURE-----

--------------enig22049E0F29953F089D560523--
