Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbYEMUW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbYEMUW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932198AbYEMUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:16:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190AbYEMUQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:16:04 -0400
Date: Tue, 13 May 2008 13:12:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 27/37] sparc32: Dont twiddle PT_DTRACE in exec.
Message-ID: <20080513201234.GB31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc32-don-t-twiddle-pt_dtrace-in-exec.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit: c07c6053c41f736711ed856aa377007078c7c396 ]

That bit isn't used on this platform.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/process.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -640,11 +640,6 @@ asmlinkage int sparc_execve(struct pt_re
 			  (char __user * __user *)regs->u_regs[base + UREG_I2],
 			  regs);
 	putname(filename);
-	if (error == 0) {
-		task_lock(current);
-		current->ptrace &= ~PT_DTRACE;
-		task_unlock(current);
-	}
 out:
 	return error;
 }

-- 
