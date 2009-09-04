Return-Path: <linux-kernel-owner+w=401wt.eu-S934099AbZIDUUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbZIDUUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934056AbZIDUUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:20:47 -0400
Received: from kroah.org ([198.145.64.141]:36161 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934009AbZIDUOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:53 2009
Message-Id: <20090904200852.974946650@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 18/48] KVM: add MC5_MISC msr read support
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-add-mc5_misc-msr-read-support.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

(cherry picked from commit a89c1ad270ca7ad0eec2667bc754362ce7b142be)

Currently KVM implements MC0-MC4_MISC read support. When booting Linux this
results in KVM warnings in the kernel log when the guest tries to read
MC5_MISC. Fix this warnings with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -752,6 +752,7 @@ int kvm_get_msr_common(struct kvm_vcpu *
 	case MSR_IA32_MC0_MISC+8:
 	case MSR_IA32_MC0_MISC+12:
 	case MSR_IA32_MC0_MISC+16:
+	case MSR_IA32_MC0_MISC+20:
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_EBL_CR_POWERON:
 		data = 0;


