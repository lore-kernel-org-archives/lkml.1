Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759176AbYLPWDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbYLPWDx (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:03:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYLPWDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:03:38 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:55721 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466AbYLPWDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:03:37 -0500
Message-ID: <494825B8.5090006@ct.jp.nec.com>
Date: Tue, 16 Dec 2008 14:03:36 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: ia32_signal: use __put_user() instead of __copy_to_user()
References: <49482568.3020108@ct.jp.nec.com>
In-Reply-To: <49482568.3020108@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

__put_user() can be used for constant size 8, like arch/x86/kernel/signal.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 9ddf2fa..8738cc5 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -467,7 +467,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 	 * These are actually not used anymore, but left because some
 	 * gdb versions depend on them as a marker.
 	 */
-	err |= __copy_to_user(frame->retcode, &code, 8);
+	err |= __put_user(*((u64 *)&code), (u64 *)frame->retcode);
 	if (err)
 		return -EFAULT;
 
@@ -554,7 +554,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	 * Not actually used anymore, but left because some gdb
 	 * versions need it.
 	 */
-	err |= __copy_to_user(frame->retcode, &code, 8);
+	err |= __put_user(*((u64 *)&code), (u64 *)frame->retcode);
 	if (err)
 		return -EFAULT;
 
-- 
1.6.0.4

