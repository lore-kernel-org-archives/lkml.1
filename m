Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZKBK6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZKBK6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:58:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbZKBK6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:58:03 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:55180 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZKBK6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:58:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=MmTaaA2taw+qbI2P+4jNI0VJv+CumFqoKpGA9Ny+QxPnxa4Qt0rJdzkTXmbMYZ+6lA
         j7DNuTGURLorvKmlRGJgKmJaPaFNDp52k1wm2AEPs3T6NmtQN6ZqpjEpEyh6r8Q/jDgz
         QKkK9HtLL2cAD6aygImp5HFwywG+9A3GQ2q8M=
Message-ID: <4AEEBDD8.5080808@gmail.com>
Date: Mon, 02 Nov 2009 12:09:12 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Blackfin arch: ensure index is positive
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The indices are signed, it's not negative before we read an
array element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/blackfin/kernel/gptimers.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

Found by code analysis, is this required?

diff --git a/arch/blackfin/kernel/gptimers.c b/arch/blackfin/kernel/gptimers.c
index 7281a91..3b2a1c5 100644
--- a/arch/blackfin/kernel/gptimers.c
+++ b/arch/blackfin/kernel/gptimers.c
@@ -139,7 +139,7 @@ static uint32_t const timil_mask[MAX_BLACKFIN_GPTIMERS] =
 
 void set_gptimer_pwidth(int timer_id, uint32_t value)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	timer_regs[timer_id]->width = value;
 	SSYNC();
 }
@@ -147,14 +147,14 @@ EXPORT_SYMBOL(set_gptimer_pwidth);
 
 uint32_t get_gptimer_pwidth(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	return timer_regs[timer_id]->width;
 }
 EXPORT_SYMBOL(get_gptimer_pwidth);
 
 void set_gptimer_period(int timer_id, uint32_t period)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	timer_regs[timer_id]->period = period;
 	SSYNC();
 }
@@ -162,28 +162,28 @@ EXPORT_SYMBOL(set_gptimer_period);
 
 uint32_t get_gptimer_period(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	return timer_regs[timer_id]->period;
 }
 EXPORT_SYMBOL(get_gptimer_period);
 
 uint32_t get_gptimer_count(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	return timer_regs[timer_id]->counter;
 }
 EXPORT_SYMBOL(get_gptimer_count);
 
 uint32_t get_gptimer_status(int group)
 {
-	tassert(group < BFIN_TIMER_NUM_GROUP);
+	tassert(group < BFIN_TIMER_NUM_GROUP && group >= 0);
 	return group_regs[group]->status;
 }
 EXPORT_SYMBOL(get_gptimer_status);
 
 void set_gptimer_status(int group, uint32_t value)
 {
-	tassert(group < BFIN_TIMER_NUM_GROUP);
+	tassert(group < BFIN_TIMER_NUM_GROUP && group >= 0);
 	group_regs[group]->status = value;
 	SSYNC();
 }
@@ -191,42 +191,42 @@ EXPORT_SYMBOL(set_gptimer_status);
 
 int get_gptimer_intr(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	return !!(group_regs[BFIN_TIMER_OCTET(timer_id)]->status & timil_mask[timer_id]);
 }
 EXPORT_SYMBOL(get_gptimer_intr);
 
 void clear_gptimer_intr(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	group_regs[BFIN_TIMER_OCTET(timer_id)]->status = timil_mask[timer_id];
 }
 EXPORT_SYMBOL(clear_gptimer_intr);
 
 int get_gptimer_over(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	return !!(group_regs[BFIN_TIMER_OCTET(timer_id)]->status & tovf_mask[timer_id]);
 }
 EXPORT_SYMBOL(get_gptimer_over);
 
 void clear_gptimer_over(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	group_regs[BFIN_TIMER_OCTET(timer_id)]->status = tovf_mask[timer_id];
 }
 EXPORT_SYMBOL(clear_gptimer_over);
 
 int get_gptimer_run(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	return !!(group_regs[BFIN_TIMER_OCTET(timer_id)]->status & trun_mask[timer_id]);
 }
 EXPORT_SYMBOL(get_gptimer_run);
 
 void set_gptimer_config(int timer_id, uint16_t config)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	timer_regs[timer_id]->config = config;
 	SSYNC();
 }
@@ -234,7 +234,7 @@ EXPORT_SYMBOL(set_gptimer_config);
 
 uint16_t get_gptimer_config(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	return timer_regs[timer_id]->config;
 }
 EXPORT_SYMBOL(get_gptimer_config);
@@ -282,7 +282,7 @@ EXPORT_SYMBOL(disable_gptimers_sync);
 
 void set_gptimer_pulse_hi(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	timer_regs[timer_id]->config |= TIMER_PULSE_HI;
 	SSYNC();
 }
@@ -290,7 +290,7 @@ EXPORT_SYMBOL(set_gptimer_pulse_hi);
 
 void clear_gptimer_pulse_hi(int timer_id)
 {
-	tassert(timer_id < MAX_BLACKFIN_GPTIMERS);
+	tassert(timer_id < MAX_BLACKFIN_GPTIMERS && timer_id >= 0);
 	timer_regs[timer_id]->config &= ~TIMER_PULSE_HI;
 	SSYNC();
 }
