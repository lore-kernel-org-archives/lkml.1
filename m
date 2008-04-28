Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbYD1FqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbYD1FqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYD1Fpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:45:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYD1Fpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:45:53 -0400
Message-ID: <481563E4.5090408@redhat.com>
Date: Sun, 27 Apr 2008 22:43:00 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] eventfd, signalfd, timerfd, epoll_create w/flags
References: <200804280315.m3S3FKsw028335@devserv.devel.redhat.com> <Pine.LNX.4.64.0804272200090.18184@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0804272200090.18184@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> unsigned int oflags_remap(const struct oflags_rmap *m, int n,
> 			  int f, int *rf)
> {
> 	int i;
> 	for (i = 0, *rf = 0; i < n; i++, m++)
> 		if (f & m->f) {
> 			*rf |= m->of;
> 			f &= ~m->f;
> 		}
> 	return f ? -EINVAL: 0;
> }

This will be more expensive in terms of code and runtime.  Plus: who
knows whether there will really be other flags which can be used like
this?  I think it's overkill to do this.  If at some point there are
more flags which are handled the same way one could do something like
this but I don't think it's necessary now.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkgVY+QACgkQ2ijCOnn/RHTN9gCdG6HxUENiLQqmSFPc5LMAcHna
Nc0AnAhma85jwTCS+XTsQ/MrNngQAT+i
=3vVs
-----END PGP SIGNATURE-----
