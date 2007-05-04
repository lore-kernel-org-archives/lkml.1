Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbXEDNBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbXEDNBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbXEDNBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:01:07 -0400
Received: from mail11.syd.optusnet.com.au ([211.29.132.192]:55029 "EHLO
	mail11.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979AbXEDNBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:01:05 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>
Subject: 2.6.21-ck1
Date: Fri, 4 May 2007 23:00:58 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2240405.UQHMMAm5rc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705042301.01305.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2240405.UQHMMAm5rc
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patchset is designed to improve system responsiveness and interactivit=
y.=20
It is configurable to any workload but the default -ck patch is aimed at th=
e=20
desktop and -cks is available with more emphasis on serverspace.

Apply to 2.6.21
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-=
ck1/patch-2.6.21-ck1.bz2

or server version
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-=
ck1/patch-2.6.21-cks1.bz2

web:
http://kernel.kolivas.org

wiki:
http://ck.wikia.com

all patches:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/


Changes since 2.6.20-ck1:

The staircase-deadline cpu scheduler has replaced the old staircase design =
in=20
this version. The extra scheduling policies in 2.6.20-ck1 of SCHED_IDLEPRIO=
=20
(idle cpu scheduling) and SCHED_ISO (unprivileged soft real time) have been=
=20
rewritten and work in the same manner on this new scheduler. In almost all=
=20
ways this should be a drop in replacement for the older -ck and no userspac=
e=20
changes should be required apart from deprecating the "compute" tunable (se=
e=20
below).

More HZ options were added to this kernel. I have had repeated requests for=
=20
this as people have found woefully coded binary only availability software=
=20
that is dependant on the HZ value for performance (specifically the game=20
servers). Since it's trivial to add extra values I offer (mostly unsupporte=
d)=20
values up to 10000 HZ. People have found game servers benefitting from up t=
o=20
4000 if I recall correctly. Note this patch will, unfortunately, cause a=20
reject with 2.6.21.1 so if you wish to apply -ck to that kernel, please app=
ly=20
2.6.21.1 first and then -ck and ignore the reject, or back out the=20
hz-raise_max-2.patch


The "interactive" tunable in
/proc/sys/kernel/interactive
still exists but its effects are now subtle, and fairness is still quite=20
strongly maintained with it enabled, and starvation is still impossible.=20
The -cks patch has this disabled by default. From the sysctl documentation=
=20
included in Documentation/sysctl/kernel here is a summary:

The staircase-deadline cpu scheduler can be set in either purely
forward-looking mode for absolutely rigid fairness and cpu distribution
according to nice level, or it can allow a small per-process history
to smooth out cpu usage perturbations common in interactive tasks by
enabling this sysctl. While small fairness issues can arise with this
enabled, overall fairness is usually still strongly maintained and
starvation is never possible. Enabling this can significantly smooth
out 3d graphics and games.


The "compute" tunable has been deprecated. The new tunable which is more=20
flexible is the use of "rr_interval"
/proc/sys/kernel/rr_interval
and this describes the millisecond duration tasks at the same priority roun=
d=20
robin between each other. The default value chosen is 6ms on UP on -ck and=
=20
10ms on UP on -cks. With more cpus it is scaled upwards. It can be changed =
on=20
the fly up to 5000. Setting it to this has a similar and even more profound=
=20
effect on throughput for pure cpu bound tasks but causes large increases in=
=20
scheduling latency. This would be highly desirable for a render or compile=
=20
farm machine though.


Split patches available:
http://www.kernel.org/pub/linux/kernel/people/ck/patches/2.6/2.6.21/2.6.21-=
ck1/patches/


=46ull patchlist:

ck1-version.patch
2.6.21-sd-0.48.patch
sched-sd-0.48-interactive_tunable.patch
sched-range.patch
sched-iso-5.4.patch
track_mutexes-1.patch
sched-idleprio-2.3.patch
sched-limit_policy_changes.patch
sched-add-above-background-load-function.patch
cfq-ioprio_inherit_rt_class.patch
cfq-iso_idleprio_ionice.patch
mm-swap_prefetch-35.patch=20
mm-convert_swappiness_to_mapped.patch=20
mm-lots_watermark.diff
mm-kswapd_inherit_prio-1.patch=20
mm-prio_dependant_scan-2.patch
mm-background_scan-2.patch
mm-filesize_dependant_lru_cache_add.patch
mm-idleprio_prio.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch=20
hz-no_default_250.patch=20
hz-raise_max-2.patch
ck-desktop-tune.patch
+/- 2.6.21-ck1-cks1.patch =20

=E4=B9=BE=E6=9D=AF=20

=2D-=20
=2Dck

--nextPart2240405.UQHMMAm5rc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGOy6NZUg7+tp6mRURAu/XAJ9GdnF6RoI92NgBl1yAFNWI9g4qvgCdH0YG
hPcAADQOvEeBZsz1c9IWWWY=
=qlsy
-----END PGP SIGNATURE-----

--nextPart2240405.UQHMMAm5rc--
