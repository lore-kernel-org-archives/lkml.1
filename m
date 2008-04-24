Return-Path: <linux-kernel-owner+w=401wt.eu-S1760910AbYDXQxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbYDXQxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbYDXQx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:53:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbYDXQx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:53:27 -0400
Message-ID: <4810BAE3.5070406@redhat.com>
Date: Thu, 24 Apr 2008 09:52:51 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michael Kerrisk <mtk.manpages@gmail.com>,
       David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>  <20080424112514.055d8071@the-village.bc.nu>  <alpine.LFD.1.10.0804240828100.2779@woody.linux-foundation.org>  <20080424.083908.147395158.davem@davemloft.net> <517f3f820804240903y788102bar5c7d1fa9bcee1c8a@mail.gmail.com> <alpine.LFD.1.10.0804240921460.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804240921460.2779@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> So while I don't dislike the indirect system call, I do think that if we 
> can handle a large case of the problems with an added flag to already 
> existing system calls,

The easy, clean cases I already handled back when.  I wouldn't have
implemented socket this way to preserve the function signature but
that's just me.  It's hopefully over now.

What remains isn't that easy to fix.  We need syscall interface changes.
 Yes, I'd like to avoid them, too.  But sometimes the existing
interfaces are just wrong and now we have to make a decision: new
syscalls or sys_indirect.  No way around it.

As far as the userlevel interface is concerned, this is not quite the
same.  As explained before, I've anticipated some of the problems.
signalfd, eventfd have no flags parameter in the syscall but I have them
in the userlevel interface.  I.e., any kernel change will be hidden.  At
least as far as the interface signature is concerned.


So, the question still is on the table: do you want sys_indirect?

If yes, then then new sys_accept would use sys_indirect instead of a new
entry point.  If you don't want sys_indirect, then I'll submit a new
sys_accept syscall (already have the patch here ready to go).

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIELrj2ijCOnn/RHQRAtewAJ4+826rxwtckEvvOaXdiNSr/5ECPACfWwTn
hgt5EYrrj/imBloPE7DxHJA=
=T6LW
-----END PGP SIGNATURE-----
