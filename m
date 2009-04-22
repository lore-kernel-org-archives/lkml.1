Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZDVTEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZDVTEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZDVTEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:04:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZDVTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:04:22 -0400
Message-ID: <49EF6A4D.3030606@suse.de>
Date: Thu, 23 Apr 2009 03:04:45 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Eric Miao <eric.miao@marvell.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/7] mach-mmp: add parameter to clksrc_read()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the patch to add parameter to uv_read_rtc(), I did a grep and found
several similar issues.

This patch modifies parameter of clksrc_read() from 'void' to 'struct
clocksource *cs', which fixes compile warning for incompatible parameter type.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/mach-mmp/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index b03a6ed..a8400bb 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -136,7 +136,7 @@ static struct clock_event_device ckevt = {
 	.set_mode	= timer_set_mode,
 };

-static cycle_t clksrc_read(void)
+static cycle_t clksrc_read(struct clocksource *cs)
 {
 	return timer_read();
 }

-- 
Coly Li
SuSE Labs



