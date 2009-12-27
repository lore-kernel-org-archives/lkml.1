Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbZL0NnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbZL0NnW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 08:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZL0NnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 08:43:21 -0500
Received: from mail.klingt.org ([86.59.21.178]:57367 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZL0NnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 08:43:20 -0500
Message-ID: <4B37646A.90108@klingt.org>
Date: Sun, 27 Dec 2009 14:43:06 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8pre) Gecko/20091226 Shredder/3.0.1pre
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: rename perf_event_hw_event in design document
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE3F0FF6EC3B329D6D84C2B4F"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Sun, 27 Dec 2009 14:43:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE3F0FF6EC3B329D6D84C2B4F
Content-Type: multipart/mixed;
 boundary="------------060609040009030703010503"

This is a multi-part message in MIME format.
--------------060609040009030703010503
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


perf_event_hw_event has been renamed to perf_event_attr. the design
document was still using the old name, though.

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 tools/perf/design.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)



--------------060609040009030703010503
Content-Type: text/x-patch;
 name="0001-perf-rename-perf_event_hw_event-in-design-document.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-perf-rename-perf_event_hw_event-in-design-document.patc";
 filename*1="h"

diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index fdd42a8..a58cc9a 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -21,7 +21,7 @@ There's one file descriptor per virtual counter used.
 The special file descriptor is opened via the perf_event_open()
 system call:
=20
-   int sys_perf_event_open(struct perf_event_hw_event *hw_event_uptr,
+   int sys_perf_event_open(struct perf_event_attr *hw_event_uptr,
 			     pid_t pid, int cpu, int group_fd,
 			     unsigned long flags);
=20
@@ -32,9 +32,9 @@ can be used to set the blocking mode, etc.
 Multiple counters can be kept open at a time, and the counters
 can be poll()ed.
=20
-When creating a new counter fd, 'perf_event_hw_event' is:
+When creating a new counter fd, 'perf_event_attr' is:
=20
-struct perf_event_hw_event {
+struct perf_event_attr {
         /*
          * The MSB of the config word signifies if the rest contains cpu=

          * specific (raw) counter configuration data, if unset, the next=

@@ -397,7 +397,7 @@ Notification of new events is possible through poll()=
/select()/epoll() and
 fcntl() managing signals.
=20
 Normally a notification is generated for every page filled, however one =
can
-additionally set perf_event_hw_event.wakeup_events to generate one every=

+additionally set perf_event_attr.wakeup_events to generate one every
 so many counter overflow events.
=20
 Future work will include a splice() interface to the ring-buffer.


--------------060609040009030703010503--

--------------enigE3F0FF6EC3B329D6D84C2B4F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAks3ZG0ACgkQdL+4qsZfVsvjmwCfYFMmoumUUXeNObZRG3vzLbsn
uFIAn3PePnyg1bOh7uoNEPdLa4KFwr+x
=PMXB
-----END PGP SIGNATURE-----

--------------enigE3F0FF6EC3B329D6D84C2B4F--
