Return-Path: <linux-kernel-owner+w=401wt.eu-S1759827AbZLLNTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759827AbZLLNTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 08:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759817AbZLLNTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 08:19:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759811AbZLLNTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 08:19:08 -0500
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] fb/intelfb: Do not depend on EMBEDDED
Date: Sat, 12 Dec 2009 14:19:18 +0100
User-Agent: KMail/1.9.1
Cc: Dave Airlie <airlied@linux.ie>, Jeff Mahoney <jeffm@suse.de>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912121419.18617.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am worried that the intelfb driver depends on EMBEDDED. I consider
this an abuse of the EMBEDDED configuration option, which as I
understand it was originally meant to expose fine-tuning options,
rather than to arbitrarily disable drivers when not selected.

So I suggest that we drop this dependency now.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>
---
Jesse, in the original commit, you wrote that intelfb was "really a
special purpose embedded driver". It looks like a perfectly standard
framebuffer driver to me, which means that it may have users beyond
embedded. For example I always prefer framebuffer over X for my
servers. Or am I missing something and intelfb is really special?

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32.orig/drivers/video/Kconfig	2009-12-03 08:48:34.000000000 +0100
+++ linux-2.6.32/drivers/video/Kconfig	2009-12-11 10:57:43.000000000 +0100
@@ -1121,7 +1121,7 @@ config FB_CARILLO_RANCH
 
 config FB_INTEL
 	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EMBEDDED
+	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA

-- 
Jean Delvare
Suse L3
