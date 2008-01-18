Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYARAg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYARAg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 19:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbYARAfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 19:35:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759080AbYARAfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 19:35:51 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org
Subject: [PATCH 0/7] More lguest massage.
Date: Thu, 17 Jan 2008 22:35:45 -0200
Message-Id: <1200616561270-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12006165571406-git-send-email-gcosta@redhat.com>
References: <1200616550283-git-send-email-gcosta@redhat.com> <12006165571406-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inour model, a guest does not run in a cpu anymore: a virtual cpu
does.So we change last_guest to last_cpu

Signed-off-by:Glauber de Oliveira Costa <gcosta@redhat.com>
---
drivers/lguest/x86/core.c |    6 +++---
1 files changed, 3 insertions(+), 3 deletions(-)

diff--git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index2859447..25f48fd 100644
---a/drivers/lguest/x86/core.c
+++b/drivers/lguest/x86/core.c
@@-60,7 +60,7 @@ static struct lguest_pages *lguest_pages(unsigned int cpu)
		  (SWITCHER_ADDR + SHARED_SWITCHER_PAGES*PAGE_SIZE))[cpu]);
}

-staticDEFINE_PER_CPU(struct lguest *, last_guest);
+staticDEFINE_PER_CPU(struct lg_cpu *, last_cpu);

/*S:010
 * We approach the Switcher.
@@-80,8 +80,8 @@ static void copy_in_guest_info(struct lg_cpu *cpu, struct lguest_pages *pages)
	 * same Guest we ran last time (and that Guest hasn't run anywhere else
	 * meanwhile).  If that's not the case, we pretend everything in the
	 * Guest has changed. */
-	if(__get_cpu_var(last_guest) != lg || lg->last_pages != pages) {
-		__get_cpu_var(last_guest)= lg;
+	if(__get_cpu_var(last_cpu) != cpu || lg->last_pages != pages) {
+		__get_cpu_var(last_cpu)= cpu;
		lg->last_pages = pages;
		lg->changed = CHANGED_ALL;
	}
--
1.5.0.6

