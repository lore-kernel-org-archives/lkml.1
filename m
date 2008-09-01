Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYIAXja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYIAXja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYIAXif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:38:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:52971 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYIAXie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:38:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P0R0twsEzBOfDgqqSij3xog3LInIyA0EZkuqdhSgHp2I6qSKfK1b4EHdvJXDSS1h8H
         QaPqXpcearVn92VuK4zRQzQYyrDrKNwWS2+8ji5tB/4jVjRCkkNxE1q1KwhcxJx53pOS
         Ece38lwSHdVPoJjkyS57vXE0i4cdMDbt79uDY=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 4/6] x86: delay early cpu initialization until cpuid is done
Date: Mon,  1 Sep 2008 16:37:24 -0700
Message-Id: <1220312246-30879-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Move early cpu initialization after cpu
early get cap so the early cpu initialization
can fix up cpu caps.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d3bc82f..f970cbf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -335,11 +335,11 @@ static void __init early_cpu_detect(void)
 
 	get_cpu_vendor(c, 1);
 
+	early_get_cap(c);
+
 	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
 	    cpu_devs[c->x86_vendor]->c_early_init)
 		cpu_devs[c->x86_vendor]->c_early_init(c);
-
-	early_get_cap(c);
 }
 
 /*
