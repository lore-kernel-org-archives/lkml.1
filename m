Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZKAV5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZKAV5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 16:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbZKAV5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 16:57:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbZKAV5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 16:57:15 -0500
Date: Sun, 1 Nov 2009 15:55:00 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] perf latency command
Message-ID: <20091101155500.7dd22f19@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zxtQjlmYfxb8kuMUtgGt7v+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zxtQjlmYfxb8kuMUtgGt7v+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Ingo,

What follows is a set of three patches against tip/master that
implement a 'latency' sub-command for perf. You can also get it
by fetching the perf-latency-master branch from:

git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-linux.git

The 'perf latency' command is an interface for managing the=20
hwlat_detector kernel module via its debufs interface. The kernel=20
module polls the TSC looking for gaps and when a gap exceeding a
specified threshold is detected, a timestamp and the gap value (in
microseconds) is printed to stdout.

The command line arguments are a sample interval (--window), sample
duration within that window (--width), a duration for the length of
time the test should run (--duration) and a threshold (--threshold)
above which is considered a hardware latency.=20

Clark Williams (3):
  debugfs utility routines for perf
  modify perf routines to use new debugfs routines
  perf latency builtin command

 tools/perf/Documentation/perf-latency.txt |   64 +++++
 tools/perf/Documentation/perf.txt         |    2 +-
 tools/perf/Makefile                       |    3 +
 tools/perf/builtin-latency.c              |  383
 +++++++++++++++++++++++++++++
 tools/perf/builtin.h                      |    2 +-
 tools/perf/command-list.txt               |    1 +
 tools/perf/perf.c                         |   45 +---
 tools/perf/util/debugfs.c                 |  241 ++++++++++++++++++
 tools/perf/util/debugfs.h                 |   22 ++
 tools/perf/util/parse-events.c            |   17 +- 10 files changed,
 727 insertions(+), 53 deletions(-) create mode 100644
 tools/perf/Documentation/perf-latency.txt create mode 100644
 tools/perf/builtin-latency.c create mode 100644
 tools/perf/util/debugfs.c create mode 100644 tools/perf/util/debugfs.h


--Sig_/zxtQjlmYfxb8kuMUtgGt7v+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkruA7oACgkQHyuj/+TTEp3g/gCfUyjRJDfifOs0oskoAAsmfLSb
SRQAn3viVV3DAzwDN1WkQmev0zP46CDM
=luO7
-----END PGP SIGNATURE-----

--Sig_/zxtQjlmYfxb8kuMUtgGt7v+--
