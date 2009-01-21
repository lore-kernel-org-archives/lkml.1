Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbZAUKnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbZAUKnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759385AbZAUKnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:43:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759084AbZAUKnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:43:24 -0500
Date: Wed, 21 Jan 2009 11:43:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, brgerst@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHSET linux-2.6-x86:core/percpu] x86: misc clean up and
	unify x86_32/64 code paths
Message-ID: <20090121104311.GA15947@elte.hu>
References: <1232527578-1960-1-git-send-email-tj@kernel.org> <20090121092633.GA22506@elte.hu> <20090121093509.GA31613@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121093509.GA31613@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


This one was needed as well.

	Ingo

------------------->
>From 61e0178cf01b4acc914e9653b421e925f22be0cd Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 21 Jan 2009 11:30:07 +0100
Subject: [PATCH] x86: uv cleanup, build fix #2

Fix more build-failure fallout from the UV cleanup - the UV drivers
were not updated to include <asm/uv/uv.h>.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/misc/sgi-gru/grufile.c |    1 +
 drivers/misc/sgi-xp/xp_main.c  |    2 ++
 drivers/misc/sgi-xp/xp_uv.c    |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/sgi-gru/grufile.c b/drivers/misc/sgi-gru/grufile.c
index 6509838..50f6357 100644
--- a/drivers/misc/sgi-gru/grufile.c
+++ b/drivers/misc/sgi-gru/grufile.c
@@ -53,6 +53,7 @@
 #define IS_UV()		0
 #endif
 
+#include <asm/uv/uv.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_mmrs.h>
 
diff --git a/drivers/misc/sgi-xp/xp_main.c b/drivers/misc/sgi-xp/xp_main.c
index 16f8dca..1a553e6 100644
--- a/drivers/misc/sgi-xp/xp_main.c
+++ b/drivers/misc/sgi-xp/xp_main.c
@@ -18,6 +18,8 @@
 #include <linux/device.h>
 #include "xp.h"
 
+#include <asm/uv/uv.h>
+
 /* define the XP debug device structures to be used with dev_dbg() et al */
 
 struct device_driver xp_dbg_name = {
diff --git a/drivers/misc/sgi-xp/xp_uv.c b/drivers/misc/sgi-xp/xp_uv.c
index d238576..c55cc8a 100644
--- a/drivers/misc/sgi-xp/xp_uv.c
+++ b/drivers/misc/sgi-xp/xp_uv.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/device.h>
+#include <asm/uv/uv.h>
 #include <asm/uv/uv_hub.h>
 #if defined CONFIG_X86_64
 #include <asm/uv/bios.h>
