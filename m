Return-Path: <linux-kernel-owner+w=401wt.eu-S1758470AbYJGAsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470AbYJGAsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbYJGAna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:30 -0400
Received: from ns.suse.de ([195.135.220.2]:46731 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274AbYJGAn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:29 -0400
Date: Mon, 6 Oct 2008 17:38:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@redhat.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [patch 21/71] x86: Fix broken LDT access in VMI
Message-ID: <20081007003821.GV3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-broken-ldt-access-in-vmi.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Zachary Amsden <zach@vmware.com>

commit de59985e3a623d4d5d6207f1777398ca0606ab1c upstream

After investigating a JRE failure, I found this bug was introduced a
long time ago, and had already managed to survive another bugfix which
occurred on the same line.  The result is a total failure of the JRE due
to LDT selectors not working properly.

This one took a long time to rear up because LDT usage is not very
common, but the bug is quite serious.  It got introduced along with
another bug, already fixed, by 75b8bb3e56ca09a467fbbe5229bc68627f7445be

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/vmi_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -234,7 +234,7 @@ static void vmi_write_ldt_entry(struct d
 				const void *desc)
 {
 	u32 *ldt_entry = (u32 *)desc;
-	vmi_ops.write_idt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
+	vmi_ops.write_ldt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
 }
 
 static void vmi_load_sp0(struct tss_struct *tss,

-- 
