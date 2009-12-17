Return-Path: <linux-kernel-owner+w=401wt.eu-S936354AbZLQEO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936354AbZLQEO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936345AbZLQEOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:14:24 -0500
Received: from kroah.org ([198.145.64.141]:55975 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936170AbZLQEFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:59 2009
Message-Id: <20091217035659.581597734@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>, Petr Vandrovec <VANDROVE@vc.cvut.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, "Paul A. Clarke" <pc@us.ibm.com>
Subject: [128/151] matroxfb: fix problems with display stability
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 8c651311a3a08c1e4815de6933e00a760e498dae upstream.

Regression caused in 2.6.23 and then despite repeated requests never fixed
or dealt with (Petr promised to sort it in 2008 but seems to have
forgotten).

Enough is enough - remove the problem line that was added.  If it upsets
someone they've had two years to deal with it and at the very least it'll
rattle their cage and wake them up.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9709

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Damon <account@bugzilla.kernel.org.juxtaposition.net>
Tested-by: Ruud van Melick <rvm1974@raketnet.nl>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul A. Clarke <pc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/matrox/g450_pll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/video/matrox/g450_pll.c
+++ b/drivers/video/matrox/g450_pll.c
@@ -368,7 +368,8 @@ static int __g450_setclk(struct matrox_f
 					M1064_XDVICLKCTRL_C1DVICLKEN |
 					M1064_XDVICLKCTRL_DVILOOPCTL |
 					M1064_XDVICLKCTRL_P1LOOPBWDTCTL;
-				matroxfb_DAC_out(minfo, M1064_XDVICLKCTRL, tmp);
+                                /* Setting this breaks PC systems so don't do it */
+				/* matroxfb_DAC_out(minfo, M1064_XDVICLKCTRL, tmp); */
 				matroxfb_DAC_out(minfo, M1064_XPWRCTRL,
 						 xpwrctrl);
 


