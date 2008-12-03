Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbYLCUOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbYLCUOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYLCTyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:38 -0500
Received: from kroah.org ([198.145.64.141]:60356 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755099AbYLCTyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:35 -0500
Date: Wed, 3 Dec 2008 11:52:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Kumar Gala <galak@kernel.crashing.org>
Subject: [patch 061/104] Remove -mno-spe flags as they dont belong
Message-ID: <20081203195258.GJ8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="remove-mno-spe-flags-as-they-dont-belong.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kumar Gala <galak@kernel.crashing.org>

commit 65ecc14a30ad21bed9aabdfd6a2ae1a1aaaa6a00 upstream, tweaked to get
it to apply to 2.6.27

For some unknown reason at Steven Rostedt added in disabling of the SPE
instruction generation for e500 based PPC cores in commit
6ec562328fda585be2d7f472cfac99d3b44d362a.

We are removing it because:

1. It generates e500 kernels that don't work
2. its not the correct set of flags to do this
3. we handle this in the arch/powerpc/Makefile already
4. its unknown in talking to Steven why he did this

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Tested-and-Acked-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,8 +11,6 @@ obj-y     = sched.o fork.o exec_domain.o
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
 
-CFLAGS_REMOVE_sched.o = -mno-spe
-
 ifdef CONFIG_FTRACE
 # Do not trace debug files and internal ftrace files
 CFLAGS_REMOVE_lockdep.o = -pg
@@ -21,7 +19,7 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
 CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
-CFLAGS_REMOVE_sched.o = -mno-spe -pg
+CFLAGS_REMOVE_sched.o = -pg
 endif
 
 obj-$(CONFIG_PROFILING) += profile.o

