Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067Ab0ATN54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0ATN54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779Ab0ATN5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:57:53 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:61660 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab0ATN5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:57:52 -0500
Date: Wed, 20 Jan 2010 14:57:50 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: Reinhard.Tartler@informatik.uni-erlangen.de
Subject: Re: [PATCH] Obsolete config in kernel source (USE_MIXARTLOADER)
Message-ID: <20100120135750.GC2040@stud.informatik.uni-erlangen.de>
References: <20100120133144.GD3580@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <20100120133144.GD3580@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 20, 2010 at 02:31:44PM +0100, Christoph Egger wrote:
> Hi all!
> 
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
> 
> 	The config Variable USE_MIXARTLOADER has been non-existent for
> all git based linux kernels (2.6.12-rc) and seems to be no longer
> relevant. It is only referenced at one place in the Code
> (sound/pci/mixart/mixart_hwdep.c).
> 
> 	The attached patch makes the behaviour more obvious as it is
> equivalent to the old one when assuming CONFIG_MIXARTLOADER as not
> defined.
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.

	Sorry, it seems I'm a bit unconcentrated today there are three
of them actually. Attached the new patch fixing all 3 of them.

Regards

	Christoph Egger



--bCsyhTFzCvuiizWE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-config-USE_MIXARTLOADER-has-never-existed-in-KConfig.patch"

>From 9039fdcb025eb8794ffee7844aab5da6bb917979 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Wed, 20 Jan 2010 14:23:47 +0100
Subject: [PATCH] config USE_MIXARTLOADER has never existed in KConfig for 2.6 linux
 kernels so this part of the check always evaluates to true thus
 removing the part of the check.

The same is true for USE_PCXHRLOADER and USE_VXLOADER

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 include/sound/vx_core.h         |    2 +-
 sound/pci/mixart/mixart_hwdep.c |    2 +-
 sound/pci/pcxhr/pcxhr_hwdep.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/sound/vx_core.h b/include/sound/vx_core.h
index 5456343..c6835dd 100644
--- a/include/sound/vx_core.h
+++ b/include/sound/vx_core.h
@@ -28,7 +28,7 @@
 #include <linux/interrupt.h>
 
 #if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
-#if !defined(CONFIG_USE_VXLOADER) && !defined(CONFIG_SND_VX_LIB) /* built-in kernel */
+#if !defined(CONFIG_SND_VX_LIB) /* built-in kernel */
 #define SND_VX_FW_LOADER	/* use the standard firmware loader */
 #endif
 #endif
diff --git a/sound/pci/mixart/mixart_hwdep.c b/sound/pci/mixart/mixart_hwdep.c
index 4cf4cd8..ef39a58 100644
--- a/sound/pci/mixart/mixart_hwdep.c
+++ b/sound/pci/mixart/mixart_hwdep.c
@@ -545,7 +545,7 @@ static int mixart_dsp_load(struct mixart_mgr* mgr, int index, const struct firmw
 
 
 #if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
-#if !defined(CONFIG_USE_MIXARTLOADER) && !defined(CONFIG_SND_MIXART) /* built-in kernel */
+#if !defined(CONFIG_SND_MIXART) /* built-in kernel */
 #define SND_MIXART_FW_LOADER	/* use the standard firmware loader */
 #endif
 #endif
diff --git a/sound/pci/pcxhr/pcxhr_hwdep.c b/sound/pci/pcxhr/pcxhr_hwdep.c
index 17cb123..16152ce 100644
--- a/sound/pci/pcxhr/pcxhr_hwdep.c
+++ b/sound/pci/pcxhr/pcxhr_hwdep.c
@@ -35,7 +35,7 @@
 
 
 #if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
-#if !defined(CONFIG_USE_PCXHRLOADER) && !defined(CONFIG_SND_PCXHR) /* built-in kernel */
+#if !defined(CONFIG_SND_PCXHR) /* built-in kernel */
 #define SND_PCXHR_FW_LOADER	/* use the standard firmware loader */
 #endif
 #endif
-- 
1.6.3.3


--bCsyhTFzCvuiizWE--
