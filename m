Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbZJaNms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbZJaNms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 09:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbZJaNms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 09:42:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:52630 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793AbZJaNmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 09:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=sLgVAzpAkayoeOV1C4nd9c4I5ad+QEZhcOuiQLHEic5f4UDh+z//zCQ/JTHI+VIFM1
         b+3NdGYdWzhw2C1k6OSO3d2y9r6ckIA+Ecd5V/WPWJmrQKwcNswH5TYphlmpSL3MbSCP
         /iaVif5bCAROkQL7fNf7K4lpNiGzTvY0qi570=
Message-ID: <4AEC3ED7.6010003@gmail.com>
Date: Sat, 31 Oct 2009 14:42:47 +0100
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
Subject: Re: no video output after suspend after "drm/i915: force mode set
 at lid open time"
References: <4AE4BBBC.2070809@gmail.com>	<20091026090548.2d4e20a9@jbarnes-g45>	<4AE76463.6010404@gmail.com> <20091027142609.73ac95e2@jbarnes-g45>
In-Reply-To: <20091027142609.73ac95e2@jbarnes-g45>
Content-Type: multipart/mixed;
 boundary="------------070203000506090503070106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070203000506090503070106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jesse Barnes ha scritto:
> On Tue, 27 Oct 2009 22:21:39 +0100
> Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:
> 
>> Jesse,
>>
>> Jesse Barnes ha scritto:
>>> On Sun, 25 Oct 2009 21:57:32 +0100
>>> Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com> wrote:
>>>
>>>> Hello,
>>>>
>>>> i lost video output, screen stays black, after suspend after
>>>> commit c1c7af60892070e4b82ad63bbfb95ae745056de0 "drm/i915: force
>>>> mode set at lid open time".
>>>>
>>>> I'm attaching my dmesg with 2.6.32-rc5 (actually
>>>> 964fe080d94db82a3268443e9b9ece4c60246414), my bisect log and my
>>>> config.
>>>>
>>>> git bisect response:
>>>>
>>>> c1c7af60892070e4b82ad63bbfb95ae745056de0 is the first bad commit
>>>> commit c1c7af60892070e4b82ad63bbfb95ae745056de0
>>>> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
>>>> Date:   Thu Sep 10 15:28:03 2009 -0700
>>>>
>>>>      drm/i915: force mode set at lid open time
>>>>
>> [snip]
>>> I wonder if this is the real problem...  This patch introduced an
>>> issue that was fixed by 06891e27a9b5dba5268bb80e41a283f51335afe7
>>> that could cause a blank screen on lid open or resume, depending on
>>> how lid events were delivered.  Should be easy enough to test
>>> though, you can remove the whole
>>>
>>> +       if (acpi_lid_open())
>>> +               drm_helper_resume_force_mode(dev);
>>>
>>> block and see if that also helps (in the current tree there's a lock
>>> taken around the force_mode call, you'll need to remove those lines
>>> too for testing).
>> So i've tried separately both this and the patch with the fix for 
>> thinkpad (i have a samsung p460aa01 btw) with latest git and they
>> have not fixed the issue.
>>
>> +#if 0
>>   	if (acpi_lid_open() && !dev_priv->suspended) {
>>   		mutex_lock(&dev->mode_config.mutex);
>>   		drm_helper_resume_force_mode(dev);
>>   		mutex_unlock(&dev->mode_config.mutex);
>>   	}
>> +#endif
> 
> So just removing the above lines doesn't fix things, but reverting the
> whole patch (c1c7af60892070e4b82ad63bbfb95ae745056de0) does?  If so the
> only other thing I can think of is
> 2c907b72db4dd4e8af6dccb6e0ac122d78627b8d, which is in Linus's tree now,
> but may not be in the drm-intel tree you're testing?

