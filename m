Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbZFLUr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbZFLUr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 16:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZFLUrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 16:47:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54650 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbZFLUrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 16:47:48 -0400
Date: Fri, 12 Jun 2009 22:47:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: HTC Dream compile fixes (was Re: HTC Dream aka. t-mobile g1
	support)
Message-ID: <20090612204744.GA18544@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612150504.GA15084@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix compilation of pwrsink with CONFIG_WAKELOCK disabled.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-msm/htc_pwrsink.c b/arch/arm/mach-msm/htc_pwrsink.c
index 3105a7c..3d3c55c 100644
--- a/arch/arm/mach-msm/htc_pwrsink.c
+++ b/arch/arm/mach-msm/htc_pwrsink.c
@@ -229,11 +229,13 @@ void htc_pwrsink_resume_late(struct early_suspend *h)
 	htc_pwrsink_set(PWRSINK_SYSTEM_LOAD, 38);
 }
 
+#ifdef CONFIG_WAKELOCK
 struct early_suspend htc_pwrsink_early_suspend = {
 	.level = EARLY_SUSPEND_LEVEL_DISABLE_FB + 1,
 	.suspend = htc_pwrsink_suspend_early,
 	.resume = htc_pwrsink_resume_late,
 };
+#endif
 
 static int __init htc_pwrsink_probe(struct platform_device *pdev)
 {
@@ -252,10 +254,12 @@ static int __init htc_pwrsink_probe(struct platform_device *pdev)
 
 	initialized = 1;
 
+#ifdef CONFIG_WAKELOCK
 	if (pdata->suspend_early)
 		htc_pwrsink_early_suspend.suspend = pdata->suspend_early;
 	if (pdata->resume_late)
 		htc_pwrsink_early_suspend.resume = pdata->resume_late;
+#endif
 	register_early_suspend(&htc_pwrsink_early_suspend);
 
 	return 0;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
