Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZDVTF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZDVTF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZDVTFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:05:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:54018 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbZDVTFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:05:06 -0400
Message-ID: <49EF6A7B.8070202@suse.de>
Date: Thu, 23 Apr 2009 03:05:31 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michal Simek <monstr@monstr.eu>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/7] microblaze: add parameter to microblaze_read()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies parameter of microblaze_read() from 'void' to 'struct
clocksource *cs', which fixes compile warning for incompatible parameter type.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/microblaze/kernel/timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index 05a497e..bdfa2f9 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -176,7 +176,7 @@ static __init void microblaze_clockevent_init(void)
 	clockevents_register_device(&clockevent_microblaze_timer);
 }

-static cycle_t microblaze_read(void)
+static cycle_t microblaze_read(struct clocksource *cs)
 {
 	/* reading actual value of timer 1 */
 	return (cycle_t) (in_be32(TIMER_BASE + TCR1));

-- 
Coly Li
SuSE Labs



