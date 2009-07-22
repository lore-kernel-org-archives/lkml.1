Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbZGVRM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbZGVRM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZGVRM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:12:56 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:56099 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752969AbZGVRMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:12:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:X-Identified-User;
	b=hS1ok1s9ejGTI+j9I/CN8N4VCsl4yi4y+jjwCYTzEhqV4aKSP6wEIFZLW+r6RS/2R9eRlhx9au7CYQd7ntJlTe9zSpyf3L4xDq94PNpM+2RlZlMf3quJg3QVaOWMLRFv;
Date: Wed, 22 Jul 2009 10:12:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: Alberto Gonzalez <alberto6674@gmail.com>, Michal Soltys <soltys@ziu.info>,
       Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Kernel 2.6.30 and udevd problem
Message-ID: <20090722101251.0b6c7300@jbarnes-g45>
In-Reply-To: <200907221851.20916.info@gnebu.es>
References: <200906280821.58631.info@gnebu.es>
	<200907221525.29507.info@gnebu.es>
	<20090722090834.6ab45aae@jbarnes-g45>
	<200907221851.20916.info@gnebu.es>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/AmxVL+Vzeck4LYT3D8=5wUX"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/AmxVL+Vzeck4LYT3D8=5wUX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, 22 Jul 2009 18:51:20 +0200
Alberto Gonzalez <alberto6674@gmail.com> wrote:

> On Wednesday 22 July 2009 18:08:34 Jesse Barnes wrote:
> > On Wed, 22 Jul 2009 15:25:29 +0200
> > Alberto Gonzalez <alberto6674@gmail.com> wrote:
> > > Ok, I caught a complete log from boot to when the problem starts.
> > > There doesn't seem to be anything significantly different, but
> > > just in case.
> >
> > Oh I guess this is without the debug patch I attached...  this one
> > should be a bit less noisy but tell me which bit is stuck.
> 
> Actually it was with the debug patch found here applied:
> 
> http://lkml.org/lkml/2009/7/2/290
> 
> Now I captured another one with the latest patch. This time the
> problem started after opening Amarok.
> 

Ah I must have been looking at the wrong register.  This one makes it
look like one of your HDMI hotplug bits is getting stuck (HDMIC in
particular).  This might not even be wired up on your platform...

This test hack should prevent us from responding to those interrupts...

-- 
Jesse Barnes, Intel Open Source Technology Center

--MP_/AmxVL+Vzeck4LYT3D8=5wUX
Content-Type: text/x-patch; name=i915-g4x-hotplug-hack.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=i915-g4x-hotplug-hack.patch

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index f340b3f..ecbf0b2 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -962,7 +962,7 @@ int i915_driver_irq_postinstall(struct drm_device *dev)
 		dev_priv->hotplug_supported_mask = CRT_HOTPLUG_INT_STATUS |
 			TV_HOTPLUG_INT_STATUS | SDVOC_HOTPLUG_INT_STATUS |
 			SDVOB_HOTPLUG_INT_STATUS;
-		if (IS_G4X(dev)) {
+		if (IS_G4X(dev) && 0) {
 			dev_priv->hotplug_supported_mask |=
 				HDMIB_HOTPLUG_INT_STATUS |
 				HDMIC_HOTPLUG_INT_STATUS |

--MP_/AmxVL+Vzeck4LYT3D8=5wUX--
