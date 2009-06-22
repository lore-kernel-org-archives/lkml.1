Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZFXScj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZFXScj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 14:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbZFXSca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 14:32:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59572 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZFXSc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 14:32:29 -0400
Date: Mon, 22 Jun 2009 20:12:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vitaly Minko <vitaly.minko@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: 2.6.30 kernel for Zaurus
Message-ID: <20090622181227.GA2473@ucw.cz>
References: <4A4227D7.4050900@gmail.com> <20090624181323.GC6618@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624181323.GC6618@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-24 20:13:24, Pavel Machek wrote:
> 
> On Wed 2009-06-24 17:19:19, Vitaly Minko wrote:
> > Hi Pavel,
> >
> > I want to upgrade my kernel on Zaurus C1000 to the latest stable version.
> > Do I need any additional patches besides your suspend-related one that  
> > you posted here:
> > http://patchwork.kernel.org/patch/26927/
> 
> Well, you'll also need to disable offline charging, and I only tested
> it on spitz.

Try this...

diff -ur arm.ofic/common/sharpsl_pm.c arm/common/sharpsl_pm.c
--- arm.ofic/common/sharpsl_pm.c	2009-05-29 01:10:31.000000000 +0200
+++ arm/common/sharpsl_pm.c	2009-06-01 12:01:35.000000000 +0200
@@ -12,7 +12,7 @@
  *
  */
 
-#undef DEBUG
+#define DEBUG
 
 #include <linux/module.h>
 #include <linux/timer.h>
@@ -546,6 +546,9 @@
 
 static int corgi_enter_suspend(unsigned long alarm_time, unsigned int alarm_enable, suspend_state_t state)
 {
+
+  return 0;
+
 	if (!sharpsl_pm.machinfo->should_wakeup(!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE) && alarm_enable) )
 	{
 		if (!(sharpsl_pm.flags & SHARPSL_ALARM_ACTIVE)) {
diff -ur arm.ofic/mach-pxa/spitz_pm.c arm/mach-pxa/spitz_pm.c
--- arm.ofic/mach-pxa/spitz_pm.c	2009-05-29 01:11:02.000000000 +0200
+++ arm/mach-pxa/spitz_pm.c	2009-05-28 23:28:30.000000000 +0200
@@ -124,6 +124,7 @@
 	int is_resume = 0;
 	int acin = sharpsl_pm.machinfo->read_devdata(SHARPSL_STATUS_ACIN);
 
+#if 0
 	if (spitz_last_ac_status != acin) {
 		if (acin) {
 			/* charge on */
@@ -141,6 +142,8 @@
 		return 0;
 	}
 
+#endif
+
 	if (PEDR & GPIO_bit(SPITZ_GPIO_KEY_INT))
 		is_resume |= GPIO_bit(SPITZ_GPIO_KEY_INT);
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
