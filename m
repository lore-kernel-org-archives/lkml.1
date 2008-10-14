Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYJNRUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYJNRUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYJNRUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:20:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbYJNRUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:20:23 -0400
Date: Tue, 14 Oct 2008 10:20:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/18] m68k: Disable Amiga serial console support if
 modular
In-Reply-To: <20081013195915.659336491@mail.of.borg>
Message-ID: <alpine.LFD.2.00.0810141018590.3288@nehalem.linux-foundation.org>
References: <20081013195846.674654386@mail.of.borg> <20081013195915.659336491@mail.of.borg>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, Geert Uytterhoeven wrote:
>
> Apparently console_initcall() is not defined in the modular case.

We can certainly fix that. 

Does this make things work for you? If so, send it back with a sign-off 
(add you can add mine too - but I'm not going to add it until it's tested)

		Linus
---
 include/linux/init.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 93538b6..d9625b5 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -273,6 +273,7 @@ void __init parse_early_param(void);
 #else /* MODULE */
 
 /* Don't use these in modules, but some people do... */
+#define console_initcall(fn)		module_init(fn)
 #define core_initcall(fn)		module_init(fn)
 #define postcore_initcall(fn)		module_init(fn)
 #define arch_initcall(fn)		module_init(fn)
