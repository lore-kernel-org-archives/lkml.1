Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbZANCKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbZANCKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZANCKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:10:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48292
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbZANCKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:10:41 -0500
Date: Tue, 13 Jan 2009 18:10:39 -0800 (PST)
Message-Id: <20090113.181039.185575172.davem@davemloft.net>
To: reif@earthlink.net
Cc: sparclinux-owner@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: sparc32 compile error: redefinition of
 =?utf-8?B?4oCYc21wX2NhbGxfZnVuY3Rpb25fc2luZ2xl4oCZ?=
From: David Miller <davem@davemloft.net>
In-Reply-To: <496D4274.6000304@earthlink.net>
References: <496D4274.6000304@earthlink.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0E2AtwM005510

From: Robert Reif <reif@earthlink.net>
Date: Tue, 13 Jan 2009 20:40:04 -0500

> Todays git produces this compile error on sparc32:
> 
> kernel/up.c:10: error: redefinition of â€˜smp_call_function_singleâ€™
> /usr/src/sparc32/linux-2.6/arch/sparc/include/asm/smp_32.h:78: error: previous definition of â€˜smp_call_function_singleâ€™ was here

Andrew, are you sure that Makefile condition for compiling
up.o is correct?

ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
obj-y += smp.o
else
obj-y += up.o
endif

If an arch doesn't use generic SMP helpers, there is no way
we should compile up.c into the tree when SMP.

This build regression was caused by:

commit 53ce3d9564908794ae7dd32969089b57df5fc098
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Fri Jan 9 12:27:08 2009 -0800

    smp_call_function_single(): be slightly less stupid
    
    If you do
    
    	smp_call_function_single(expression-with-side-effects, ...)
    
    then expression-with-side-effects never gets evaluated on UP builds.
    
    As always, implementing it in C is the correct thing to do.
    
    While we're there, uninline it for size and possible header dependency
    reasons.
    
    And create a new kernel/up.c, as a place in which to put
    uniprocessor-specific code and storage.  It should mirror kernel/smp.c.
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
