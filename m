Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZANIAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZANIAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbZANIAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:00:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbZANIAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:00:22 -0500
Date: Tue, 13 Jan 2009 23:59:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Reif <reif@earthlink.net>
Cc: David Miller <davem@davemloft.net>,
       "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: sparc32 compile error: redefinition of =?UTF-8?Q?=E2=80=98smp?=
 =?UTF-8?Q?=5Fcall=5Ffunction=5Fsingle=E2=80=99?=
Message-Id: <20090113235940.12d856d0.akpm@linux-foundation.org>
In-Reply-To: <496D5E19.7040802@earthlink.net>
References: <496D4274.6000304@earthlink.net>
	<20090113.181039.185575172.davem@davemloft.net>
	<20090113184239.e6b6e68e.akpm@linux-foundation.org>
	<20090113184536.95ebc973.akpm@linux-foundation.org>
	<496D5E19.7040802@earthlink.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 22:38:01 -0500 Robert Reif <reif@earthlink.net> wrote:

> This worked:
> 
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 2aebc4c..368227d 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -43,8 +43,10 @@ obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
>  ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
>  obj-y += smp.o
>  else
> +ifneq ($(CONFIG_SMP),y)
>  obj-y += up.o
>  endif
> +endif
>  obj-$(CONFIG_SMP) += spinlock.o
>  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
>  obj-$(CONFIG_PROVE_LOCKING) += spinlock.o

This all can be simplified, can't it?

obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
ifneq ($(CONFIG_SMP),y)
obj-y += up.o
endif

(someone please check my homework - I don't have a good track
record here ;))

--- a/kernel/Makefile~kernel-upc-omit-it-if-smp=y-use_generic_smp_helpers=n
+++ a/kernel/Makefile
@@ -40,9 +40,8 @@ obj-$(CONFIG_RT_MUTEXES) += rtmutex.o
 obj-$(CONFIG_DEBUG_RT_MUTEXES) += rtmutex-debug.o
 obj-$(CONFIG_RT_MUTEX_TESTER) += rtmutex-tester.o
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
-ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
-obj-y += smp.o
-else
+obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
+ifneq ($(CONFIG_SMP),y)
 obj-y += up.o
 endif
 obj-$(CONFIG_SMP) += spinlock.o
_

