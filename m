Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZFZHry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZFZHry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZFZHrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:47:47 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:49415 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZFZHrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i5A+DX69LrSfaR64LPPf1ZP3OXZ7Xdeg2FticoFSiNpAtkaH5GbULaf6GNErXZABev
         PWzhnFvbFRggF1X0B8Nxpx8RERXp0VAznhy5wBN6PAzACQmM6p6GixTJPPUq8LThahhD
         xaZpTa157hWAvnsPf9nXJHA0OWeEinED4jaOY=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jcm@redhat.com, Wu Zhangjin <wuzj@lemote.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -rt] hwlat_detector: add dependence of RING_BUFFER
Date: Fri, 26 Jun 2009 15:47:26 +0800
Message-Id: <b9596d9e4b8ddcdb2e710873fb2086d3370ed9ff.1246002312.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <e1ad7dd41b964ad729595fc97ad8c4b26a119de4.1246002312.git.wuzj@lemote.com>
References: <e1ad7dd41b964ad729595fc97ad8c4b26a119de4.1246002312.git.wuzj@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

driver/misc/hwlat_detector.c needs the ring_buffer_* functions, which
are defined in kernel/trace/ring_buffer.c, so, hwlat_detector is
dependent on RING_BUFFER.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 drivers/misc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 174b99e..557cbb1 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -78,7 +78,7 @@ config IBM_ASM
 
 config HWLAT_DETECTOR
 	tristate "Testing module to detect hardware-induced latencies"
-	depends on DEBUG_FS
+	depends on DEBUG_FS && RING_BUFFER
 	default m
 	---help---
 	  A simple hardware latency detector. Use this module to detect
-- 
1.6.0.4

