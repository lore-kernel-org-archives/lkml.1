Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbZALITz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbZALITz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZALITq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:19:46 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:40906 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZALITp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:19:45 -0500
Date: Mon, 12 Jan 2009 09:19:42 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: agnx - drivers/staging/agnx/agnx.h needs <linux/io.h>
In-Reply-To: <20090106221129.GB32689@kroah.com>
Message-ID: <Pine.LNX.4.64.0901120918220.30201@anakin>
References: <20090106221129.GB32689@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Jan 2009, Greg KH wrote:
> 		- agnx wireless driver

Subject: [PATCH] staging: agnx - drivers/staging/agnx/agnx.h needs <linux/io.h>

On m68k:
drivers/staging/agnx/agnx.h: In function 'agnx_read32':
drivers/staging/agnx/agnx.h:10: error: implicit declaration of function 'ioread32'
drivers/staging/agnx/agnx.h: In function 'agnx_write32':
drivers/staging/agnx/agnx.h:15: error: implicit declaration of function 'iowrite32'
drivers/staging/agnx/sta.c: In function 'get_sta_power':
drivers/staging/agnx/sta.c:94: error: implicit declaration of function 'memcpy_fromio'
drivers/staging/agnx/sta.c: In function 'set_sta_power':
drivers/staging/agnx/sta.c:103: error: implicit declaration of function 'memcpy_toio'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/agnx/agnx.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/agnx/agnx.h b/drivers/staging/agnx/agnx.h
index a75b0db..20f36da 100644
--- a/drivers/staging/agnx/agnx.h
+++ b/drivers/staging/agnx/agnx.h
@@ -1,6 +1,8 @@
 #ifndef AGNX_H_
 #define AGNX_H_
 
+#include <linux/io.h>
+
 #include "xmit.h"
 
 #define PFX				KBUILD_MODNAME ": "
-- 
1.5.6.5

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
