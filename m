Return-Path: <linux-kernel-owner+w=401wt.eu-S1757565Ab0ANTb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0ANTb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553Ab0ANTb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:31:26 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:37253 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757543Ab0ANTbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:31:24 -0500
Date: Thu, 14 Jan 2010 14:31:18 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie
Subject: Re: Linux 2.6.33-rc4
Message-ID: <20100114193118.GA1203@emergent.ellipticsemi.com>
Mail-Followup-To: Pekka Enberg <penberg@cs.helsinki.fi>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	airlied@linux.ie
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
 <84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
 <20100113133357.67f9df6d@jbarnes-piketon>
 <4B4E403C.1050509@cs.helsinki.fi>
 <20100113165530.2a7e7645@jbarnes-piketon>
 <4B4F6D5F.10008@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4F6D5F.10008@cs.helsinki.fi>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:15 Thu 14 Jan     , Pekka Enberg wrote:
> OK, I think I am seeing a different kind of flicker now. It doesn't 
> happen anywhere as often as before (which is probably why I missed it 
> last night). The flicker is more like a flash of some other window 
> whereas the flicker before used to "shake" the screen.
> 
> Does this ring a bell?

Your symptoms sound identical to mine on my ThinkPad T500 laptop, as
described in http://bugs.freedesktop.org/show_bug.cgi?id=25809.

This is the patch I am currently applying locally which solves all my
problems.

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index f4b4aa2..4fb5911 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -914,7 +914,7 @@ static void intel_find_lvds_downclock(struct drm_device *dev,
 	mutex_unlock(&dev->mode_config.mutex);
 	if (temp_downclock < panel_fixed_mode->clock) {
 		/* We found the downclock for LVDS. */
-		dev_priv->lvds_downclock_avail = 1;
+		dev_priv->lvds_downclock_avail = 0;
 		dev_priv->lvds_downclock = temp_downclock;
 		DRM_DEBUG_KMS("LVDS downclock is found in EDID. "
 				"Normal clock %dKhz, downclock %dKhz\n",

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
