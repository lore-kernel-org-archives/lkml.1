Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbZCXMeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbZCXMeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 08:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755868AbZCXMdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 08:33:51 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZCXMdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:33:50 -0400
Subject: Re: [PATCH v5 09/13] PCI: Introduce /sys/bus/pci/devices/.../remove
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alex Chiang <achiang@hp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       kaneshige.kenji@jp.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <20090324034659.9e1f97dc.akpm@linux-foundation.org>
References: <20090320204327.12275.43010.stgit@bob.kio>
	 <20090320205636.12275.1825.stgit@bob.kio> <49C74FCC.7070308@jp.fujitsu.com>
	 <20090324032304.GB6175@ldl.fc.hp.com> <20090324092525.GE6605@elte.hu>
	 <20090324034659.9e1f97dc.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PbPNhkjRfaeaNUT+9JaG"
Date: Tue, 24 Mar 2009 13:32:52 +0100
Message-Id: <1237897972.4320.79.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PbPNhkjRfaeaNUT+9JaG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 03:46 -0700, Andrew Morton wrote:

> But I don't think we've seen a coherent description of what's actually
> _wrong_ with the current code.  flush_cpu_workqueue() has been handling
> this case for many years with no problems reported as far as I know.
>=20
> So what has caused this sudden flurry of reports?  Did something change i=
n
> lockdep?  What is this
>=20
> [  537.380128]  (events){--..}, at: [<ffffffff80257fc0>] flush_workqueue+=
0x0/0xa0
> [  537.380128]
> [  537.380128] but task is already holding lock:
> [  537.380128]  (events){--..}, at: [<ffffffff80257648>] run_workqueue+0x=
108/0x230
>=20
> supposed to mean?  "events" isn't a lock - it's the name of a kernel
> thread, isn't it?  If this is supposed to be deadlockable then how?

events is indeed the schedule_work workqueue thread name -- I just used
that for lack of a better name.

> Because I don't immediately see what's wrong with e1000_remove() calling
> flush_work().  It's undesirable, and we can perhaps improve it via some
> means, but where is the bug?

There is no bug -- it's a false positive in a way. I've pointed this out
in the original thread, see
http://thread.gmane.org/gmane.linux.kernel/550877/focus=3D550932

johannes

--=-PbPNhkjRfaeaNUT+9JaG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyNLxAAoJEKVg1VMiehFYERgP/0C7dgVWgCKXkUmN4vgb8g33
W5P3nIc5fuV2NiWy9EhAnEDc7lf7/sBKQE2ZNjPfsbSp3w6MFaPuUvePiOeS9sJy
lrZWyG026/ylYXPs0kl4r9ulo+PlO2RwthRzSlTbuIAWFm3I3jT2unJ7kc1cfk2F
AkPM36Jrqcmjfk2Tdk7rk29trC6gsrLsej3u7vQiqveRGQiYXUb3KMnAo7xoxki5
6hs7Uhl5ZGqcpgIsn/8OndTq8DO8j7PKS1EPxIxCFGoyHbwyv6BnQR/YlhQuFd7X
rBLjgZRgw7Wlbb3W09NN5RpnCy3SXvgc/VMLh9BDGK0Oo7sKUQq6bW+2VX5nubRs
T1X/2jC/CWgHKjjySvgqP64+rjCJEkpujn69Rs3depLIxq/s7zzP0JV0QuRebkVW
1YRcPvWW1Gj74xl3GC4j9ewSI6IZbNTB/aU4hNC5hHB/XPYiUWE9ttySNmezK67Z
+Sya6D5BVmSbdnhAw5xA5RB2IEdQhtBH+JSMQIkqEB8LeGRwrdQg2rTFY6moMBcf
7+j8mk4qUPvNR8gyIBsK0RwlS1bf54bla7W8iq0tzMEbq0Q8dsFVZYM7ZaoNk62W
/3WAmhb6pNEi6SbgZv21Nt7dAY3gdJNXkeDQfuwN8bNlCUOgTSUNp4/IWwpNSFxy
iJtTY2v49aMAHE4jDG6V
=UjTU
-----END PGP SIGNATURE-----

--=-PbPNhkjRfaeaNUT+9JaG--

