Return-Path: <linux-kernel-owner+w=401wt.eu-S935801AbXG0UBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935801AbXG0UBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762483AbXG0UBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:01:40 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4202 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763576AbXG0UBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:01:39 -0400
Date: Fri, 27 Jul 2007 16:00:50 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Cc: nhorman@tuxdriver.com
Subject: [PATCH 0/3] core_pattern: cleaned up repost/continuing post of core_pattern enhancements
Message-ID: <20070727200050.GA18946@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here we go

As promised, I'm reposting the core_pattern enhancements I've done over the past
few days.  These three patches replace and conintue the work contained in the
following patches, and can replace them:
update-coredump-path-in-kernel-to-not-check-coredump-rlim-if-core_pattern-is-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-sparc64-fix.patch
allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe-fix-2-sparc64-fix.patch


Changelog:
For some time /proc/sys/kernel/core_pattern has been able to set its output
destination as a pipe, allowing a user space helper to receive and intellegently
process a core.  This infrastructure however has some shortcommings which can be
enhanced.  Specifically:

1) The coredump code in the kernel should ignore RLIMIT_CORE limitation when
core_pattern is a pipe, since file system resources are not being consumed in
this case, unless the user application wishes to save the core, at which point
the app is restricted by usual file system limits and restrictions.

2) The core_pattern code should be able to parse and pass options to the user
space helper as an argv array.  The real core limit of the uid of the crashing
proces should also be passable to the user space helper (since it is overridden
to zero when called).

3) Some miscelaneous bugs need to be cleaned up (specifically the recognition of
a recursive core dump, should the user mode helper itself crash.  Also, the core
dump code in the kernel should not wait for the user mode helper to exit, since
the same context is responsible for writing to the pipe, and a read of the pipe
by the user mode helper will result in a deadlock.

All patches tested by me, with successful results.

Thanks & Regards
Neil


-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
