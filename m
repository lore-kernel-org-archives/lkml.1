Return-Path: <linux-kernel-owner+w=401wt.eu-S1752081Ab0ATNb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab0ATNb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709Ab0ATNbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:31:25 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:64415 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab0ATNbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:31:25 -0500
Date: Wed, 20 Jan 2010 14:31:44 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Cc: siccegge@stud.informatik.uni-erlangen.de,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH] Obsolete config in kernel source (USE_MIXARTLOADER)
Message-ID: <20100120133144.GD3580@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	The config Variable USE_MIXARTLOADER has been non-existent for
all git based linux kernels (2.6.12-rc) and seems to be no longer
relevant. It is only referenced at one place in the Code
(sound/pci/mixart/mixart_hwdep.c).

	The attached patch makes the behaviour more obvious as it is
equivalent to the old one when assuming CONFIG_MIXARTLOADER as not
defined.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger


--+pHx0qQiF2pBVqBT
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-config-USE_MIXARTLOADER-has-never-existed-in-KConfig.patch"

>From 974a2f370b3401e948821bae47c3e9edb1b21a5e Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Wed, 20 Jan 2010 14:23:47 +0100
Subject: [PATCH] config USE_MIXARTLOADER has never existed in KConfig for 2.6 linux
 kernels so this part of the check always evaluates to true thus
 removing the part of the check.


Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 sound/pci/mixart/mixart_hwdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
-- 
1.6.3.3


--+pHx0qQiF2pBVqBT--
