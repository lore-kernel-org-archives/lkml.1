Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZBHX6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZBHX6z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZBHX6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:58:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:12993 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZBHX6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:58:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LgNTxVR+zeeg26zrZ2rFnzlSrvDMlDrKcLqq3XN5vhkIPCtp4t7/erXJmybho20kev
         i+V9S941XYxygV/djMhUuwHJzozxUFWsrsnmUtI4D9nBYN6lsr80Z9Ig5aWdQjuI7m51
         lecb6k6EiZJfCy5uo9aqEj+fWEfy2drWUB4K4=
Date: Mon, 9 Feb 2009 00:58:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] power: fix a build breakage on latest -tip
Message-ID: <20090208235838.GA4729@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent conflict resolve (c2eefa20c3ab45ab2108ce7e6561364ea92d7334)
did put twice the function suspend_test() on kernel/power/main.c

The version added for CONFIG_PM_TEST_SUSPEND to solve the conflict overlaps
the one changed recently on (091d71e023557136e96f0e54f301497a3fc95dc3)
since PM_TEST_SUSPEND depends on SUSPEND.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 2ade836..2265b98 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -135,16 +135,6 @@ static int suspend_test(int level)
 
 #ifdef CONFIG_PM_TEST_SUSPEND
 
-static int suspend_test(int level)
-{
-	if (pm_test_level == level) {
-		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
-		mdelay(5000);
-		return 1;
-	}
-	return 0;
-}
-
 /*
  * We test the system suspend code by setting an RTC wakealarm a short
  * time in the future, then suspending.  Suspending the devices won't

