Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYKJPmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYKJPmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 10:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYKJPme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 10:42:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:59099 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbYKJPmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 10:42:32 -0500
Date: Mon, 10 Nov 2008 16:42:26 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-parisc@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] fix build error on hppa SMP (was Re: Linux 2.6.28-rc4)
Message-ID: <20081110154226.GA28675@tilt.dandreoli.com>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-parisc@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
References: <alpine.LFD.2.00.0811091650250.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811091650250.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 04:55:42PM -0800, Linus Torvalds wrote:
> 
> Rusty Russell (3):
>       cpumask: introduce new API, without changing anything
>       cpumask: new API, v2
>       cpumask: introduce new API, without changing anything, v3

Nothing to change here, go away! :)

---
From: Domenico Andreoli <cavok@dandreoli.com>
Date: Mon, 10 Nov 2008 16:31:07 +0100
Subject: [PATCH] fix build error on hppa SMP

Remove extern declaration of cpu_present_mask.

Fixes build error due to new cpumask API (2d3854a37e8b767a51aba38ed6d22817b0631e33).

Signed-off-by: Domenico Andreoli <cavok@dandreoli.com>
---
 arch/parisc/include/asm/smp.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/include/asm/smp.h b/arch/parisc/include/asm/smp.h
index 398cdba..409e698 100644
--- a/arch/parisc/include/asm/smp.h
+++ b/arch/parisc/include/asm/smp.h
@@ -44,8 +44,6 @@ extern void arch_send_call_function_ipi(cpumask_t mask);
  
 #define PROC_CHANGE_PENALTY	15		/* Schedule penalty */
 
-extern unsigned long cpu_present_mask;
-
 #define raw_smp_processor_id()	(current_thread_info()->cpu)
 
 #else /* CONFIG_SMP */
---

-----[ Domenico Andreoli, aka cavok
 --[ http://www.dandreoli.com/gpgkey.asc
   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
