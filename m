Return-Path: <linux-kernel-owner+w=401wt.eu-S1757387AbYHNRPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbYHNRPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYHNRPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:15:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYHNRPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:15:43 -0400
Message-ID: <48A46831.7030606@redhat.com>
Date: Thu, 14 Aug 2008 10:15:29 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       John Reiser <jreiser@BitWagon.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: AT_EXECFN not useful
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I've just removed the support for AT_EXECFN again from glibc.  The
information isn't useful because the path name isn't normalized.  I.e.,
it's not the actual binary path if symlinks are followed during the
resolution.  This makes it unusable for the $ORIGIN handling.  This is
on top of the problem with relative paths.

Unless somebody has another use case where this is useful I suggest
removing AT_EXECFN support again.  It's just superfluous work and memory
use.

Of course I wouldn't object to a real implementation which always gives
me the full, normalized path name of the executable...

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkikaDEACgkQ2ijCOnn/RHSFvACgoWYhqrfJZfRe4ypFUQQR9soJ
km8AnRchCWP+irhGcgoSzd2S8iYQi7zm
=E4tz
-----END PGP SIGNATURE-----
