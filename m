Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbYBESr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbYBESr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbYBESrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:47:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757597AbYBESrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:47:35 -0500
Date: Tue, 5 Feb 2008 10:47:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
In-Reply-To: <20080204161219.GA8092@elte.hu>
Message-ID: <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org>
References: <20080204161219.GA8092@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo, Thomas,
 should we not do this?

Otherwise, it seems we generate a section that isn't allocated?

I think toolchain should add the right flags automatically for sections 
that start with ".[ro]data" and ".text", but not for the kernel-specific 
".init.*" sections.

		Linus

---
 arch/x86/kernel/head_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 4f283ad..d16d7b8 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -251,7 +251,7 @@ ENTRY(secondary_startup_64)
 
 	/* SMP bootup changes these two */
 #ifndef CONFIG_HOTPLUG_CPU
-	.pushsection .init.data
+	.pushsection .init.data,"aw"
 #endif
 	.align	8
 	.globl	initial_code
