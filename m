Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZBNVnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZBNVnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbZBNVni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:43:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49302 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754416AbZBNVnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:43:37 -0500
Date: Sat, 14 Feb 2009 22:43:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andres Salomon <dilinger@queued.net>
Cc: Chris Ball <cjb@laptop.org>, Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] olpc: fix model detection without OFW
Message-ID: <20090214214312.GB31928@elte.hu>
References: <1222208409.16003.25.camel@brick> <m3mycpye65.fsf@pullcord.laptop.org> <20090213231900.4f22008a@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213231900.4f22008a@ephemeral>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andres Salomon <dilinger@queued.net> wrote:

> As discussed on IRC, this has the Dilinger Seal Of Approval (tm).
> 
> Acked-by: Andres Salomon <dilinger@debian.org>

> On Fri, 13 Feb 2009 20:56:18 -0500
> Chris Ball <cjb@laptop.org> wrote:
> 
> > Harvey's endianness patch (e51a1ac2dfca9ad869471e88f828281db7e810c0)

> > breaks model comparison on OLPC; the value 0xc2 needs to be scaled
> > up by olpc_board().  The pre-patch version was wrong, but accidentally
> > worked anyway (big-endian 0xc2 is big enough to satisfy all other
> > board revisions, but little endian 0xc2 is not).
> > 
> > Signed-off-by: Chris Ball <cjb@laptop.org>

Applied to tip:x86/urgent [for v2.6.29], thanks guys!

Did i get the impact-line below right?

	Ingo

---------------->
>From 307250cda516547c0b0fe70dc3a3626bd82820cc Mon Sep 17 00:00:00 2001
From: Chris Ball <cjb@laptop.org>
Date: Fri, 13 Feb 2009 20:56:18 -0500
Subject: [PATCH] x86, olpc: fix model detection without OFW

Impact: make certain OLPC-board revision based quirks [mouse, sound] work properly

Harvey's endianness patch (e51a1ac2dfca9ad869471e88f828281db7e810c0)
breaks model comparison on OLPC; the value 0xc2 needs to be scaled
up by olpc_board().  The pre-patch version was wrong, but accidentally
worked anyway (big-endian 0xc2 is big enough to satisfy all other
board revisions, but little endian 0xc2 is not).

Signed-off-by: Chris Ball <cjb@laptop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
