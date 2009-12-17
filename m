Return-Path: <linux-kernel-owner+w=401wt.eu-S1763741AbZLQBXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763741AbZLQBXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763745AbZLQBVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:21:20 -0500
Received: from kroah.org ([198.145.64.141]:41530 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763718AbZLQBVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:21:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:09 2009
Message-Id: <20091217011609.093584674@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>, Petr Vandrovec <VANDROVE@vc.cvut.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>, "Paul A. Clarke" <pc@us.ibm.com>
Subject: [85/90] matroxfb: fix problems with display stability
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

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
@@ -341,7 +341,8 @@ static int __g450_setclk(WPMINFO unsigne
 					M1064_XDVICLKCTRL_C1DVICLKEN |
 					M1064_XDVICLKCTRL_DVILOOPCTL |
 					M1064_XDVICLKCTRL_P1LOOPBWDTCTL;
-				matroxfb_DAC_out(PMINFO M1064_XDVICLKCTRL,tmp);
+				/* Setting this breaks PC systems so don't do it */
+				/* matroxfb_DAC_out(PMINFO M1064_XDVICLKCTRL,tmp); */
 				matroxfb_DAC_out(PMINFO M1064_XPWRCTRL,
 						 xpwrctrl);
 


