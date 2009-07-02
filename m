Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZGBQf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZGBQf5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbZGBQft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:35:49 -0400
Received: from outbound-mail-157.bluehost.com ([67.222.39.37]:56443 "HELO
	outbound-mail-157.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750726AbZGBQfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:35:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:X-Identified-User;
	b=DQesDf/eL42wyczL9+fjsQe+NN2CHvQLdaqvBQ2j8GW4Pbc3nGdZKDcZ8u8BcFHHYNuGgNN48jHWhOxySaGWkjhZmoBSJZjCWavLS+xPRS/O317kg4frQK4e2rVK+Joi;
Date: Thu, 2 Jul 2009 09:35:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Kernel 2.6.30 and udevd problem
Message-ID: <20090702093547.7ca95116@jbarnes-g45>
In-Reply-To: <200907020818.58541.info@gnebu.es>
References: <200906280821.58631.info@gnebu.es>
	<200907010909.03645.info@gnebu.es>
	<20090701102214.352bfe72@jbarnes-g45>
	<200907020818.58541.info@gnebu.es>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/2Ws+cfeypvfGVFlv1wHoKF8"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/2Ws+cfeypvfGVFlv1wHoKF8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 2 Jul 2009 08:18:58 +0200
Alberto Gonzalez <alberto6674@gmail.com> wrote:

> On Wednesday 01 July 2009 19:22:14 Jesse Barnes wrote:
> > On Wed, 1 Jul 2009 09:09:03 +0200
> >
> > Alberto Gonzalez <alberto6674@gmail.com> wrote:
> > > On Tuesday 30 June 2009 18:08:35 Jesse Barnes wrote:
> > > > On Tue, 30 Jun 2009 04:46:38 +0100 (IST)
> > > >
> > > > Dave Airlie <airlied@linux.ie> wrote:
> > > > > > On Sunday 28 June 2009 16:28:44 Kay Sievers wrote:
> > > > > > > If there isn't something else running which acts on
> > > > > > > uevents that trigger drm events, which I wouldn't expect,
> > > > > > > it seems like a drm kernel problem.
> > > > > >
> > > > > > Ok, thanks for looking at it. I'll sum up the problem for
> > > > > > DRM people:
> > > > > >
> > > > > > The problem started after upgrading to 2.6.30. At some
> > > > > > point, udevd starts to use a lot of CPU time. It happens
> > > > > > randomly, but it seems easier to trigger when running
> > > > > > something graphics intensive (glxgears, gtkperf,
> > > > > > tuxracer..).
> > > > > >
> > > > > > Killing udevd and starting it with the --debug switch
> > > > > > throws up this when the problem starts:
> > > > >
> > > > > I've added jbarnes to the list,
> > > > >
> > > > > Jesses are we sending events yet? what for?
> > > >
> > > > Right now we just send uevents at hotplug time, so maybe one of
> > > > our hotplug interrupt bits is getting stuck, resulting in a
> > > > continuous stream of events as we generate other interrupts
> > > > (which would happen when running 3D apps for example).
> > > >
> > > > There's a DRM_DEBUG statement in drivers/gpu/drm/i915/i915_irq.c
> > > > under the if (I915_HAS_HOTPLUG(dev)) { check, if you make it
> > > > into DRM_ERROR we can see which one is getting stuck.
> > >
> > > I am afraid I'll need a bit more guidance here. I guess this means
> > > patching the kernel. Would it be possible to get a test patch
> > > against 2.6.30? And then after patching and compiling, how should
> > > I debug it?
> >
> > Here's a patch against git, it should apply to 2.6.30 though I
> > think.
> >
> > I'll just need your dmesg output from when the problem is occurring
> > (if I'm right this patch should flood your logs).
> 
> Thanks, the patch applied to 2.6.30 and when the problem stars I get
> these two lines repeated all the time in dmesg:
> 
> [drm:i915_driver_irq_handler] *ERROR* hotplug event received, stat
> 0x10200300 [drm:i915_driver_irq_handler] *ERROR* hotplug event
> received, stat 0x18200300
> 
> Is this enough or should I provide something else?

Interesting.  That hotplug status shouldn't end up generating any
uevents.  Can you try this patch to see what's going on?

-- 
Jesse Barnes, Intel Open Source Technology Center

--MP_/2Ws+cfeypvfGVFlv1wHoKF8
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=drm-uevent-debug.patch

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 85ec31b..d4c6d82 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -456,6 +456,8 @@ void drm_sysfs_hotplug_event(struct drm_device *dev)
 	char *event_string = "HOTPLUG=1";
 	char *envp[] = { event_string, NULL };
 
+	WARN(1, "hotplug uevent\n");
+
 	DRM_DEBUG("generating hotplug event\n");
 
 	kobject_uevent_env(&dev->primary->kdev.kobj, KOBJ_CHANGE, envp);
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 228546f..29e1e4b 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -353,10 +353,12 @@ irqreturn_t i915_driver_irq_handler(DRM_IRQ_ARGS)
 		    (iir & I915_DISPLAY_PORT_INTERRUPT)) {
 			u32 hotplug_status = I915_READ(PORT_HOTPLUG_STAT);
 
-			DRM_DEBUG("hotplug event received, stat 0x%08x\n",
-				  hotplug_status);
-			if (hotplug_status & dev_priv->hotplug_supported_mask)
+			if (hotplug_status & dev_priv->hotplug_supported_mask) {
+				DRM_DEBUG("hotplug event received: 0x%08x\n",
+					  hotplug_status &
+					  dev_priv->hotplug_supported_mask);
 				schedule_work(&dev_priv->hotplug_work);
+			}
 
 			I915_WRITE(PORT_HOTPLUG_STAT, hotplug_status);
 			I915_READ(PORT_HOTPLUG_STAT);

--MP_/2Ws+cfeypvfGVFlv1wHoKF8--
