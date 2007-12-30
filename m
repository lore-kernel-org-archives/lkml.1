Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbXL3Um3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbXL3Um3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXL3UmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:42:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59530 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbXL3UmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:42:20 -0500
Date: Sun, 30 Dec 2007 21:34:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230203417.GA12949@elte.hu>
References: <477711DC.5030800@keyaccess.nl> <alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org> <20071230144700.78f4605c@the-village.bc.nu> <20071230152835.GX16946@elte.hu> <4777BDA5.4050203@keyaccess.nl> <alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0712301009220.32517@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So even if that "port 80" access will also cause PCI postings to be 
> flushed, so would the actual IO access that accompanies it, so I don't 
> think that is a very strong argument.
> 
> With all that said: it is certainly possible that the 1us timing makes 
> a difference on some machine, and it is certainly *also* theoretically 
> possible that there is a buggy chipset that posts too much, and the 
> port 80 access might make a difference, but it's not all that likely, 
> and I suspect we'd be better off handling those devices/drivers on a 
> one-by-one basis as we find them.

yeah, wholeheartedly agreed, and this is what x86.git is heading 
towards. All test feedback so far is positive. With strong tools like 
bisection there's no reason why we couldnt approach it this way. If this 
change breaks anything, it will be bisected down to the patch below. In 
fact even io_delay=udelay would be wrong because any problem will be 
less clearly triggerable and thus less bisectable/debuggable.

	Ingo

----------------------->
Subject: x86: make io_delay=none the default
From: Ingo Molnar <mingo@elte.hu>

make io_delay=none the default. This is the first step towards removing 
all the legacy io-delay API uses.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/Kconfig.debug
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig.debug
+++ linux-x86.q/arch/x86/Kconfig.debug
@@ -133,7 +133,7 @@ config IO_DELAY_TYPE_NONE
 
 choice
 	prompt "IO delay type"
-	default IO_DELAY_0X80
+	default IO_DELAY_NONE
 
 config IO_DELAY_0X80
 	bool "port 0x80 based port-IO delay [recommended]"
