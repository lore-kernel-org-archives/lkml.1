Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZKKHnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZKKHnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZKKHnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:43:07 -0500
Received: from mx4.orcon.net.nz ([219.88.242.54]:41304 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbZKKHnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:43:05 -0500
Date: Wed, 11 Nov 2009 20:43:03 +1300
From: Michael Cree <mcree@orcon.net.nz>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [alpha] Add minimal support for software performance
 events.
Message-ID: <20091111074302.GA3728@omega>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
 <20091026084854.GA26990@elte.hu>
 <4AE6AAD3.3000102@orcon.net.nz>
 <20091108122226.GC11372@elte.hu>
 <20091108122739.GD11372@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <20091108122739.GD11372@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-DSPAM-Check: by mx4.orcon.net.nz on Wed, 11 Nov 2009 20:43:09 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Nov 11 20:43:09 2009
X-DSPAM-Confidence: 0.8521
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 08, 2009 at 01:27:39PM +0100, Ingo Molnar wrote:
> Mind resending the patch against latest -tip?

Not a problem.  Attached.

Cheers
Michael.


--Nq2Wo0NMKNjxTN9z
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Test-fstack-protector-all-compiler-option-for-inclus.patch"

>From df1a596909b30c9792e55acc731c2578b71d2670 Mon Sep 17 00:00:00 2001
From: Michael Cree <mcree@orcon.net.nz>
Date: Tue, 10 Nov 2009 22:20:37 +1300
Subject: [PATCH] Test -fstack-protector-all compiler option for inclusion in CFLAGS

Some architectures (e.g. Alpha) do not support the -fstack-protector-all
compiler option and the use of the option with -Werror causes the compiler
to abort.  Test that the compiler supports -fstack-protector-all before
inclusion in CFLAGS.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 tools/perf/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 64e5107..cd42c97 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -207,7 +207,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
@@ -259,6 +259,9 @@ PTHREAD_LIBS = -lpthread
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -c -Werror -fstack-protector-all - -o /dev/null >/dev/null 2>&1 && echo y"), y)
+  CFLAGS := $(CFLAGS) -fstack-protector-all
+endif
 
 
 ### --- END CONFIGURATION SECTION ---
-- 
1.6.3.3


--Nq2Wo0NMKNjxTN9z--

