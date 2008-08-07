Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYHGPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYHGPgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYHGPgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:36:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17528 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYHGPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:36:04 -0400
Date: Thu, 7 Aug 2008 08:32:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: airlied@linux.ie, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] drm: sis depends on FB_SIS
Message-Id: <20080807083228.0fc40405.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
cc: airlied@linux.ie

drm/sis calls mm functions in fb/sis, so make the former depend
on the latter.

This one happened with FB_SIS=m, AGP_SIS=y, DRM_SYS=y.

sis1.out:sis_mm.c:(.text+0x70014): undefined reference to `sis_free'
sis1.out:sis_mm.c:(.text+0x7002a): undefined reference to `sis_malloc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/gpu/drm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080806.orig/drivers/gpu/drm/Kconfig
+++ linux-next-20080806/drivers/gpu/drm/Kconfig
@@ -86,7 +86,7 @@ config DRM_MGA
 
 config DRM_SIS
 	tristate "SiS video cards"
-	depends on DRM && AGP
+	depends on DRM && AGP && FB_SIS
 	help
 	  Choose this option if you have a SiS 630 or compatible video
           chipset. If M is selected the module will be called sis. AGP


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
