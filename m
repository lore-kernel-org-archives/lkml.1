Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbXB1Rgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbXB1Rgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933276AbXB1Rgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:36:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933275AbXB1Rgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:36:42 -0500
Date: Wed, 28 Feb 2007 12:36:25 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Michael Hanselmann <linux-kernel@hansmi.ch>,
       Antonino Daplas <adaplas@pol.net>
Subject: fix implicit declaration in nv_backlight.
Message-ID: <20070228173625.GA3359@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Michael Hanselmann <linux-kernel@hansmi.ch>,
	Antonino Daplas <adaplas@pol.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/nvidia/nv_backlight.c: In function 'nvidia_bl_init':
drivers/video/nvidia/nv_backlight.c:103: error: implicit declaration of function 'pmac_has_backlight_type'

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.20.noarch/drivers/video/nvidia/nv_backlight.c~	2007-02-20 22:25:15.000000000 -0500
+++ linux-2.6.20.noarch/drivers/video/nvidia/nv_backlight.c	2007-02-20 22:25:31.000000000 -0500
@@ -12,6 +12,9 @@
 #include <linux/backlight.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
+#ifdef __powerpc__
+#include <asm/backlight.h>
+#endif
 #include "nv_local.h"
 #include "nv_type.h"
 #include "nv_proto.h"

-- 
http://www.codemonkey.org.uk
