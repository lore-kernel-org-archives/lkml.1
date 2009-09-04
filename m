Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbZIDUOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbZIDUOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933989AbZIDUOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:19 -0400
Received: from kroah.org ([198.145.64.141]:36117 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933977AbZIDUOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:51 2009
Message-Id: <20090904200851.000111021@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 07/48] KVM: VMX: Change segment dpl at reset to 3
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-change-segment-dpl-at-reset-to-3.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@qumranet.com>

(cherry picked from commit a16b20da879430fdf245ed45461ed40ffef8db3c)

This is more emulation friendly, if not 100% correct.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1789,7 +1789,7 @@ static void seg_setup(int seg)
 	vmcs_write16(sf->selector, 0);
 	vmcs_writel(sf->base, 0);
 	vmcs_write32(sf->limit, 0xffff);
-	vmcs_write32(sf->ar_bytes, 0x93);
+	vmcs_write32(sf->ar_bytes, 0xf3);
 }
 
 static int alloc_apic_access_page(struct kvm *kvm)


