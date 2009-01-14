Return-Path: <linux-kernel-owner+w=401wt.eu-S1761957AbZANMZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761957AbZANMZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZANMY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:24:58 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:52606 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZANMY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:24:57 -0500
Message-Id: <496DE7CD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 14 Jan 2009 12:25:33 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] conditionalize call from panic() to smp_send_stop()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... avoiding nested warnings and/or oopses as much as possible (namely
durin early boot).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 kernel/panic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.29-rc1/kernel/panic.c	2009-01-14 11:36:29.000000000 +0100
+++ 2.6.29-rc1-panic-conditional-stop/kernel/panic.c	2009-01-06 17:02:49.000000000 +0100
@@ -89,7 +89,8 @@ NORET_TYPE void panic(const char * fmt, 
 	 * unfortunately means it may not be hardened to work in a panic
 	 * situation.
 	 */
-	smp_send_stop();
+	if (num_online_cpus() > 1)
+		smp_send_stop();
 #endif
 
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);



