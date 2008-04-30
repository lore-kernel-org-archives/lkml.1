Return-Path: <linux-kernel-owner+w=401wt.eu-S934001AbYD3VBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbYD3VBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933684AbYD3VAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:00:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157AbYD3VAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:00:41 -0400
Date: Wed, 30 Apr 2008 23:00:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: [patch] acpi: fix drivers/acpi/glue.c build error
Message-ID: <20080430210026.GA24121@elte.hu>
References: <200804301420.11696.lenb@kernel.org> <20080430205615.GA23694@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430205615.GA23694@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> This batch is a proper super-set of the pull request I made a week 
> ago. It will update the files shown below.

another build bug triggered - fixed below.

	Ingo

------------------->
Subject: acpi: fix drivers/acpi/glue.c build error
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 30 22:56:57 CEST 2008

x86.git testing found the following build bug:

  drivers/built-in.o: In function `acpi_rtc_init':
  glue.c:(.init.text+0x16c3): undefined reference to `pnp_bus_type'

this tries to use PNP bus infrastructure even in the !PNP case.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/acpi/glue.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/acpi/glue.c
===================================================================
--- linux.orig/drivers/acpi/glue.c
+++ linux/drivers/acpi/glue.c
@@ -299,6 +299,7 @@ static void rtc_wake_off(struct device *
 
 static struct cmos_rtc_board_info rtc_info;
 
+#ifdef CONFIG_PNP
 
 /* PNP devices are registered in a subsys_initcall();
  * ACPI specifies the PNP IDs to use.
@@ -360,4 +361,6 @@ static int __init acpi_rtc_init(void)
 /* do this between RTC subsys_initcall() and rtc_cmos driver_initcall() */
 fs_initcall(acpi_rtc_init);
 
+#endif /* CONFIG_PNP */
+
 #endif
