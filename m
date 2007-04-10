Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXDJMWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXDJMWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 08:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965153AbXDJMWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 08:22:05 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:32539 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965105AbXDJMWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 08:22:02 -0400
Date: Tue, 10 Apr 2007 14:24:21 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: 2.6.21-rc6-mm1
Message-ID: <20070410142421.519eb62c@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Apr 2007 14:35:59 -0700,
Andrew Morton <akpm@linux-foundation.org> wrote:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/

> +kprobes-the-on-off-knob-thru-debugfs-updated.patch
> +kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
> 
>  kprobes work

Add the missing arch_trampoline_kprobe() for s390.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 arch/s390/kernel/kprobes.c |    7 +++++++
 1 files changed, 7 insertions(+)

--- linux-2.6.21-rc6-mm1.orig/arch/s390/kernel/kprobes.c
+++ linux-2.6.21-rc6-mm1/arch/s390/kernel/kprobes.c
@@ -662,3 +662,10 @@ int __init arch_init_kprobes(void)
 {
 	return register_kprobe(&trampoline_p);
 }
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *) & kretprobe_trampoline)
+		return 1;
+	return 0;
+}
