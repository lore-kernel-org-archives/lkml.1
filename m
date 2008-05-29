Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYE2PQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYE2PQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYE2PQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:16:15 -0400
Received: from smtp.movial.fi ([62.236.91.34]:35033 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbYE2PQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:16:14 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] [MIPS] The tickcount per-cpu variable can become static
Date: Thu, 29 May 2008 17:57:12 +0300
Message-Id: <12120730321843-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.4.4.3
In-Reply-To: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
References: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In arch/mips/mips-boards/generic/time.c, the `tickcount' per-cpu
variable is needlessly defined global, and this patch makes it
static.

Noticed by sparse. Tested by booting a Qemu-emulated Malta board
up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 arch/mips/mips-boards/generic/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mips-boards/generic/time.c b/arch/mips/mips-boards/generic/time.c
index 008fd82..585fb44 100644
--- a/arch/mips/mips-boards/generic/time.c
+++ b/arch/mips/mips-boards/generic/time.c
@@ -58,7 +58,7 @@ static int mips_cpu_timer_irq;
 static int mips_cpu_perf_irq;
 extern int cp0_perfcount_irq;
 
-DEFINE_PER_CPU(unsigned int, tickcount);
+static DEFINE_PER_CPU(unsigned int, tickcount);
 #define tickcount_this_cpu __get_cpu_var(tickcount)
 static unsigned long ledbitmask;
 
-- 
1.4.4.3

