Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbXFDFW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbXFDFW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 01:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXFDFWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 01:22:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbXFDFWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 01:22:22 -0400
Message-ID: <4663A180.8050506@redhat.com>
Date: Sun, 03 Jun 2007 22:22:08 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2> <4663067C.9050002@redhat.com> <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com> <466319DB.80800@redhat.com> <Pine.LNX.4.64.0706031311490.13247@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706032210040.23741@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706032210040.23741@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> I actually think that a new system call is _hugely_ messy. It means that 
> anybody who wants to use a new feature needs to have a new glibc.

Strange definition of "messy".  Have you looked at the proposed dup2
extension?  Magic value, semantics which don't match what the function
does today.  That's messy.

The private descriptors are something new, programs have to be adjusted.
 The open() extension will allow them to be used naturally without
additional interfaces.  This leaves converting normal descriptors into
private ones.  If the new syscall isn't yet available it's easy enough
to use the syscall() function.  The parameters are simple integer so no
tricks needed.

I don't think the requirement for a new glibc should cloud the judgement
when it comes to cleanliness of the API.  The new syscall wins there
clearly, I hope you agree.  Even the dup2() approach requires program to
either be compiled with headers which have the definitions (i.e., a new
glibc) or programs have to carry their own definitions of the magic
constants and O_NONSEQ.  I really cannot see any advantage of
misappropriating dup2.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGY6GA2ijCOnn/RHQRAtQ1AJ4+dDIgeBKlggt4U+lyZnDfQJZ/VQCfRbG4
0FtGWqlLOWFlspMJ9S3xQ7E=
=jrG1
-----END PGP SIGNATURE-----
