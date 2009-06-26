Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbZFZFX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbZFZFX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZFZFXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:23:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47717 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZFZFXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:23:47 -0400
Date: Fri, 26 Jun 2009 15:23:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?IkNocmlzdGlhbiBCb3JudHLDpGdlciI=?= 
	<christian@borntraeger.net>
Subject: [PATCH linux-next] kvm/powerpc: fix kvm build tree failure
Message-Id: <20090626152347.f87cfa4f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

In file included from include/trace/events/kvm.h:57,
                 from arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:63:
include/trace/define_trace.h:53:43: error: trace/events/TRACE_SYSTEM.h: No such file or directory

Caused by commit faa113b7c65c44ed94ac06f6bae2259290040856 ("KVM:
Protect irq tracing with KVM_HAVE_IOAPIC and KVM_HAVE_PIT").

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/trace/events/kvm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index dff68b3..5e69489 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -3,11 +3,11 @@
 
 #include <linux/tracepoint.h>
 
-#if defined(__KVM_HAVE_IOAPIC) && defined(__KVM_HAVE_PIT)
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
 #define TRACE_INCLUDE_FILE kvm
 
+#if defined(__KVM_HAVE_IOAPIC) && defined(__KVM_HAVE_PIT)
 TRACE_EVENT(kvm_set_irq,
 	TP_PROTO(unsigned int gsi),
 	TP_ARGS(gsi),
-- 
1.6.3.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
