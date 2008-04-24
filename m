Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYDXOTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYDXOTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYDXOTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:19:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYDXOTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:19:42 -0400
Message-ID: <481096C3.2020206@redhat.com>
Date: Thu, 24 Apr 2008 07:18:43 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com> <20080424112514.055d8071@the-village.bc.nu>
In-Reply-To: <20080424112514.055d8071@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
> Given we will never have 2^32 socket types, and in a sense this is part
> of the type why not just use
> 
> 	socket(PF_INET, SOCK_STREAM|SOCK_CLOEXEC, ...)
> 
> that would be far far cleaner, no new syscalls on the socket side at all.

You have a strange sense of "clean" I must say.

I don't think this is a viable approach because it is not about the
range.  People can and do select arbitrary values for those types.
Until a value is officially recognized and registered it is in fact best
to choose a (possibly large) random value to not conflict with anything
else.  Who can guarantee that whatever bit is chosen for SOCK_CLOEXEC
isn't already used by someone?

Add to this that it's not a complete solution (no such hack possible for
accept) and I think using a new interface is cleaner(tm).

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIEJbD2ijCOnn/RHQRAnUBAKDFxC7Xkl8Qlo5u7PS8XBx4WrNzRQCgm2Ic
mV6zeglZaTJMn3IuGv3tB60=
=06jC
-----END PGP SIGNATURE-----
