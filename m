Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbXISPWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbXISPWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbXISPV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:21:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbXISPV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:21:56 -0400
Message-ID: <46F13E8B.4050309@redhat.com>
Date: Wed, 19 Sep 2007 08:21:47 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: follow-up: discrepancy with POSIX
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

As a follow up to my question from yesterday on the netdev list what I
think is a real problem.  Either in the kernel or in the POSIX spec.

The POSIX spec currently says this about SOCK_DGRAM sockets:

  If  address is a null address for the protocol, the socket’s peer
  address shall be reset.

The term "null address" is not further specified but it will usually be
read to allow the following scenario to work out:

   fd = socket(AT_INET6, ...)

   connect(fd, ...some IPv6 address...)

   struct sockaddr_in6 sin6 = { .sin6_family = AF_INET6 };
   connect(fd, &sin6, sizeof (sin6));

   connect(fd, ...some new IPv6 address...)

This does not work on Linux in the moment.  The socket remains connected
to the old IPv6 address but the second connect() call does succeed (this
does not sound OK).  What does work is if the connect call to
disassociate the address uses AF_UNSPEC instead of AF_INET6.


The question is: do people here think this is a problem in the POSIX
spec?  Binding to :: and 0.0.0.0 isn't possible, so maybe the Linux
implementation should allow this?

If you think the POSIX spec is wrong (and can point to other
implementations doing the same as Linux) let me know and I'll work on
getting the spec changed.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG8T6L2ijCOnn/RHQRAnSRAJ9sXDGG9OepEQWQInaPgwxCWlaH6wCghqim
ULttg5/lU8c1rSpBnoRCjB8=
=nGVv
-----END PGP SIGNATURE-----
