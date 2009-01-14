Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZANCnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZANCnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 21:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZANCnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 21:43:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbZANCnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 21:43:04 -0500
Date: Tue, 13 Jan 2009 18:42:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: reif@earthlink.net, sparclinux-owner@vger.kernel.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: sparc32 compile error: redefinition of =?UTF-8?Q?=E2=80=98smp?=
 =?UTF-8?Q?=5Fcall=5Ffunction=5Fsingle=E2=80=99?=
Message-Id: <20090113184239.e6b6e68e.akpm@linux-foundation.org>
In-Reply-To: <20090113.181039.185575172.davem@davemloft.net>
References: <496D4274.6000304@earthlink.net>
	<20090113.181039.185575172.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 18:10:39 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: Robert Reif <reif@earthlink.net>
> Date: Tue, 13 Jan 2009 20:40:04 -0500
> 
> > Todays git produces this compile error on sparc32:
> > 
> > kernel/up.c:10: error: redefinition of ___smp_call_function_single___
> > /usr/src/sparc32/linux-2.6/arch/sparc/include/asm/smp_32.h:78: error: previous definition of ___smp_call_function_single___ was here
> 
> Andrew, are you sure that Makefile condition for compiling
> up.o is correct?

you give me grounds for now being ;)

> ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
> obj-y += smp.o
> else
> obj-y += up.o
> endif
> 
> If an arch doesn't use generic SMP helpers, there is no way
> we should compile up.c into the tree when SMP.
> 

How's about this?

--- a/kernel/Makefile~a
+++ a/kernel/Makefile
@@ -43,7 +43,7 @@ obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
 obj-y += smp.o
 else
-obj-y += up.o
+obj-$(CONFIG_SMP) += up.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
 obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
_

