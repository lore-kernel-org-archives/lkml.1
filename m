Return-Path: <linux-kernel-owner+w=401wt.eu-S1752967AbYIWOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbYIWOcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYIWOcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:32:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbYIWOcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:32:05 -0400
Date: Tue, 23 Sep 2008 16:31:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-parisc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH] Demultiplexing SIGTRAP signal -v2
Message-ID: <20080923143120.GD14041@elte.hu>
References: <200809221602.32616.srinivasa@in.ibm.com> <20080923112812.GL29021@elte.hu> <20080923113001.GA12531@elte.hu> <200809231955.01564.srinivasa@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231955.01564.srinivasa@in.ibm.com>
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


* Srinivasa Ds <srinivasa@in.ibm.com> wrote:

> > -tip testing found the following build error with the attached 
> > config:
> 
> Ingo, Reproduced build break issue with your config on tip tree. It 
> was a costly overlook to miss one header file. I included it in this 
> patch and tested it out.

thanks - applied the delta fix below to tip/core/signal.

	Ingo

--------------->
>From e8d3f455de4f42d4bab2f6f1aeb2cf3bd18eb508 Mon Sep 17 00:00:00 2001
From: Srinivasa Ds <srinivasa@in.ibm.com>
Date: Tue, 23 Sep 2008 15:23:52 +0530
Subject: [PATCH] signals: demultiplexing SIGTRAP signal, fix

fix build breakage, missing header file.

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/traps.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/traps.h b/include/asm-x86/traps.h
index 4b1e904..7a692ba 100644
--- a/include/asm-x86/traps.h
+++ b/include/asm-x86/traps.h
@@ -1,6 +1,8 @@
 #ifndef ASM_X86__TRAPS_H
 #define ASM_X86__TRAPS_H
 
+#include <asm/debugreg.h>
+
 /* Common in X86_32 and X86_64 */
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
