Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbYAWRl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbYAWRl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbYAWRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:39:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093AbYAWRjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:39:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=AE5xc1B++MeH1HIC9uGiva+umno6C+CSbQM48+YBVWY6MfGnAxDBoZKTRk6jr6P+weun1DEWwPvJTYa+tJL7FM/yULy/vtyckCZXmsPZOsr53c6pJyXsmmbqCEEB15TxA+2i97A4meWi44vI1ty7+AF5QWKFEeRjg5zPx1SZQZ0=
Date: Wed, 23 Jan 2008 20:39:12 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/6] PPC: use KSYM_NAME_LEN
Message-ID: <20080123173912.GE12877@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use KSYM_NAME_LEN instead of numeric value

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/ppc/xmon/xmon.c
===================================================================
--- linux-2.6.git.orig/arch/ppc/xmon/xmon.c	2008-01-21 19:35:06.000000000 +0300
+++ linux-2.6.git/arch/ppc/xmon/xmon.c	2008-01-23 19:15:19.000000000 +0300
@@ -180,7 +180,7 @@ static void xmon_print_symbol(unsigned l
 	char *modname;
 	const char *name = NULL;
 	unsigned long offset, size;
-	static char tmpstr[128];
+	static char tmpstr[KSYM_NAME_LEN];
 
 	printf("%.8lx", address);
 	if (setjmp(bus_error_jmp) == 0) {
