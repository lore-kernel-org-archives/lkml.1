Return-Path: <linux-kernel-owner+w=401wt.eu-S1752278AbZGVQIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbZGVQIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbZGVQIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:08:38 -0400
Received: from outbound-mail-110.bluehost.com ([69.89.22.10]:50436 "HELO
	outbound-mail-110.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751882AbZGVQIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:08:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:X-Identified-User;
	b=bPC9pUESBZNUVh1Omc8IoKaDx7tsFGd3LusTMFI2FaAujjO0lSwLOgBPRNGk40ENg5Ll0zDSp7KK6mp7ThFL6I3eLjz6RcwFy2mNFy4cY0JKBmgBL3ca9trqHKnnlMb+;
Date: Wed, 22 Jul 2009 09:08:34 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: Alberto Gonzalez <alberto6674@gmail.com>, Michal Soltys <soltys@ziu.info>,
       Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Kernel 2.6.30 and udevd problem
Message-ID: <20090722090834.6ab45aae@jbarnes-g45>
In-Reply-To: <200907221525.29507.info@gnebu.es>
References: <200906280821.58631.info@gnebu.es>
	<200907202306.52305.info@gnebu.es>
	<200907210048.37432.info@gnebu.es>
	<200907221525.29507.info@gnebu.es>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/XRKRvJOdURG=YocIlqZVmJ."
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/XRKRvJOdURG=YocIlqZVmJ.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 22 Jul 2009 15:25:29 +0200
Alberto Gonzalez <alberto6674@gmail.com> wrote:

> On Tuesday 21 July 2009 00:48:36 Alberto Gonzalez wrote:
> > If what you need is the exact lines just before the "storm" starts
> > let me know and I'll keep trying, but it's not easy because I'll
> > have to be very fast in detecting the problem has started and
> > logging the output of dmesg.
> 
> Ok, I caught a complete log from boot to when the problem starts.
> There doesn't seem to be anything significantly different, but just
> in case.

Oh I guess this is without the debug patch I attached...  this one
should be a bit less noisy but tell me which bit is stuck.

-- 
Jesse Barnes, Intel Open Source Technology Center

--MP_/XRKRvJOdURG=YocIlqZVmJ.
Content-Type: text/x-patch; name=i915-hotplug-error.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=i915-hotplug-error.patch

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 228546f..6c31408 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -353,7 +353,7 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 		    (iir & I915_DISPLAY_PORT_INTERRUPT)) {
 			u32 hotplug_status = I915_READ(PORT_HOTPLUG_STAT);
 
-			DRM_DEBUG("hotplug event received, stat 0x%08x\n",
+			DRM_ERROR("hotplug event received, stat 0x%08x\n",
 				  hotplug_status);
 			if (hotplug_status & dev_priv->hotplug_supported_mask)
 				schedule_work(&dev_priv->hotplug_work);

--MP_/XRKRvJOdURG=YocIlqZVmJ.--
