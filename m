Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577Ab0BPXUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:20:18 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:47432 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933561Ab0BPXUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:20:15 -0500
Message-ID: <4B7B27BC.8010905@oracle.com>
Date: Tue, 16 Feb 2010 15:18:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: linux-next <linux-next@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Airlie <airlied@linux.ie>
Subject: [PATCH -next] vmwgfx: depends on FB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B7B281E.0209:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

vmwfgx uses framebuffer interfaces, so it should depend on FB.
Otherwise it has these build errors (e.g., when CONFIG_FB=m):

drivers/built-in.o: In function `vmw_fb_close':
(.text+0x97713): undefined reference to `unregister_framebuffer'
drivers/built-in.o: In function `vmw_fb_close':
(.text+0x97754): undefined reference to `framebuffer_release'
drivers/built-in.o: In function `vmw_fb_init':
(.text+0x97e1c): undefined reference to `framebuffer_alloc'
drivers/built-in.o: In function `vmw_fb_init':
(.text+0x9838d): undefined reference to `register_framebuffer'
drivers/built-in.o: In function `vmw_fb_init':
(.text+0x9842a): undefined reference to `framebuffer_release'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/gpu/drm/vmwgfx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100216.orig/drivers/gpu/drm/vmwgfx/Kconfig
+++ linux-next-20100216/drivers/gpu/drm/vmwgfx/Kconfig
@@ -1,6 +1,6 @@
 config DRM_VMWGFX
 	tristate "DRM driver for VMware Virtual GPU"
-	depends on DRM && PCI
+	depends on DRM && PCI && FB
 	select FB_DEFERRED_IO
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
--

