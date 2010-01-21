Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638Ab0AUE3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0AUE3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159Ab0AUE1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:27:51 -0500
Received: from kroah.org ([198.145.64.141]:60132 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab0AUEWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:34 2010
Message-Id: <20100121041834.166025206@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [13/30] mfd: WM835x GPIO direction register is not locked
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 8e6ba2dfa2d6c4691a83a63e211990a8bd7b788b upstream.

No need to set the security key when writing to it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/wm8350-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -134,8 +134,7 @@ static inline int is_reg_locked(struct w
 	    wm8350->reg_cache[WM8350_SECURITY] == WM8350_UNLOCK_KEY)
 		return 0;
 
-	if ((reg == WM8350_GPIO_CONFIGURATION_I_O) ||
-	    (reg >= WM8350_GPIO_FUNCTION_SELECT_1 &&
+	if ((reg >= WM8350_GPIO_FUNCTION_SELECT_1 &&
 	     reg <= WM8350_GPIO_FUNCTION_SELECT_4) ||
 	    (reg >= WM8350_BATTERY_CHARGER_CONTROL_1 &&
 	     reg <= WM8350_BATTERY_CHARGER_CONTROL_3))


