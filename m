Return-Path: <linux-kernel-owner+w=401wt.eu-S1751441AbZL0Jfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbZL0Jfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 04:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbZL0Jfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 04:35:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42947 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZL0Jfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 04:35:51 -0500
Date: Sun, 27 Dec 2009 10:35:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Daniel Walker <dwalker@codeaurora.org>,
       Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
Subject: Re: tree with htc dream support
Message-ID: <20091227093537.GD11737@elf.ucw.cz>
References: <20091205221100.GA32522@elf.ucw.cz>
 <1260054737.23633.35.camel@desktop>
 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
 <1260627482.20913.7.camel@desktop>
 <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
 <20091213212504.GD5114@elf.ucw.cz>
 <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > One more wish list item: many drivers are now available in
> > drivers/staging/dream, and are being slowly cleaned up. Would it be
> > possible to start using those for android-msm-2.6.32 tree?
> >
> > You'll need to reapply some stuff I had to remove (like wakelocks),
> > but it should be still better/less work long term to patch those back
> > in than maintaining separate copy. Diff should get much smaller...
> 
> I do plan to look at these, but I don't know when I'll get to it.

So... this switches qdsp5 code from private version to version in
staging. It actually boots.

It should be followed by git rm of around 12K lines of code from your
patch... (And yes, it actually boots; I tested camera, it worked).

Signed-off-by: Pavel Machek <pavel@ucw.cz>

									Pavel
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 49f85b4..94623a4 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_MSM_ONCRPCROUTER) += smd_rpcrouter_device.o
 obj-$(CONFIG_MSM_ONCRPCROUTER) += smd_rpcrouter_servers.o
 obj-$(CONFIG_MSM_RPCSERVERS) += rpc_server_dog_keepalive.o
 obj-$(CONFIG_MSM_RPCSERVERS) += rpc_server_time_remote.o
-obj-$(CONFIG_MSM_ADSP) += qdsp5/
+obj-$(CONFIG_MSM_ADSP) += ../../../drivers/staging/dream/qdsp5/
 obj-$(CONFIG_MSM_HW3D) += hw3d.o
 obj-$(CONFIG_PM) += pm.o
 obj-$(CONFIG_CPU_FREQ) += cpufreq.o


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
