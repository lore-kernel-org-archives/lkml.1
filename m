Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbXKBPfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbXKBPfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbXKBPfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:35:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbXKBPfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:35:07 -0400
Message-ID: <472B4378.80809@redhat.com>
Date: Fri, 02 Nov 2007 08:34:16 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu>	<4729E7E4.8070208@openvz.org>	<4729E936.4040400@redhat.com>	<4729EB3C.9050102@openvz.org>	<472A6D91.1020300@redhat.com>	<472AD7D6.80900@openvz.org> <20071102010419.23f3db5c.akpm@linux-foundation.org> <472ADC78.6070706@openvz.org> <472B2EBD.7070007@redhat.com> <472B327E.2060006@openvz.org>
In-Reply-To: <472B327E.2060006@openvz.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pavel Emelyanov wrote:
> So is "everything else", you mentioned, covered with the problems
> above?

No, it's not.  If you'd read the mail carefully you'd notice that the
use of PIDs especially in robust futexes is part of the API and that it
simply isn't acceptable to say "don't do that".  A robust mutex can be
stored in any file and as long as two processes have access to the same
file (or they can pass each other shared memory) the underlying futex
functionality simply must work.

This whole approach to allow switching on and off each of the namespaces
is just wrong.  Do it all or nothing, at least for the problematic ones
like NEWPID.  Having access to the same filesystem but using separate
PID namespaces is simply not going to work.

You also brush completely over the SysV IPC issue.

And I doubt that I spent enough time thinking about all this to arrive
at the more subtle problems.  I don't think especially the PID namespace
is ready at all at this time.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD4DBQFHK0N42ijCOnn/RHQRAkPyAJiDR9ZEPUbCdEa2xk+Te80B7avDAJ4mgy7v
jgtZG129yBUGBrpQ8fbn7w==
=ho0Z
-----END PGP SIGNATURE-----
