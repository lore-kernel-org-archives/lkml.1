Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbYCKAHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbYCKAHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYCKAHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:07:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbYCKAHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:07:20 -0400
Message-ID: <47D5CD18.4080400@redhat.com>
Date: Mon, 10 Mar 2008 20:06:48 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, ia64 <linux-ia64@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [PATCH -mm] kprobes: fix prepare_booster to get correct slot
References: <47D166E7.2050803@redhat.com> <1205120600.20271.3.camel@sli10-desk.sh.intel.com> <47D57D28.7070100@redhat.com>
In-Reply-To: <47D57D28.7070100@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to get correct slot number from probing address
in prepare_booster.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---
Andrew, this is a bugfix of
kprobes-kprobe-booster-for-ia64.patch

 arch/ia64/kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.25-rc3-mm1/arch/ia64/kernel/kprobes.c
===================================================================
--- 2.6.25-rc3-mm1.orig/arch/ia64/kernel/kprobes.c
+++ 2.6.25-rc3-mm1/arch/ia64/kernel/kprobes.c
@@ -565,7 +565,7 @@ static int __kprobes can_boost(bundle_t
 static void __kprobes prepare_booster(struct kprobe *p)
 {
 	unsigned long addr = (unsigned long)p->addr & ~0xFULL;
-	unsigned int slot = addr & 0xf;
+	unsigned int slot = (unsigned long)p->addr & 0xf;
 	struct kprobe *other_kp;

 	if (can_boost(&p->ainsn.insn[0].bundle, slot, addr)) {
