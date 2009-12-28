Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZL1LUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZL1LUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZL1LUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:20:18 -0500
Received: from mail.klingt.org ([86.59.21.178]:47596 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbZL1LUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:20:16 -0500
Message-ID: <4B389470.6070209@klingt.org>
Date: Mon, 28 Dec 2009 12:20:16 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8pre) Gecko/20091226 Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf: replace record_type with sample_type in design
 document
References: <2ba0ea41a0372f31fcebda030440a55d37beeefb.1261999187.git.tim@klingt.org>
In-Reply-To: <2ba0ea41a0372f31fcebda030440a55d37beeefb.1261999187.git.tim@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6E9D2D9B5BA8D2D8B1C15A9A"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Mon, 28 Dec 2009 12:20:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6E9D2D9B5BA8D2D8B1C15A9A
Content-Type: multipart/mixed;
 boundary="------------000606040609040408050300"

This is a multi-part message in MIME format.
--------------000606040609040408050300
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


perf_event_attr.record_type has been renamed to sample_type,
perf_event_record_format with perf_event_sample_format. the design
document was still using the old name.

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 tools/perf/design.txt |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)



--------------000606040609040408050300
Content-Type: text/x-patch;
 name="0002-perf-replace-record_type-with-sample_type-in-design-.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0002-perf-replace-record_type-with-sample_type-in-design-.pa";
 filename*1="tch"

diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index d68515f..567a041 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -48,7 +48,7 @@ struct perf_event_attr {
             __u64               sample_freq;
         };
=20
-        __u32                   record_type;
+        __u32                   sample_type;
         __u32                   read_format;
=20
         __u64                   disabled       :  1, /* off by default  =
      */
@@ -175,20 +175,25 @@ into account.
=20
 A "sampling" counter is one that is set up to generate an interrupt
 every N events, where N is given by 'sample_period'.  A sampling counter=

-has sample_period > 0. The record_type controls what data is recorded on=
 each
+has sample_period > 0. The sample_type controls what data is recorded on=
 each
 interrupt:
=20
 /*
- * Bits that can be set in hw_event.record_type to request information
+ * Bits that can be set in hw_event.sample_type to request information
  * in the overflow packets.
  */
-enum perf_event_record_format {
-        PERF_RECORD_IP          =3D 1U << 0,
-        PERF_RECORD_TID         =3D 1U << 1,
-        PERF_RECORD_TIME        =3D 1U << 2,
-        PERF_RECORD_ADDR        =3D 1U << 3,
-        PERF_RECORD_GROUP       =3D 1U << 4,
-        PERF_RECORD_CALLCHAIN   =3D 1U << 5,
+enum perf_event_sample_format {
+        PERF_SAMPLE_IP              =3D 1U << 0,
+        PERF_SAMPLE_TID             =3D 1U << 1,
+        PERF_SAMPLE_TIME            =3D 1U << 2,
+        PERF_SAMPLE_ADDR            =3D 1U << 3,
+        PERF_SAMPLE_READ            =3D 1U << 4,
+        PERF_SAMPLE_CALLCHAIN       =3D 1U << 5,
+        PERF_SAMPLE_ID              =3D 1U << 6,
+        PERF_SAMPLE_CPU             =3D 1U << 7,
+        PERF_SAMPLE_PERIOD          =3D 1U << 8,
+        PERF_SAMPLE_STREAM_ID       =3D 1U << 9,
+        PERF_SAMPLE_RAW             =3D 1U << 10,
 };
=20
 Such (and other) events will be recorded in a ring-buffer, which is


--------------000606040609040408050300--

--------------enig6E9D2D9B5BA8D2D8B1C15A9A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAks4lHAACgkQdL+4qsZfVsvXywCgia29FI8hZu5U2Bjkmzj1YbM5
Cx4Amwcade6ZEjlSUV7QxUp4gAxOrHfP
=X9DJ
-----END PGP SIGNATURE-----

--------------enig6E9D2D9B5BA8D2D8B1C15A9A--
