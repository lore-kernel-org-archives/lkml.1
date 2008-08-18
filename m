Return-Path: <linux-kernel-owner+w=401wt.eu-S932723AbYHRTnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723AbYHRTnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762680AbYHRTkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:40:03 -0400
Received: from ns2.suse.de ([195.135.220.15]:42002 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757589AbYHRTjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:39:53 -0400
Date: Mon, 18 Aug 2008 12:20:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Benedict Verheyen <benedict.verheyen@gmail.com>,
       Jeff Dike <jdike@linux.intel.com>
Subject: [patch 36/49] uml: stub needs to tolerate SIGWINCH
Message-ID: <20080818192036.GK10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="uml-stub-needs-to-tolerate-sigwinch.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Dike <jdike@addtoit.com>

commit 3d5ede6f776bdb1483bcd086f79c3bf41fed3865 upstream

We lost the marking of SIGWINCH as being OK to receive during stub
execution, causing a panic should that happen.

Cc: Benedict Verheyen <benedict.verheyen@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/os-Linux/skas/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -55,7 +55,7 @@ static int ptrace_dump_regs(int pid)
  * Signals that are OK to receive in the stub - we'll just continue it.
  * SIGWINCH will happen when UML is inside a detached screen.
  */
-#define STUB_SIG_MASK (1 << SIGVTALRM)
+#define STUB_SIG_MASK ((1 << SIGVTALRM) | (1 << SIGWINCH))
 
 /* Signals that the stub will finish with - anything else is an error */
 #define STUB_DONE_MASK (1 << SIGTRAP)

-- 
