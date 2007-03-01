Return-Path: <linux-kernel-owner+w=401wt.eu-S965114AbXCAOcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965114AbXCAOcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965133AbXCAOcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:32:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:42603 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965114AbXCAOcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:32:23 -0500
Cc: akpm@linux-foundation.org, linux-dvb@linuxtv.org, domi.dumont@free.fr,
       Jiri Slaby <jirislaby@gmail.com>, bunk@stusta.de,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>,
       venkatesh.pallipadi@intel.com
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 01 Mar 2007 15:32:22 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070301143222.263070@gmx.net>
MIME-Version: 1.0
Subject: patch 3 / 3: fix floppy mount bug in kernel 2.6.21-rc1
To: torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/JdYkwzfzJ8cLYeE2CZOgcmUty/XpWQdGdEL9jzi
 npYaz3iOJywIpg9lTIlACIF1w= 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,
this patch fixes the floppy mount bug (i. e. regression) in kernel 2.6.21-rc1. It was inspired by Stephane Eranian. It was tested on an Intel P4 1800 MHz
(Intel ICH4 chipset) and on an AMD Athlon XP 1800 MHz (Silicon Integrated Systems chipset 740, 5513).
My deep thanks and respect go to:
Stephane Eranian, Linus Torvalds, Jiri Slaby. You are truthfully real men and reliable, accurate, fine chaps. It feels great to have you in this world-wide community!
Would you still call the whole i386 architecture "a small number of machines", Mister Andrew Morton? If yes, in how far please?

Signed-off-by: Uwe Bugla <uwe.bugla@gmx.de>

--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -154,6 +154,7 @@
 		current_thread_info()->status |= TS_POLLING;
 	} else {
 		/* loop is done by the caller */
+		local_irq_enable();
 		cpu_relax();
 	}
 }

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: www.gmx.net/de/go/mailfooter/topmail-out
