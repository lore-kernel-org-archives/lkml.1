Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbXGWFxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbXGWFxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 01:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXGWFw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 01:52:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbXGWFw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 01:52:58 -0400
Message-ID: <46A4420D.8070900@redhat.com>
Date: Sun, 22 Jul 2007 22:52:13 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, jdike@karaya.com
Subject: Fix compiling UML
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following patch is needed to get 2.6.23-rc1 to compile for UML
on x86-64.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/arch/um/os-Linux/aio.c b/arch/um/os-Linux/aio.c
index b126df4..9c70cb0 100644
- --- a/arch/um/os-Linux/aio.c
+++ b/arch/um/os-Linux/aio.c
@@ -75,9 +75,10 @@ static int do_aio(aio_context_t ctx, enum aio_type type, int fd, char *buf,
 				.aio_buf	= (unsigned long) buf,
 				.aio_nbytes	= len,
 				.aio_offset	= offset,
+				.aio_flags	= 0,
+				.aio_resfd	= 0,
 				.aio_reserved1	= 0,
- -				.aio_reserved2	= 0,
- -				.aio_reserved3	= 0 });
+				.aio_reserved2	= 0 });

 	switch(type){
 	case AIO_READ:

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGpEIN2ijCOnn/RHQRAsTjAJ9Rs6wJFPxQ/ivqK3yaC5pymtcGhACgzWID
l2vwUwABAk8mAiw/g+7y3U0=
=bPu6
-----END PGP SIGNATURE-----