Sorry for taking so long to respond. Anyway latest Linus' git master 
with reverted c1c7af60892070e4b82ad63bbfb95ae745056de0 , per attached 
patch, does not fix the issue for me. Please note that just reverting 
the commit does not compile because of an added user of acpi_lid_open() 
which requires acpi/button.h which has been added in 
7121413f2accf14cf05b38539fb7a8be77543370. Will try to revert that too.

thanks,
riccardo

--------------070203000506090503070106
Content-Type: text/x-patch;
 name="revert-c1c7af60892070e4b82ad63bbfb95ae745056de0.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="revert-c1c7af60892070e4b82ad63bbfb95ae745056de0.diff"

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index f831ea1..e4d971c 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -102,7 +102,6 @@ config DRM_I915
 	select BACKLIGHT_CLASS_DEVICE if ACPI
 	select INPUT if ACPI
 	select ACPI_VIDEO if ACPI
-	select ACPI_BUTTON if ACPI
 	help
 	  Choose this option if you have a system that has Intel 830M, 845G,
 	  852GM, 855GM 865G or 915G integrated graphics.  If M is selected, the
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 6035d3d..22d8cbd 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -256,8 +256,6 @@ typedef struct drm_i915_private {
 	unsigned int edp_support:1;
 	int lvds_ssc_freq;
 
-	struct notifier_block lid_notifier;
-
 	int crt_ddc_bus; /* -1 = unknown, else GPIO to use for CRT DDC */
 	struct drm_i915_fence_reg fence_regs[16]; /* assume 965 */
 	int fence_reg_start; /* 4 if userland hasn't ioctl'd us yet */
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 3c14240..58b3698 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -24,8 +24,6 @@
  *	Eric Anholt <eric@anholt.net>
  */
 
-#include <linux/module.h>
-#include <linux/input.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include "drmP.h"
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 98ae3d7..a6d026d 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -656,24 +656,6 @@ static int intel_lvds_get_modes(struct drm_connector *connector)
 	return 0;
 }
 
-static int intel_lid_notify(struct notifier_block *nb, unsigned long val,
-			    void *unused)
-{
-	struct drm_i915_private *dev_priv =
-		container_of(nb, struct drm_i915_private, lid_notifier);
-	struct drm_device *dev = dev_priv->dev;
-
-	if (acpi_lid_open() && !dev_priv->suspended) {
-		mutex_lock(&dev->mode_config.mutex);
-		drm_helper_resume_force_mode(dev);
-		mutex_unlock(&dev->mode_config.mutex);
-	}
-
-	drm_sysfs_hotplug_event(dev_priv->dev);
-
-	return NOTIFY_OK;
-}
-
 /**
  * intel_lvds_destroy - unregister and free LVDS structures
  * @connector: connector to free
@@ -683,14 +665,10 @@ static int intel_lid_notify(struct notifier_block *nb, unsigned long val,
  */
 static void intel_lvds_destroy(struct drm_connector *connector)
 {
-	struct drm_device *dev = connector->dev;
 	struct intel_output *intel_output = to_intel_output(connector);
-	struct drm_i915_private *dev_priv = dev->dev_private;
 
 	if (intel_output->ddc_bus)
 		intel_i2c_destroy(intel_output->ddc_bus);
-	if (dev_priv->lid_notifier.notifier_call)
-		acpi_lid_notifier_unregister(&dev_priv->lid_notifier);
 	drm_sysfs_connector_remove(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -1057,11 +1035,6 @@ out:
 		pwm |= PWM_PCH_ENABLE;
 		I915_WRITE(BLC_PWM_PCH_CTL1, pwm);
 	}
-	dev_priv->lid_notifier.notifier_call = intel_lid_notify;
-	if (acpi_lid_notifier_register(&dev_priv->lid_notifier)) {
-		DRM_DEBUG("lid notifier registration failed\n");
-		dev_priv->lid_notifier.notifier_call = NULL;
-	}
 	drm_sysfs_connector_add(connector);
 	return;
 

--------------070203000506090503070106--
