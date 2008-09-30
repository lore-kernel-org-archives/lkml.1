Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYI3SGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYI3SGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 14:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYI3SGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 14:06:01 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34992 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbYI3SGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 14:06:00 -0400
Subject: [PATCH] x86, Fix broken LDT access in VMI
From: Zachary Amsden <zach@vmware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Content-Type: multipart/mixed; boundary="=-Gfxsqg7PAw78oZqAYOXx"
Date: Tue, 30 Sep 2008 11:02:12 -0700
Message-Id: <1222797732.7330.35.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Gfxsqg7PAw78oZqAYOXx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This one took a long time to rear up because LDT usage is not very
common, but the bug is quite serious.  It got introduced along with
another bug, already fixed, by 75b8bb3e56ca09a467fbbe5229bc68627f7445be 

Please apply.  Fix should also be headed for stable tree and backported,
it is really sadly trivial.  Glauber, Ingo, sorry for the offlist
posting, somehow the original missed LKML.

Zach

--=-Gfxsqg7PAw78oZqAYOXx
Content-Disposition: attachment; filename=vmi-ldt-fix.patch
Content-Type: text/x-patch; name=vmi-ldt-fix.patch; charset=us-ascii
Content-Transfer-Encoding: 7bit

After investigating a JRE failure, I found this bug was introduced a long time
ago, and had already managed to survive another bugfix which occurred on the
same line.  The result is a total failure of the JRE due to LDT selectors not
working properly.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 040a95e..411e34f 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -234,7 +234,7 @@ static void vmi_write_ldt_entry(struct desc_struct *dt, int entry,
 				const void *desc)
 {
 	u32 *ldt_entry = (u32 *)desc;
-	vmi_ops.write_idt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
+	vmi_ops.write_ldt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
 }
 
 static void vmi_load_sp0(struct tss_struct *tss,

--=-Gfxsqg7PAw78oZqAYOXx--

