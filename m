Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbYI1Qt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbYI1Qt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 12:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYI1Qtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 12:49:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:48551 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYI1Qtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 12:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=t0I5aX52r/I5IeJDbXBi5679X9GbghD5FG5FDn08hZ4XSzhY/V4zUa01c3UH4Kw8zP
         VaudtDNxijzWaslM9chQoHlu876Q515Xs1Onf4oMHk82V1ILWCdS2ZJirVXtj6UJ9fnW
         Ddh7vGh2mW+5zf2NIxINJ992LkT132XlqXuSU=
Date: Sun, 28 Sep 2008 18:49:46 +0200
From: dcg <diegocg@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: be less annoying on boot
Message-ID: <20080928184946.47bb63d9@diego-desktop>
In-Reply-To: <20080927191824.GC18619@elte.hu>
References: <20080924183517.GA24209@nostromo.devel.redhat.com>
 <20080925091558.GE16734@elte.hu>
 <20080925161300.GA17162@nostromo.devel.redhat.com>
 <20080927185027.GB17867@elte.hu>
 <20080927211131.2e0b60f0@diego-desktop>
 <20080927191824.GC18619@elte.hu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 27 Sep 2008 21:18:24 +0200, Ingo Molnar <mingo@elte.hu> escribió:

> could you please send a patch that only calls that early_printk() if 
> console_loglevel == 10? (i.e. if "debug" has been passed)


Sure, here it is.



Honour "quiet" boot parameter in early_printk() calls


Signed-off-by: Diego Calleja <diegocg@gmail.com>
---
 arch/x86/kernel/head64.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: 2.6/arch/x86/kernel/head64.c
===================================================================
--- 2.6.orig/arch/x86/kernel/head64.c	2008-09-27 22:54:41.000000000 +0200
+++ 2.6/arch/x86/kernel/head64.c	2008-09-27 23:14:02.000000000 +0200
@@ -108,11 +108,13 @@
 	}
 	load_idt((const struct desc_ptr *)&idt_descr);
 
-	early_printk("Kernel alive\n");
+	if (console_loglevel == 10)
+		early_printk("Kernel alive\n");
 
 	x86_64_init_pda();
 
-	early_printk("Kernel really alive\n");
+	if (console_loglevel == 10)
+		early_printk("Kernel really alive\n");
 
 	x86_64_start_reservations(real_mode_data);
 }


