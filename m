Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbZBNCfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbZBNCfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 21:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZBNCfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 21:35:37 -0500
Received: from void.printf.net ([89.145.121.20]:40184 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZBNCfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 21:35:36 -0500
X-Greylist: delayed 2317 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 21:35:36 EST
From: Chris Ball <cjb@laptop.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andres Salomon <dilinger@queued.net>
Subject: [PATCH] olpc: fix model detection without OFW
References: <1222208409.16003.25.camel@brick>
Date: Fri, 13 Feb 2009 20:56:18 -0500
In-Reply-To: <1222208409.16003.25.camel@brick> (Harvey Harrison's message of
	"Tue, 23 Sep 2008 15:20:09 -0700")
Message-ID: <m3mycpye65.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey's endianness patch (e51a1ac2dfca9ad869471e88f828281db7e810c0)
breaks model comparison on OLPC; the value 0xc2 needs to be scaled
up by olpc_board().  The pre-patch version was wrong, but accidentally
worked anyway (big-endian 0xc2 is big enough to satisfy all other
board revisions, but little endian 0xc2 is not).

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 arch/x86/kernel/olpc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 7a13fac..4006c52 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -203,7 +203,7 @@ static void __init platform_detect(void)
 static void __init platform_detect(void)
 {
 	/* stopgap until OFW support is added to the kernel */
-	olpc_platform_info.boardrev = 0xc2;
+	olpc_platform_info.boardrev = olpc_board(0xc2);
 }
 #endif
 
-- 
1.6.1.3
