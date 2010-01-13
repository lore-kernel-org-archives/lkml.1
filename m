Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344Ab0AMKQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0AMKQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:16:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755301Ab0AMKQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:16:14 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49265 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab0AMKQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:16:13 -0500
X-IronPort-AV: E=Sophos;i="4.49,267,1262581200"; 
   d="scan'208";a="79804926"
From: Ian Campbell <ian.campbell@citrix.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Christian Kujau <lists@nerdbynature.de>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH] x86: kernel_thread -- initialize SS to a known state
Date: Wed, 13 Jan 2010 10:16:07 +0000
Message-Id: <1263377768-19600-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1263377706.16526.12062.camel@zakaz.uk.xensource.com>
References: <1263377706.16526.12062.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 13 Jan 2010 10:16:12.0710 (UTC) FILETIME=[6ED6D460:01CA9439]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

Before the kernel_thread was converted into "C" we had
pt_regs::ss set to __KERNEL_DS (by SAVE_ALL asm macro).

Though I must admit I didn't find any *explicit* load of
%ss from this structure the better to be on a safe side
and set it to a known value.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/kernel/process.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c6ee241..02c3ee0 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -288,6 +288,8 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.es = __USER_DS;
 	regs.fs = __KERNEL_PERCPU;
 	regs.gs = __KERNEL_STACK_CANARY;
+#else
+	regs.ss = __KERNEL_DS;
 #endif
 
 	regs.orig_ax = -1;
-- 
1.5.6.5

