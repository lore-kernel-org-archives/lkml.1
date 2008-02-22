Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYBVPo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYBVPo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 10:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYBVPoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 10:44:17 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbYBVPoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 10:44:16 -0500
Date: Fri, 22 Feb 2008 07:43:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression [Was: Boot hang with stack protector on x86_64]
In-Reply-To: <20080222075950.GB2660@uranus.ravnborg.org>
Message-ID: <alpine.LFD.1.00.0802220739430.19896@woody.linux-foundation.org>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au> <20080222075950.GB2660@uranus.ravnborg.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Feb 2008, Sam Ravnborg wrote:
>
> This is a regression. Can you please revert this commit.

Not really. The thing is, CONFIG_CC_STACKPROTECTOR has never done anything 
at all, now it does, and it shows that it never worked.

So the commit that made it do something shouldn't be reverted, but 
CONFIG_CC_STACKPROTECTOR should be marked BROKEN, because it obviously is 
broken right now.

But keeping the config option, and just not making it do anything is 
misleading and wrong.

So just something like this? To make sure normal people don't enable it..

			Linus

---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3be2305..4a88cf7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1054,7 +1054,7 @@ config SECCOMP
 
 config CC_STACKPROTECTOR
 	bool "Enable -fstack-protector buffer overflow detection (EXPERIMENTAL)"
-	depends on X86_64 && EXPERIMENTAL
+	depends on X86_64 && EXPERIMENTAL && BROKEN
 	help
          This option turns on the -fstack-protector GCC feature. This
 	  feature puts, at the beginning of critical functions, a canary
