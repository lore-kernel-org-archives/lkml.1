Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbXKHC5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbXKHC5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXKHC5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:57:33 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:53568 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbXKHC5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:57:32 -0500
Message-Id: <200711080257.lA82vQfA015942@www262.sakura.ne.jp>
Subject: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Nov 2007 11:57:26 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Original patch assumed args->nlen < CTL_MAXNAME, but it can be false.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>


--- linux-2.6.22-rc2.orig/kernel/sysctl.c	2007-11-08 10:38:17.000000000 +0900
+++ linux-2.6.22-rc2/kernel/sysctl.c	2007-11-08 11:24:27.000000000 +0900
@@ -2609,6 +2609,10 @@ static int deprecated_sysctl_warning(str
 	int name[CTL_MAXNAME];
 	int i;
 
+	/* Check args->nlen. */
+	if (args->nlen > CTL_MAXNAME)
+		return -EFAULT;
+
 	/* Read in the sysctl name for better debug message logging */
 	for (i = 0; i < args->nlen; i++)
 		if (get_user(name[i], args->name + i))
