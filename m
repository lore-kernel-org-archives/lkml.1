Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYG0L1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYG0L1V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 07:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYG0L1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 07:27:14 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45178 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYG0L1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 07:27:13 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Fix SCHED_HRTICK dependency
Date: Sun, 27 Jul 2008 20:27:06 +0900
Message-ID: <87wsj71sad.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently, it seems SCHED_HRTICK allowed for !SMP. But, it seems to have
no dependency of it. So how about the following?

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 kernel/Kconfig.hz |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/Kconfig.hz~sched_hrtick-dep-fix kernel/Kconfig.hz
--- linux-2.6/kernel/Kconfig.hz~sched_hrtick-dep-fix	2008-07-26 00:23:26.000000000 +0900
+++ linux-2.6-hirofumi/kernel/Kconfig.hz	2008-07-26 00:25:12.000000000 +0900
@@ -55,4 +55,4 @@ config HZ
 	default 1000 if HZ_1000
 
 config SCHED_HRTICK
-	def_bool HIGH_RES_TIMERS && USE_GENERIC_SMP_HELPERS
+	def_bool HIGH_RES_TIMERS && (!SMP || USE_GENERIC_SMP_HELPERS)
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
