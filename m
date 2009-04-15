Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZDOCFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZDOCFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZDOCEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:04:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300AbZDOCEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:04:53 -0400
Date: Tue, 14 Apr 2009 19:01:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Alessandro Suardi <alessandro.suardi@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc2
In-Reply-To: <1239759779.2567.817.camel@ymzhang>
Message-ID: <alpine.LFD.2.00.0904141851570.4132@localhost.localdomain>
References: <alpine.LFD.2.00.0904141628570.4132@localhost.localdomain> <1239759779.2567.817.camel@ymzhang>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Apr 2009, Zhang, Yanmin wrote:
> 
> There are lots of conflictions when I apply it to 2.6.29.
> 
> Bleow are just some.
> 
> patching file arch/arm/configs/xm_x2xx_defconfig
> Hunk #1 FAILED at 1.
> Hunk #2 succeeded at 62 (offset -1 lines).

Damn.

It patches just fine if you use "git apply".

The problem? I had enabled rename detection in my .gitconfig due to 
testing a git patch, and forgotten all about it. So when I generated the 
patch, it had rename detection on. And so part of the patch looks like

	diff --git a/arch/arm/configs/xm_x2xx_defconfig b/arch/arm/configs/cm_x2xx_defconfig
	similarity index 83%
	copy from arch/arm/configs/xm_x2xx_defconfig
	copy to arch/arm/configs/cm_x2xx_defconfig
	index 1039f36..797b790 100644
	--- a/arch/arm/configs/xm_x2xx_defconfig
	+++ b/arch/arm/configs/cm_x2xx_defconfig
	@@ -1,7 +1,7 @@
	 #
	 # Automatically generated make config: don't edit
	-# Linux kernel version: 2.6.27-rc8
	-# Sun Oct  5 11:05:36 2008
	+# Linux kernel version: 2.6.29-rc2
	+# Sun Feb  1 16:31:36 2009
	 #
	 CONFIG_ARM=y
	...

and other parts just contain pure renames, and "patch" obviously won't 
understand any of that.

My bad. I didn't mean to leave people without git out in the rain. I've
re-uploaded a fixed one that doesn't have those git features..

Alessandro - did you also do things by applying that patch? Maybe your 
compile failure can be explained by the same thing, and just comes from 
not noticing the patch apply failure.

Sorry about that. The fixed patch is on master.kernel.org and should be 
mirroring out asap. And I've fixed my .gitconfig, and hopefully this won't 
happen again.

		Linus
