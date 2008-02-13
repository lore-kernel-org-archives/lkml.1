Return-Path: <linux-kernel-owner+w=401wt.eu-S1762776AbYBMATr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762776AbYBMATr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764491AbYBMATU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:19:20 -0500
Received: from simmts5.bellnexxia.net ([206.47.199.163]:34957 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764966AbYBMATS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:19:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAALrGsUecIprE/2dsb2JhbAAIihGjNw
Message-ID: <47B2377C.3000207@gmail.com>
Date: Tue, 12 Feb 2008 20:19:08 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git-x86 mm branch compile error
References: <47B2366C.4020901@gmail.com>
In-Reply-To: <47B2366C.4020901@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:
>   CC      arch/x86/mm/pageattr.o
> arch/x86/mm/pageattr.c: In function ‘change_page_attr_set_clr’:
> arch/x86/mm/pageattr.c:778: error: incompatible type for argument 1 of
> ‘cpa_check_alias’
> make[1]: *** [arch/x86/mm/pageattr.o] Error 1
> make: *** [arch/x86/mm] Error 2
> 
> at tip 5248bbad9c72dd576aa8f3b44b5a959a7cae6ce1 x86: make
> DEBUG_PAGEALLOC & HIBERNATE work
> 
> 
> 

I assume the following is an acceptable fix (it will be completely
whitespace damaged due to thunderbird, but I think you get the idea)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index cf91149..76a3de5 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -729,7 +729,7 @@ cpa_check_alias(struct cpa_data *cpa, unsigned long
addr, int numpages)
 #else

 static int
-cpa_check_alias(struct cpa_data cpa, unsigned long addr, int numpages)
+cpa_check_alias(struct cpa_data *cpa, unsigned long addr, int numpages)
 {
        return 0;
 }
