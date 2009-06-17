Return-Path: <linux-kernel-owner+w=401wt.eu-S1762623AbZFQJLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762623AbZFQJLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbZFQJLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:11:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36054 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbZFQJLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:11:46 -0400
Date: Wed, 17 Jun 2009 11:11:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090617091139.GA4536@elf.ucw.cz>
References: <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com> <20090612150504.GA15084@elf.ucw.cz> <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com> <20090615170103.GE25040@elf.ucw.cz> <a55d774e0906151132m5584409epe0b7581fde5ec184@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906151132m5584409epe0b7581fde5ec184@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ...in trout... Does dream really support flash?
> >
> >        {
> >                .name = "spotlight",
> >                .gpio = TROUT_GPIO_SPOTLIGHT_EN,
> >        },
> >
> > ...what is spotlight? I wish dream had some way to produce light in
> > dark...
> 
> Earlier revisions had an LED flash for the camera.  This didn't make
> it into the final hardware.

Ok, and what is the spotlight? Did flash have two modes?

One more question... do you have keymap.map to make console usable? By
default, keyboard lacks any special characters...

---

Flash is not wired on Dreams users actually have, document that.

Document purpose of pwrsink.c.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
index c1a7431..a65cce5 100644
--- a/arch/arm/mach-msm/board-trout.c
+++ b/arch/arm/mach-msm/board-trout.c
@@ -304,6 +304,8 @@ static struct timed_gpio timed_gpios[] = {
 		.max_timeout = 15000,
 	},
 	{
+		/* Prototype versions of HTC dream had LED flash; 
+		   released hw lacks it. */  
 		.name = "flash",
 		.gpio = TROUT_GPIO_FLASH_EN,
 		.max_timeout = 400,
diff --git a/arch/arm/mach-msm/htc_pwrsink.c b/arch/arm/mach-msm/htc_pwrsink.c
index 3d3c55c..b74f776 100644
--- a/arch/arm/mach-msm/htc_pwrsink.c
+++ b/arch/arm/mach-msm/htc_pwrsink.c
@@ -15,6 +15,10 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
+ * Some of HTC devices don't have a battery gauge IC and estimate
+ * current drain based on hints provided to the baseband from the apps
+ * processor.
+ * 
  */
 
 #include <linux/platform_device.h>



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
