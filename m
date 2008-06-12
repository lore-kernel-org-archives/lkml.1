Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbYFLU0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbYFLU0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbYFLU0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:26:32 -0400
Received: from [194.117.236.238] ([194.117.236.238]:39346 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbYFLU0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:26:31 -0400
Date: Thu, 12 Jun 2008 23:25:46 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: tzanussi@gmail.com
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] relay interface bugfixes and early logging support
Message-ID: <20080612232546.6906bc6d@linux360.ro>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Dt6nRmq6Q909fOEJKYthA5=";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Dt6nRmq6Q909fOEJKYthA5=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This patch series was created while working on kmemtrace, a project
that needs to do early tracing in the kernel, but the bugfixes are
relevant to any project that uses the relay interface.

Only the third patch introduces a new feature, that is, buffers that
have no associated files. This is exactly what kmemtrace needs,
although other tracing projects can use this new API to trace early
code and export the data as soon as VFS is ready.

Mathieu Desnoyers from LTTng has already expressed his interest in this
functionality.

This, along with kmemtrace, is part of my work within this year's GSoC,
mentored by Pekka Enberg.

Eduard - Gabriel Munteanu (3):
  relay: Fix 4 off-by-one errors occuring when writing to a CPU buffer.
  relay: Fix race condition which occurs when reading across CPUs.
  relay: Add buffer-only channels; useful for early logging.

 Documentation/filesystems/relay.txt |   11 +++
 include/linux/relay.h               |   19 ++++--
 kernel/relay.c                      |  133 ++++++++++++++++++++++++++-----=
----
 3 files changed, 125 insertions(+), 38 deletions(-)

--Sig_/Dt6nRmq6Q909fOEJKYthA5=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUBSFGGUtxcOkuRpXptAQK63g/+PMds6uTY3On3/Ogb4QFhRJmOF3CCMRQx
dWiG1oumLAtc+7E6yHeIHVtdWhLc5AJd+DCBnYwnmRoJ4yqMcEJgVCTC4QD439gD
vVXV42i2HpPdOxa+BONrEEa+ysGqgh0FxyjhLJuvHXAPuZ4psYM0dsqCzX0O8vVe
GLQALpN1GGXrtQ5yxAOEsuY0pfl9aUiCIM7X9lCkhvu2Yg4sQmWX2MCPtw1sDMze
yqW5Sok7Qa8DzKrG0YP5jsslXMXjZkJqqP1LsErHMqgHBtS6JYpSFnv/M5SCcjrB
oZzrepD8dRWnVuJjRUGes+79xeHzaJrkZ2Ap2UrlS1ZvUQlfU6fyh5d+DAcOc0Lx
XWZcVvLT5CyPSxFSlzzUYUgjd3I577CBKV9tWktEK+3YtRVruKumANynlAs2WzDX
5Z+mLhPWjRsWc/1HBQ5p5dT4D0XVCVhjCYe1BKNui0+Flgfa6XD6kMfycl0L2t1n
1cIV4DqGFWWAvYu6YxYL+uiq3l22xIrp9kcJGXVh+U31ASpHTXlaer0MMKbSYwGJ
AeHtl3FbhsaLxe5suO8s6YCSWBP89cg/VK7IlRf/lCbqEKPSux1Yyw3h0HK3Igtg
UCg/U3jgJiTJH+jNFU/4Sts3oAV/svIgnhZKuqSJVphrixeq6cvpVuvlDJCvhyly
8OBOMUaqfOg=
=xB6u
-----END PGP SIGNATURE-----

--Sig_/Dt6nRmq6Q909fOEJKYthA5=--
