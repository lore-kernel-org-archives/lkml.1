Return-Path: <linux-kernel-owner+w=401wt.eu-S1759837AbYBAUco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837AbYBAUco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 15:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbYBAUcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 15:32:36 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:47545 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbYBAUcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 15:32:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=SbaUR1R+lbaVrUJKCnxUipWeApsVvpNu+vtkFnHFd95jkCvLhlRULT5bAy+zWn1ShSTyyCycOuRGWj0wWrZkPRZwbeYBD/5+UvRJKW+jE+cQPzIq7N/cJjjxZdwI4DJ8JPKgk/KvzBY3A0jEDPYIae7nW50zb62HDodY6yj4s/8=
Date: Fri, 1 Feb 2008 21:31:51 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: fix cpu info in dmesg
Message-ID: <20080201203142.GA6305@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure whether it's the right fix, but it doesn't make sense to call
print_cpu_info without leading printk...
---
fix print_cpu_info, because it produced on boot:
CPU: <6>AMD Athlon(tm) 64 Processor 3200+ stepping 00
instead of
CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 00

(broken since 04e1ba852132c9ad006affcd5b8c8606295170b0 -
 x86: cleanup kernel/setup_64.c)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 77fb87b..f3b30b9 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1039,7 +1039,7 @@ __setup("noclflush", setup_noclflush);
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
 	if (c->x86_model_id[0])
-		printk(KERN_INFO "%s", c->x86_model_id);
+		printk(KERN_CONT "%s", c->x86_model_id);
 
 	if (c->x86_mask || c->cpuid_level >= 0)
 		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
-- 
1.5.3.7

