Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbXCNRPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbXCNRPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbXCNRPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:15:19 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:38896 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbXCNRPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:15:16 -0400
Message-ID: <45F82CF3.3050904@free.fr>
Date: Wed, 14 Mar 2007 18:12:19 +0100
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: johnstul@us.ibm.com, mingo@elte.hu, zippel@linux-m68k.org,
       tglx@timesys.com, linux.kernel@free.fr
Subject: 2.6.20-rt8 patch tweaked for 2.6.20.3
Content-Type: multipart/mixed;
 boundary="------------000601000700040801040103"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000601000700040801040103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I've tweaked patch-2.6.20-rt8 so that it applies to 2.6.20.3

The unified diff is attached to this message.

I'd be happy to hear comments on what I've done wrong!

Regards.

--------------000601000700040801040103
Content-Type: text/plain;
 name="2.6.20-to-2.6.20.3-diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.20-to-2.6.20.3-diff"

--- patch-2.6.20-rt8	2007-02-16 10:48:03.000000000 +0100
+++ patch-2.6.20.3-rt8	2007-03-14 18:00:24.000000000 +0100
@@ -770,8 +770,8 @@
  VERSION = 2
  PATCHLEVEL = 6
  SUBLEVEL = 20
--EXTRAVERSION =
-+EXTRAVERSION = -rt8
+-EXTRAVERSION = .3
++EXTRAVERSION = .3-rt8
  NAME = Homicidal Dwarf Hamster
  
  # *DOCUMENTATION*
@@ -19927,15 +19927,6 @@
  unsigned long segment_base(u16 selector);
  
  void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes);
-@@ -558,7 +587,7 @@ static inline void load_gs(u16 sel)
- #ifndef load_ldt
- static inline void load_ldt(u16 sel)
- {
--	asm ("lldt %0" : : "g"(sel));
-+	asm ("lldt %0" : : "rm"(sel));
- }
- #endif
- 
 @@ -627,4 +656,6 @@ static inline u32 get_rdx_init_val(void)
  #define TSS_REDIRECTION_SIZE (256 / 8)
  #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
@@ -54910,9 +54901,9 @@
 --- linux.orig/kernel/time/clocksource.c
 +++ linux/kernel/time/clocksource.c
 @@ -28,6 +28,7 @@
- #include <linux/sysdev.h>
  #include <linux/init.h>
  #include <linux/module.h>
+ #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
 +#include <linux/tick.h>
  
  /* XXX - Would like a better way for initializing curr_clocksource */
@@ -66089,27 +66080,6 @@
  }
  
  /* When dgram socket disconnects (or changes its peer), we clear its receive
-Index: linux/net/xfrm/xfrm_user.c
-===================================================================
---- linux.orig/net/xfrm/xfrm_user.c
-+++ linux/net/xfrm/xfrm_user.c
-@@ -1273,13 +1273,12 @@ static int xfrm_get_policy(struct sk_buf
- 		xp = xfrm_policy_bysel_ctx(type, p->dir, &p->sel, tmp.security, delete);
- 		security_xfrm_policy_free(&tmp);
- 	}
--	if (delete)
--		xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
--			       AUDIT_MAC_IPSEC_DELSPD, (xp) ? 1 : 0, xp, NULL);
--
- 	if (xp == NULL)
- 		return -ENOENT;
- 
-+	xfrm_audit_log(NETLINK_CB(skb).loginuid, NETLINK_CB(skb).sid,
-+		       AUDIT_MAC_IPSEC_DELSPD, delete, xp, NULL);
-+
- 	if (!delete) {
- 		struct sk_buff *resp_skb;
- 
 Index: linux/scripts/Makefile
 ===================================================================
 --- linux.orig/scripts/Makefile

--------------000601000700040801040103--

