Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbZCORra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbZCORra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 13:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbZCORrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 13:47:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:18021 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZCORrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 13:47:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=lukZr50gficsmjRdrVtw9aLZmgQCDx6LNz+P8LhnddN2lHjZYxrKi92Zqks4GZl8J7
         y/c5wtOCrMeLEZf9by4EYgHHgIekJp4MFXGkBump7WC2XJw33biFeZKBe1iDOgW1yPKm
         luKkWU66kdt529s7jxwMOaqCgjH2Pw4PE98K0=
Date: Sun, 15 Mar 2009 18:47:13 +0100
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: KMEMCHECK: linux-next: kernel BUG at
	arch/x86/mm/kmemcheck/kmemcheck.c:297!
Message-ID: <20090315174713.GA11207@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903110418.n2B4IU4q072339@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/11 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>:
> Hello.
>
> I encountered this.
>
> [    0.004000] ------------[ cut here ]------------
> [    0.004000] kernel BUG at arch/x86/mm/kmemcheck/kmemcheck.c:297!

Hi, thanks for this report!

I have a feeling that the following patch might fix it. Please try it out
only if you have the time. I will also try to reproduce it when I have the
time myself.


Vegard


diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6d63e3d..86f7398 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -146,7 +146,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	if (!after_bootmem)
 		init_gbpages();
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 	/*
 	 * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
 	 * This will simplify cpa(), which otherwise needs to support splitting
