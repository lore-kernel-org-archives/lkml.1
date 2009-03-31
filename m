Return-Path: <linux-kernel-owner+w=401wt.eu-S1765173AbZCaXfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765173AbZCaXfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764128AbZCaXVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:50 -0400
Received: from sous-sol.org ([216.99.217.87]:33293 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764107AbZCaXVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:49 -0400
Message-Id: <20090331231656.465301717@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tony Lindgren <tony@atomide.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [patch 32/45] ARM: twl4030 - leak fix
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=arm-twl4030-leak-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

upstream commit: 803c78e4da28d7d7cb0642caf643b9289ae7838a

Trivial error path leak fix. Problem found by Daniel Marjamäki using
cppcheck

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/arm/mach-omap2/mmc-twl4030.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-omap2/mmc-twl4030.c
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -397,6 +397,7 @@ void __init twl4030_mmc_init(struct twl4
 			break;
 		default:
 			pr_err("MMC%d configuration not supported!\n", c->mmc);
+			kfree(mmc);
 			continue;
 		}
 		hsmmc_data[c->mmc - 1] = mmc;

