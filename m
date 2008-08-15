Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYHPACI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYHPACI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 20:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYHPABz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 20:01:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48152 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbYHPABz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 20:01:55 -0400
Message-ID: <48A61878.2060000@redhat.com>
Date: Fri, 15 Aug 2008 16:59:52 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: John Reiser <jreiser@BitWagon.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AT_EXECFN not useful
References: <48A46831.7030606@redhat.com> <48A50FBF.40500@BitWagon.com>
In-Reply-To: <48A50FBF.40500@BitWagon.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

John Reiser wrote:
> AT_EXECFN does provide one actual path, namely the one that was passed
> to namei.  This path works for some uses and some cases, including some
> uses and some cases of $ORIGIN.

It is not possible to use the raw path provided.  One _always_ would
have to canonicalize the path (call realpath etc).  That's terribly
expensive and it requires that nothing in the path hasn't changed.


> The path which sometimes is revealed
> by readlink("/proc/self/exe",) also works for some uses and some cases,
> including some uses and some cases of $ORIGIN.

The information is always correct when it is provided.  If the file goes
away then the AT_EXECFN use case also fails since realpath fails, or
worse, provides wrong data since it's using newer files.


> Neither /proc/self/exe
> nor AT_EXECFN works for all uses and all cases.

The only case where AT_EXECFN has an advantage is when /proc isn't
mounted.  That's not supported anyway because this is the only way for
many things how the kernel exposes data (sysctl is deprecated) and we
need this information in many places.


> Please provide a statement or citation which describes "the problem with
> relative paths."

If the program is started via a relative path AT_EXECFN has this string.


> AT_EXECFN is useful when readlink("/proc/self/exe",) disappears

As said above, in that case it isn't useful either because one cannot
verify the value.

I've removed all support for AT_EXECFN and won't put it back since there
is no use case where it has any advantage.  realpath() is terribly slow.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkimGHcACgkQ2ijCOnn/RHS8LACfdknhKbYiaKo8fe4hFgRq3VZn
emYAn2vdy7Jddzia7m6hLj6nMlnU0HiO
=NJxG
-----END PGP SIGNATURE-----
