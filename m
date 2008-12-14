Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYLNINV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYLNINV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYLNIHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59919 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYLNIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:15 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 05/36] KVM: Prevent trace call into unloaded module text
Date: Sun, 14 Dec 2008 10:06:38 +0200
Message-Id: <1229242029-13410-6-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>

Add marker_synchronize_unregister() before module unloading.
This prevents possible trace calls into unloaded module text.

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_trace.c b/virt/kvm/kvm_trace.c
index 41dcc84..f598744 100644
--- a/virt/kvm/kvm_trace.c
+++ b/virt/kvm/kvm_trace.c
@@ -252,6 +252,7 @@ void kvm_trace_cleanup(void)
 			struct kvm_trace_probe *p = &kvm_trace_probes[i];
 			marker_probe_unregister(p->name, p->probe_func, p);
 		}
+		marker_synchronize_unregister();
 
 		relay_close(kt->rchan);
 		debugfs_remove(kt->lost_file);
-- 
1.6.0.3

