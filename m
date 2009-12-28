Return-Path: <linux-kernel-owner+w=401wt.eu-S1752319AbZL1LUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbZL1LUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZL1LUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:20:09 -0500
Received: from mail.klingt.org ([86.59.21.178]:47541 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZL1LUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:20:07 -0500
Message-ID: <4B389468.5060209@klingt.org>
Date: Mon, 28 Dec 2009 12:20:08 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8pre) Gecko/20091226 Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf: replace irq_period with union in design document
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1E1686436936D2B3683C3BBF"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Mon, 28 Dec 2009 12:20:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1E1686436936D2B3683C3BBF
Content-Type: multipart/mixed;
 boundary="------------000205050406050609000903"

This is a multi-part message in MIME format.
--------------000205050406050609000903
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


perf_event_attr.irq_period has been renamed to sample_period/sample_freq.=

the design document was still using the old name, though.

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 tools/perf/design.txt |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)



--------------000205050406050609000903
Content-Type: text/x-patch;
 name="0001-perf-replace-irq_period-with-union-in-design-documen.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-perf-replace-irq_period-with-union-in-design-documen.pa";
 filename*1="tch"

diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index a58cc9a..d68515f 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -43,7 +43,11 @@ struct perf_event_attr {
          */
         __u64                   config;
=20
-        __u64                   irq_period;
+        union {
+            __u64               sample_period;
+            __u64               sample_freq;
+        };
+
         __u32                   record_type;
         __u32                   read_format;
=20
@@ -147,7 +151,7 @@ tracer is available, and event_id values can be obtai=
ned from
 Counters come in two flavours: counting counters and sampling
 counters.  A "counting" counter is one that is used for counting the
 number of events that occur, and is characterised by having
-irq_period =3D 0.
+sample_period =3D 0.
=20
=20
 A read() on a counter returns the current value of the counter and possi=
ble
@@ -170,8 +174,8 @@ into account.
=20
=20
 A "sampling" counter is one that is set up to generate an interrupt
-every N events, where N is given by 'irq_period'.  A sampling counter
-has irq_period > 0. The record_type controls what data is recorded on ea=
ch
+every N events, where N is given by 'sample_period'.  A sampling counter=

+has sample_period > 0. The record_type controls what data is recorded on=
 each
 interrupt:
=20
 /*


--------------000205050406050609000903--

--------------enig1E1686436936D2B3683C3BBF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAks4lGgACgkQdL+4qsZfVssAMwCgjN6FgvMjtOq+NALIUky4417i
L5kAnjLxgaSBDjhgAnY1Nq198/nIDOZM
=H2Bs
-----END PGP SIGNATURE-----

--------------enig1E1686436936D2B3683C3BBF--
