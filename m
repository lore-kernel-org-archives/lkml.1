Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYAXMCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYAXMCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbYAXMB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:01:58 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56721 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752420AbYAXMB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:01:57 -0500
Date: Thu, 24 Jan 2008 13:01:40 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Ben Nizette <bn@niasdigital.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] Fix timerfd breakage on avr32 (was Re: [PATCH -mm] fix
 variable use in AVR32 pte_alloc_one)
Message-ID: <20080124130140.712044ab@dhcp-252-066.norway.atmel.com>
In-Reply-To: <4797CE96.3060702@niasdigital.com>
References: <47972BAE.70902@niasdigital.com>
	<20080123132010.266eccb8@dhcp-252-066.norway.atmel.com>
	<4797CE96.3060702@niasdigital.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008 10:32:38 +1100
Ben Nizette <bn@niasdigital.com> wrote:

> Haavard Skinnemoen wrote:
> > 
> > Hmm...I can't see anything like this on my current avr32-arch branch,
> > but I think I mistakenly pushed out some unfinished code about a week
> > ago and rewound it shortly afterwards. If Andrew pulled during that
> > window, I guess it must have made it into -mm :-(
> > 
> > But thanks for testing and for providing a fix. I'll check the code
> > that I was working on and apply the patch if it's still broken.
> >   
> 
> Cool, np.  FWIW I'm trying to get -mm to fly on AVR32 so I have access 
> to the latest gpiolib stuff.  Despite this patch and "[PATCH -mm] define 
> empty unxlate_dev_mem_ptr on AVR32" the build still fails due to some 
> timerfd syscall horkenation.  Shall look in to that this arvo too.

Hmm. Someone removed the timerfd() syscall...

---
 arch/avr32/kernel/syscall_table.S |    2 +-
 include/asm-avr32/unistd.h        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.24-rc8-mm1/arch/avr32/kernel/syscall_table.S
===================================================================
--- linux-2.6.24-rc8-mm1.orig/arch/avr32/kernel/syscall_table.S	2008-01-24 12:58:10.000000000 +0100
+++ linux-2.6.24-rc8-mm1/arch/avr32/kernel/syscall_table.S	2008-01-24 12:58:38.000000000 +0100
@@ -293,6 +293,6 @@ sys_call_table:
 	.long	sys_shmctl
 	.long	sys_utimensat
 	.long	sys_signalfd
-	.long	sys_timerfd		/* 280 */
+	.long	sys_ni_syscall		/* 280, was sys_timerfd */
 	.long	sys_eventfd
 	.long	sys_ni_syscall		/* r8 is saturated at nr_syscalls */
Index: linux-2.6.24-rc8-mm1/include/asm-avr32/unistd.h
===================================================================
--- linux-2.6.24-rc8-mm1.orig/include/asm-avr32/unistd.h	2008-01-24 12:58:48.000000000 +0100
+++ linux-2.6.24-rc8-mm1/include/asm-avr32/unistd.h	2008-01-24 12:59:25.000000000 +0100
@@ -297,7 +297,7 @@
 
 #define __NR_utimensat		278
 #define __NR_signalfd		279
-#define __NR_timerfd		280
+/* 280 was __NR_timerfd */
 #define __NR_eventfd		281
 
 #ifdef __KERNEL__
