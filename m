Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbYAYKhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbYAYKhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbYAYKgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:36:52 -0500
Received: from ip-svs-1.Informatik.Uni-Oldenburg.DE ([134.106.12.126]:51290
	"EHLO schlidder.svs.informatik.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752960AbYAYKgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:36:51 -0500
X-Greylist: delayed 1512 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 05:36:51 EST
Date: Fri, 25 Jan 2008 11:11:34 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: [PATCH] linux-2.6.24/drivers/hid/hid-input.c
Message-ID: <20080125101134.GA3802@titan.lahn.de>
Mail-Followup-To: Jiri Kosina <jkosina@suse.cz>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hidinput_configure_usage(device), IS_CHICONY_TACTICAL_PAD(devic) gets
passed the 'device' parameter. But that macro still references its
parameter by 'device' instead of by its local name 'x'.

Signed-off-by: Philipp Matthias Hahn <pmhahn@titan.lahn.de>

--- linux/drivers/hid/hid-input.c	2008-01-25 09:57:17.000000000 +0100
+++ linux/drivers/hid/hid-input.c	2008-01-25 10:56:35.835871529 +0100
@@ -87,7 +87,7 @@
 #define map_key_clear(c)	do { map_key(c); clear_bit(c, bit); } while (0)
 
 /* hardware needing special handling due to colliding MSVENDOR page usages */
-#define IS_CHICONY_TACTICAL_PAD(x) (x->vendor == 0x04f2 && device->product == 0x0418)
+#define IS_CHICONY_TACTICAL_PAD(x) (x->vendor == 0x04f2 && x->product == 0x0418)
 #define IS_MS_KB(x) (x->vendor == 0x045e && (x->product == 0x00db || x->product == 0x00f9))
 
 #ifdef CONFIG_USB_HIDINPUT_POWERBOOK
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
