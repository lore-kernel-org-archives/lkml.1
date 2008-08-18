Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbYHRS6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbYHRS6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761426AbYHRS4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:56:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:43075 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761420AbYHRS4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:56:34 -0400
Date: Mon, 18 Aug 2008 11:44:10 -0700
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 29/60] sparc64: Fix global reg snapshotting on self-cpu.
Message-ID: <20080818184410.GD29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-fix-global-reg-snapshotting-on-self-cpu.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 17b6f586b8e27914b36c9ed7f3e4d289e6274a80 ]

We were picking %i7 out of the wrong register window
stack slot.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -320,7 +320,7 @@ static void __global_reg_self(struct thr
 
 		rw = (struct reg_window *)
 			(regs->u_regs[UREG_FP] + STACK_BIAS);
-		global_reg_snapshot[this_cpu].i7 = rw->ins[6];
+		global_reg_snapshot[this_cpu].i7 = rw->ins[7];
 	} else
 		global_reg_snapshot[this_cpu].i7 = 0;
 

-- 
