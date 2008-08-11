Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYHKOMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYHKOMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYHKOMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:12:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbYHKOMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:12:12 -0400
Message-ID: <48A0487B.7080600@redhat.com>
Date: Mon, 11 Aug 2008 07:11:07 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dario Faggioli <raistlin@linux.it>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC 0/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
 and	groups
References: <1218462574.6450.24.camel@Palanthas>
In-Reply-To: <1218462574.6450.24.camel@Palanthas>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dario Faggioli wrote:
> I'm spending some time implementing the POSIX real-time SCHED_SPORADIC
> scheduling policy on top of the mainline Linux kernel, and here it is
> the code in its very first version.

I'm not commenting on the code or usefulness of ht features.  I just
want to point out a problem.

The authors of that POSIX extension unfortunately decided to extend the
sched_param structure.  If you look at the definition of that structure
Linux uses you'll see that there is no place for this.  I.e., any
implementation of that feature following the POSIX spec to the letter
will introduce major headache in the form of binary incompatibility.

In case the features is useful enough (I actually always thought it
isn't an have actually proposed to remove it again from POSIX) then I
would rather prefer to not claim support for this feature in the POSIX
way.  One could still implement it as described.  But change the
interface to not require the sched_param change.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkigSHsACgkQ2ijCOnn/RHS23QCfWNJRqnrhgSXGpnNag/nVeKcC
uwIAn3fUIwku+i+xegBDhfh5yaIW/VCo
=LCa/
-----END PGP SIGNATURE-----
