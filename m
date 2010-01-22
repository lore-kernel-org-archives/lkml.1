Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377Ab0AVEGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0AVEGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966Ab0AVEGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:06:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:59566 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab0AVEGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:06:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,322,1262592000"; 
   d="scan'208";a="589404557"
Date: Fri, 22 Jan 2010 12:06:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
       "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] x86: remove bios data range from e820
Message-ID: <20100122040608.GA23319@localhost>
References: <20100122032102.137106635@intel.com> <20100122033004.335813103@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100122033004.335813103@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 07:21:04PM -0800, Wu, Fengguang wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> To prepare move page_is_ram() as generic one.

Yinghai,

The following two chunks cannot apply because the lines they remove
don't exist in linux-next. Because this patchset is targeted for
2.6.34, I just remove the chunks.

===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -29,8 +29,6 @@ static void __init i386_default_early_se
 
 void __init i386_start_kernel(void)
 {
-       reserve_early_overlap_ok(0, PAGE_SIZE, "BIOS data page");
-
 #ifdef CONFIG_X86_TRAMPOLINE
        /*
         * But first pinch a few for the stack/trampoline stuff
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -98,8 +98,6 @@ void __init x86_64_start_reservations(ch
 {
        copy_bootdata(__va(real_mode_data));
 
-       reserve_early_overlap_ok(0, PAGE_SIZE, "BIOS data page");
-
        reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD

Thanks,
Fengguang
