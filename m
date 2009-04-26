Return-Path: <linux-kernel-owner+w=401wt.eu-S1753116AbZDZPyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbZDZPyI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 11:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZDZPxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 11:53:55 -0400
Received: from nn7.de ([85.214.94.156]:60330 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZDZPxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 11:53:55 -0400
Subject: [PATCH] resolving Re: 2.6.30-rc3 still fails to build in
 intel_opregion_init
From: Soeren Sonnenburg <sonne@debian.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1240608012.5488.0.camel@localhost>
References: <1240608012.5488.0.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 26 Apr 2009 17:53:51 +0200
Message-Id: <1240761231.5513.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-24 at 23:20 +0200, Soeren Sonnenburg wrote:
> still the same thing...
> 
>   MODPOST vmlinux.o
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `intel_opregion_init':
> (.text+0xcf239): undefined reference to `acpi_video_register'
> make: *** [.tmp_vmlinux1] Error 1

Argh, looks like one could select ACPI_VIDEO to be build as module
though DRM_I915 requires it to be compiled inside, so I guess this patch
should fix things:

Signed-off-by: Soeren Sonnenburg <sonne@debian.org>

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 3a22eb9..71ebf04 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -71,6 +71,7 @@ config DRM_I915
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB
+	select ACPI_VIDEO
 	tristate "i915 driver"
 	help
 	  Choose this option if you have a system that has Intel 830M, 845G,


-- 
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962
