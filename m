Return-Path: <linux-kernel-owner+w=401wt.eu-S1750726AbXCUWjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750726AbXCUWjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXCUWjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:39:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46665 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751004AbXCUWjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:39:14 -0400
Date: Wed, 21 Mar 2007 23:39:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Suspend to disk bug 2.6.21-rc2-git1
Message-ID: <20070321223908.GI6057@elf.ucw.cz>
References: <20070305132331.GF3693@mail.muni.cz> <20070310221639.GC2674@elf.ucw.cz> <20070321213007.GA3637@mail.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321213007.GA3637@mail.muni.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I'm not sure what version did exacly caused susped to disk problems but
> > > anyway, in 2.6.21-rc2-git1, suspend to disk breaks ACPI. ACPI events do not
> > > even emit ACPI interrupts. Suspend to ram works nicely.
> > 
> > Is 2.6.21-latest better?  There were many problems in suspend area,
> > hopefully they are slowly being fixed...
> 
> I've found out that only platform method is working. reboot method does not.

Try this one.
									Pavel

Fix reboot mode blinking moon icon after resume.

---
commit 5958dbea2ea6147f4fd0477b303be752d5c4f53a
tree 9c032e050d09201f66e1706fef4d7bbe8e55c418
parent 2744ccbdcc03f36d193fe20fc17698cfb2a1acea
author Pavel <pavel@amd.ucw.cz> Tue, 20 Mar 2007 16:33:03 +0100
committer Pavel <pavel@amd.ucw.cz> Tue, 20 Mar 2007 16:33:03 +0100

 kernel/power/disk.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 873cdf8..dee0ff4 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -241,18 +241,11 @@ static int software_resume(void)
 		goto Done;
 	}
 
-	error = platform_prepare();
-	if (error) {
-		swsusp_free();
-		goto Thaw;
-	}
-
 	pr_debug("PM: Reading swsusp image.\n");
 
 	error = swsusp_read();
 	if (error) {
 		swsusp_free();
-		platform_finish();
 		goto Thaw;
 	}
 
@@ -270,7 +263,6 @@ static int software_resume(void)
 	enable_nonboot_cpus();
  Free:
 	swsusp_free();
-	platform_finish();
 	device_resume();
 	resume_console();
  Thaw:

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
