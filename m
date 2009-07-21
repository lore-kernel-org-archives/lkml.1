Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZGUCeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZGUCeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbZGUCet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:34:49 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48288 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZGUCes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:34:48 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, linux-laptop@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
       David Howells <dhowells@redhat.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jul 2009 08:02:27 +0530
Message-Id: <20090721023226.31855.67236.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH 05/06][RESEND] Fix compilation warning for arch/x86/kernel/apm_32.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following fix was initially inspired by David Howells fix few days back:
http://lkml.org/lkml/2009/7/9/109,

However, Ingo disapproves such fixes as it's dangerous - in something as
performance-uncritical. So, initialize 'err' to '0' to work around a GCC false 
positive warning:
http://lkml.org/lkml/2009/7/18/89,

Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>
---

--- a/arch/x86/kernel/apm_32.c	2009-06-15 07:50:51.000000000 +0530
+++ b/arch/x86/kernel/apm_32.c	2009-07-15 06:43:59.000000000 +0530
@@ -811,7 +811,7 @@ static int apm_do_idle(void)
 	u8 ret = 0;
 	int idled = 0;
 	int polling;
-	int err;
+	int err = 0;
 
 	polling = !!(current_thread_info()->status & TS_POLLING);
 	if (polling) {

---
Regards--
Subrata

