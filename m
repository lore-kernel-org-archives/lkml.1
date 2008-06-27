Return-Path: <linux-kernel-owner+w=401wt.eu-S1764204AbYF0VhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764204AbYF0VhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbYF0Vgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:36:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763929AbYF0Vgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:36:52 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: [PATCH 03/39] use rdtscll in read_current_timer for i386.
Date: Fri, 27 Jun 2008 18:34:10 -0300
Message-Id: <1214602486-17080-4-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1214602486-17080-3-git-send-email-gcosta@redhat.com>
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com>
 <1214602486-17080-2-git-send-email-gcosta@redhat.com>
 <1214602486-17080-3-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we achieve the same code for both arches.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/lib/delay_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/delay_32.c b/arch/x86/lib/delay_32.c
index 54013f8..bf6de05 100644
--- a/arch/x86/lib/delay_32.c
+++ b/arch/x86/lib/delay_32.c
@@ -98,7 +98,7 @@ void use_tsc_delay(void)
 int __devinit read_current_timer(unsigned long *timer_val)
 {
 	if (delay_fn == delay_tsc) {
-		rdtscl(*timer_val);
+		rdtscll(*timer_val);
 		return 0;
 	}
 	return -1;
-- 
1.5.5.1

