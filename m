Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbXKXHsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbXKXHsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 02:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbXKXHsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 02:48:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbXKXHsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 02:48:10 -0500
Message-ID: <4747D610.6040108@redhat.com>
Date: Fri, 23 Nov 2007 23:43:12 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv5 4/5] Allow setting O_NONBLOCK flag for new sockets
References: <200711210728.lAL7SoJO015052@devserv.devel.redhat.com> <4747D00D.1090603@cosmosbay.com>
In-Reply-To: <4747D00D.1090603@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
> 1) Can the fd passing with recvmsg() on AF_UNIX also gets O_CLOEXEC
> support ?

Already there, see MSG_CMSG_CLOEXEC.


> 2) Why this O_NONBLOCK ability is needed for sockets ? Is it a security
> issue, and if yes could you remind it to me ?

No security issue.  But look at any correct network program, all need to
set the mode to non-blocking.  Adding this support to the syscall comes
at almost no cost and it cuts the cost for every program down by one or
two syscalls.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHR9YQ2ijCOnn/RHQRArbyAJ0d25FPg/BWmJ4YIzJKhO9iaBJNXwCgmpuX
PAA6u3Dc56AlBegTRqtqJPc=
=j5vi
-----END PGP SIGNATURE-----
