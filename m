Return-Path: <linux-kernel-owner+w=401wt.eu-S937901AbZLHXtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937901AbZLHXtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:49:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937002AbZLHXs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:48:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35101 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936463AbZLHXs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:48:59 -0500
Date: Wed, 9 Dec 2009 10:49:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the powerpc tree with Linus' tree
Message-Id: <20091209104904.427eca89.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the powerpc tree got a conflict in
include/linux/kvm.h between commit
3cfc3092f40bc37c57ba556cfd8de4218f2135ab ("KVM: x86: Add
KVM_GET/SET_VCPU_EVENTS") (and others) from Linus' tree and commit
e15a113700324f7fdcee95589875daed2b98a2fe ("powerpc/kvm: Sync guest
visible MMU state") from the powerpc tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/kvm.h
index 2d241da,caf6173..0000000
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@@ -487,15 -436,9 +487,18 @@@ struct kvm_ioeventfd 
  #endif
  #define KVM_CAP_IOEVENTFD 36
  #define KVM_CAP_SET_IDENTITY_MAP_ADDR 37
 +#ifdef __KVM_HAVE_XEN_HVM
 +#define KVM_CAP_XEN_HVM 38
 +#endif
 +#define KVM_CAP_ADJUST_CLOCK 39
 +#define KVM_CAP_INTERNAL_ERROR_DATA 40
 +#ifdef __KVM_HAVE_VCPU_EVENTS
 +#define KVM_CAP_VCPU_EVENTS 41
 +#endif
 +#define KVM_CAP_S390_PSW 42
+ /* KVM upstream has more features, but we synched this number.
+    Linux, please remove this comment on rebase. */
+ #define KVM_CAP_PPC_SEGSTATE 43
  
  #ifdef KVM_CAP_IRQ_ROUTING
  
