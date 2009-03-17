Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZCQU4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZCQU4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 16:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZCQU4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 16:56:37 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:38343 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZCQU4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 16:56:36 -0400
Date: Tue, 17 Mar 2009 22:02:51 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Risto Suominen <risto.suominen@gmail.com>, geert@linux-m68k.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fb: hide hardware cursor in graphics mode (Mach64)
Message-Id: <20090317220251.d6fb00ff.krzysztof.h1@poczta.fm>
In-Reply-To: <20090211142409.b88c577e.akpm@linux-foundation.org>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	<Pine.LNX.4.64.0901240951110.13803@anakin>
	<46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	<Pine.LNX.4.64.0901241425310.13803@anakin>
	<46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	<46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
	<46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
	<20090211142409.b88c577e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

A hardware cursor is left enabled in
the fb_set_par() which is called when
a new console is created. This is
inconsistent with software cursor's
behaviour.

Also, this makes a hardware cursor
always visible in the Xfbdev
(Xorg kdrive) server.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
CC: Risto Suominen 
---
Finally, I acquired a Mach64GZ card and was able to 
solve this puzzle.

Risto, please test the patch. 

 drivers/video/aty/mach64_accel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/aty/mach64_accel.c b/drivers/video/aty/mach64_accel.c
index a8f60c3..0cc9724 100644
--- a/drivers/video/aty/mach64_accel.c
+++ b/drivers/video/aty/mach64_accel.c
@@ -39,7 +39,8 @@ void aty_reset_engine(const struct atyfb_par *par)
 {
 	/* reset engine */
 	aty_st_le32(GEN_TEST_CNTL,
-		aty_ld_le32(GEN_TEST_CNTL, par) & ~GUI_ENGINE_ENABLE, par);
+		aty_ld_le32(GEN_TEST_CNTL, par) &
+		~(GUI_ENGINE_ENABLE | HWCURSOR_ENABLE), par);
 	/* enable engine */
 	aty_st_le32(GEN_TEST_CNTL,
 		aty_ld_le32(GEN_TEST_CNTL, par) | GUI_ENGINE_ENABLE, par);
-- 
1.5.2.2


----------------------------------------------------------------------
Szukasz pieniedzy? Wez podwójny limit zad³u¿enia w koncie direct.
>> http://link.interia.pl/f20a3

