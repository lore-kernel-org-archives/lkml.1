Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbZKTLMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbZKTLMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZKTLMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:12:07 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:35070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZKTLMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:12:05 -0500
Subject: kvm hangs w/o nolapic
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm <kvm@vger.kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rMrPnJmgjq+1ZnBdmz3r"
Date: Fri, 20 Nov 2009 12:11:55 +0100
Message-ID: <1258715515.7094.51.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rMrPnJmgjq+1ZnBdmz3r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My 2.6.32-rc7 kvm (both guest+host, x86_64) hangs w/o "nolapic" here:

  while (lapic_cal_loops <=3D LAPIC_CAL_LOOPS)
     cpu_relax();

because lapic_cal_loops never changes from -1.

Code was last changed by
commit 2f04fa888d270951b9e0fe9e641ddd560d77ad1b
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sun Aug 24 02:01:54 2008 -0700

    x86: apic copy calibrate_APIC_clock to each other in apic_32/64.c

but I haven't tested reverting that.

johannes

--=-rMrPnJmgjq+1ZnBdmz3r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBnl4AAoJEODzc/N7+QmaoRsP/jbrs/N0x3L3lBoDeGzx0JA5
gf0+XOR8voAG9cxuK/x1FG9w16kVGhyMAt6L4I9QpdsU/ufJIACUqoflggHKPzyK
q9qxqxaTXCxZOSA226rDnk+B+MXS2PWXGfB7DWCF26mwgP4kjHgqtim+0ksRwa+A
ecE57XxdqpIdC//7q7kZyFhwmXuWUy+f+SiZeSb1aRoENFvuGuqi8xEB00Xt/Hex
ePHig4mIEjuXKe45csfo/NfZpx3tvwWHh1reR3fQ1uJGCCuZnWnJAJJGpxwm/l8o
SM5jboyU5Q1N+UcqVymJZUq5H7ns4It+kYQkwBhm0L7Q5Y+TRsGrnejCeO4XGbiv
q6c0Pk1xPP9tagQ3TqJ4N7zpB/K8oZnJyjCbHKqX6bnfWVFClOrbnLF61tAe+ujg
ddZS6p5LrH8+DtVaUkVkwNXNGUB30DqVnI59m6ZZmj6fsb8AbMFXtFMJz/PMSNA2
qCdB8x6Hg5twFDPxd87gQ6CiaY/pnP8K1ATO9UfBLv1Tg+x+i2ZfV8cdCxSkYDqe
WynhPQsnBmskd59dDPHcjdoAAH5MPcnY+SYO2ASKVb49G0QkNUMD1DhirLdX6DE4
bKUDZEC0blg+W+sDBPYLnblZ35DGDC6s07XgcSBiOB/0qoe0H5ImQqlqyo350mgG
yOBBk2bUYM0to7cxWAdz
=R4+x
-----END PGP SIGNATURE-----

--=-rMrPnJmgjq+1ZnBdmz3r--

