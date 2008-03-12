Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbYCLHo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbYCLHo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYCLHoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:44:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbYCLHoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:44:17 -0400
Date: Wed, 12 Mar 2008 00:44:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: 2.6.25-rc5-mm1: NO_HZ=Y && PREEMPT_RCU=Y fails to build
Message-Id: <20080312004413.079d9b04.akpm@linux-foundation.org>
In-Reply-To: <47D78485.3030104@free.fr>
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
	<47D78485.3030104@free.fr>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008 08:21:41 +0100 Laurent Riffard <laurent.riffard@free.fr> wrote:

> Le 11.03.2008 09:14, Andrew Morton a __crit :
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
> > 
> 
> The kernel won't build if CONFIG_NO_HZ=y and CONFIG_PREEMPT_RCU=y:
> 
> $ grep -e PREEMPT -e HZ .config
> CONFIG_NO_HZ=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_RCU=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_DEBUG_PREEMPT=y
> $
> $ make
> ...
>   CC      init/main.o
> In file included from include/linux/rcupdate.h:60,
>                  from include/linux/rculist.h:11,
>                  from include/linux/dcache.h:9,
>                  from include/linux/fs.h:279,
>                  from include/linux/proc_fs.h:6,
>                  from init/main.c:15:
> include/linux/rcupreempt.h: In function 'rcu_enter_nohz':
> include/linux/rcupreempt.h:91: error: 'HZ' undeclared (first use in this function)
> include/linux/rcupreempt.h:91: error: (Each undeclared identifier is reported only once
> include/linux/rcupreempt.h:91: error: for each function it appears in.)
> include/linux/rcupreempt.h: In function 'rcu_exit_nohz':
> include/linux/rcupreempt.h:99: error: 'HZ' undeclared (first use in this function)

hm, it works OK for me, but I don't have your full config.

This, I guess:

--- a/include/asm-generic/bug.h~add-warn_on_secs-macro-fix-fix
+++ a/include/asm-generic/bug.h
@@ -2,7 +2,7 @@
 #define _ASM_GENERIC_BUG_H
 
 #include <linux/compiler.h>
-
+#include <linux/param.h>
 
 #ifdef CONFIG_BUG
 
_

