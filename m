Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYKZTSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYKZTSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYKZTRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:17:15 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:27104 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYKZTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:17:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T4EkBb6OZKug2plGhRLac6tWa+/NZfDp9btabeTiZbc2xh3DsChcmPqvpog7iBk+es
         5bqW7SqycIK6PVwm3veQ7usUR5XoIKCJvz7o0ashnQO8IJTzzBVRAR3bAeQmHQu2CXqt
         V/QojMqtpEt5H1Do5vi7a9ksh8LDeHZ/zl5+4=
From: gorcunov@gmail.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, heukelum@fastmail.fm,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 4/5] x86: ret_from_fork - add CFI proc annotation
Date: Wed, 26 Nov 2008 22:17:03 +0300
Message-Id: <39e35cbc79237b162a0720dceaa52a72c7eb1690.1227725632.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.4.603.gbc9c0
In-Reply-To: <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com>
References: <1227727024-2281-1-git-send-email-gorcunov@gmail.com>
 <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
 <cc7949234e3ac0ddb402764be5ed620035f964a6.1227725632.git.gorcunov@gmail.com>
 <6bc2fd402754cfa5b69a63a529bc065584c5f375.1227725632.git.gorcunov@gmail.com>
In-Reply-To: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
References: <82259867e200855889261370c29bbd15a111d7fb.1227725632.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

ret_from_fork is definitly procedure so mark it as that.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/entry_64.S |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c409f73..a21be86 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -370,6 +370,7 @@ END(save_paranoid)
  */
 /* rdi:	prev */
 ENTRY(ret_from_fork)
+	CFI_STARTPROC
 	DEFAULT_FRAME
 	push kernel_eflags(%rip)
 	CFI_ADJUST_CFA_OFFSET 8
-- 
1.6.0.4.603.gbc9c0

