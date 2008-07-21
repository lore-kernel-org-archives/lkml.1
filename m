Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbYGUGgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbYGUGgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYGUGgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:36:41 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:63446 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYGUGgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NL2sT10of6NGXjmVLLlMYQ2K8lsWCJLy+cHebbB6rNxys/iaA4KVJNPOQMwXZU3Vnv
         JbhUPGjdiQf0P2TiwY3wHw7yEz48kbmv/Eani6jo5M8VfVazhWv5l5urt14iAX0v+c29
         ojNpTFmDKuGh0Q2Z617RxfwvQyOHWSOJFg4Es=
Message-ID: <48842E71.9070503@gmail.com>
Date: Mon, 21 Jul 2008 03:36:33 -0300
From: "Rafael C. de Almeida" <almeidaraf@gmail.com>
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Samuel Sieb <samuel@sieb.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
References: <48841A92.4020301@sieb.net>
In-Reply-To: <48841A92.4020301@sieb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Sieb wrote:
> I have a computer here with a CPU that the BIOS identifies as:
> Cyrix MediaGXm/Cx5530 Unicorn Revision 1.19.3B
> 
> kernel 2.6.14 identifies it as:
> vendor_id    : Geode by NSC
> cpu family    : 5
> model        : 9
> model name    : Geode(TM) Integrated Processor by National Semi
> stepping    : 1
> 
> I can't boot any kernel later than 2.6.22 on it.  Anything later either
> hangs or gives random kernel panics while booting.  I tracked down the
> problem to a specific commit:
> 
> commit f25f64ed5bd3c2932493681bdfdb483ea707da0a
> Author: Juergen Beisert <juergen@kreuzholzen.de>
> Date:   Sun Jul 22 11:12:38 2007 +0200
> 
>     x86: Replace NSC/Cyrix specific chipset access macros by inlined
> functions.
> 
> Reversing the patch (compensating for kernel changes) let me boot a
> 2.6.25 kernel.  I realize the patch is supposed to fix something that
> didn't work right, but I didn't have a problem before and I do now. :-)
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I couldn't figure out what the problem was, but shouldn't ccr3 be
declared as u8 in the following file? After all, that's what setCx86
expects. I realise that it being u32 will do no harm here, but I thought
I should point it out.

diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c
b/arch/x86/kernel/cpu/mtrr/cyrix.c
index ff14c32..e7d9f7e 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -123,7 +123,7 @@ cyrix_get_free_region(unsigned long base, unsigned
long size, int replace_reg)
 }

 static u32 cr4 = 0;
-static u32 ccr3;
+static u8 ccr3;

 static void prepare_set(void)
 {
