Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935392Ab0BZHKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:10:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37931 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935359Ab0BZHKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:10:08 -0500
Date: Fri, 26 Feb 2010 18:10:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Martin Fuzzey <mfuzzey@gmail.com>,
       =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the usb tree with the i.MX tree
Message-Id: <20100226181003.a08c83cf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/arm/mach-mx2/devices.h between commit
68c94b40b31926f627573a7f656b903f6644744e ("arm/mx2: use cpp magic to
create spi_imx devices") from the i.MX tree and commit
3f1c5d0f4c64f5e9e4ac329a935b3da67593691f ("USB: MXC: add platform
resources for i.MX21 USB host controller") from the usb tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mx2/devices.h
index f15df2a,f12694b..0000000
--- a/arch/arm/mach-mx2/devices.h
+++ b/arch/arm/mach-mx2/devices.h
@@@ -34,8 -25,7 +34,9 @@@ extern struct platform_device mxc_usbh1
  extern struct platform_device mxc_usbh2;
  extern struct platform_device mxc_spi_device0;
  extern struct platform_device mxc_spi_device1;
 +#ifdef CONFIG_MACH_MX27
  extern struct platform_device mxc_spi_device2;
 +#endif
+ extern struct platform_device mx21_usbhc_device;
  extern struct platform_device imx_ssi_device0;
  extern struct platform_device imx_ssi_device1;
