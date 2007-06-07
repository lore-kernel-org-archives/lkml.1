Return-Path: <linux-kernel-owner+w=401wt.eu-S934830AbXFGVch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbXFGVch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935055AbXFGVcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:32:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765929AbXFGVcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:32:06 -0400
Message-ID: <46687923.2020204@redhat.com>
Date: Thu, 07 Jun 2007 14:31:15 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> 	syscall_indirect(unsigned long flags, sigset_t *, 
> 			 int syscall, unsigned long args[6]);

It's a kernel detail, so if this is how you want it, let it be.  I can
certainly live with this.  The only comment about the comments I would
have are

- - think hard about the additional things you want to set

- - make it a bit expendable so that we don't run out of bits.  Maybe
  we also have to pass some additional integer values.

At userlevel this is of course something we cannot expose.  Here we will
need new interfaces like acceptNG, socketNG, etc which themselves can
call this syscall.


This extension reminds me of something we've talked about several times
in the past (I know that I at least discussed this with Ingo).  You
basically implement little scriptlets.  In your call they are simply

    current->flags_arg = flags;
    current->sigmask_arg = sigmask;
    r = syscall(nr, ...);
    current->flags_arg = 0;
    current->sigmask_arg = NULL;
    return r;

This could be made more generic in that you can allow the script to do
more.  The threadlets etc are not too different from this.

If all this is unwanted then go with what you proposed.  Otherwise think
about a more generic approach.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGaHkj2ijCOnn/RHQRAhWoAJ4loMzrYJQDCU4e6jdOfjL4LG/TsACguhUL
ldVvp0PWIazV2iAWraCc+IU=
=VGDR
-----END PGP SIGNATURE-----
