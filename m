Return-Path: <linux-kernel-owner+w=401wt.eu-S1758490AbYLKTV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490AbYLKTV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbYLKTSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:16 -0500
Received: from kroah.org ([198.145.64.141]:55872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756699AbYLKTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:04 -0500
Date: Thu, 11 Dec 2008 11:13:55 -0800
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
       alan@lxorguk.ukuu.org.uk, "Hong H. Pham" <hong.pham@windriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/83] sparc64: Sync FPU state in VIS emulation handler.
Message-ID: <20081211191355.GL5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0006-sparc64-Sync-FPU-state-in-VIS-emulation-handler.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hong H. Pham <hong.pham@windriver.com>

[ Upstream commit 410d2c8187ed969238ba98008c1d57307a56cfd8 ]

Copy the FPU state to the task's thread_info->fpregs for the VIS emulation
functions to access.

Signed-off-by: Hong H. Pham <hong.pham@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/visemul.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/sparc64/kernel/visemul.c
+++ b/arch/sparc64/kernel/visemul.c
@@ -807,6 +807,8 @@ int vis_emul(struct pt_regs *regs, unsig
 	if (get_user(insn, (u32 __user *) pc))
 		return -EFAULT;
 
+	save_and_clear_fpu();
+
 	opf = (insn & VIS_OPF_MASK) >> VIS_OPF_SHIFT;
 	switch (opf) {
 	default:

