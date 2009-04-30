Return-Path: <linux-kernel-owner+w=401wt.eu-S932449AbZD3Rds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbZD3Rds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764630AbZD3RIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:19 -0400
Received: from kroah.org ([198.145.64.141]:56697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764597AbZD3RIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:47 2009
Message-Id: <20090430165746.984307915@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com, avi@redhat.com,
       Sheng Yang <sheng@linux.intel.com>
Subject: [patch 58/88] KVM: VMX: Move private memory slot position
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-vmx-move-private-memory-slot-position.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sheng Yang <sheng@linux.intel.com>

(cherry picked from 6fe639792c7b8e462baeaac39ecc33541fd5da6e)

PCI device assignment would map guest MMIO spaces as separate slot, so it is
possible that the device has more than 2 MMIO spaces and overwrite current
private memslot.

The patch move private memory slot to the top of userspace visible memory slots.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/vmx.c |    2 +-
 arch/x86/kvm/vmx.h |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2407,7 +2407,7 @@ static int vmx_set_tss_addr(struct kvm *
 {
 	int ret;
 	struct kvm_userspace_memory_region tss_mem = {
-		.slot = 8,
+		.slot = TSS_PRIVATE_MEMSLOT,
 		.guest_phys_addr = addr,
 		.memory_size = PAGE_SIZE * 3,
 		.flags = 0,
--- a/arch/x86/kvm/vmx.h
+++ b/arch/x86/kvm/vmx.h
@@ -331,8 +331,9 @@ enum vmcs_field {
 
 #define AR_RESERVD_MASK 0xfffe0f00
 
-#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	9
-#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	10
+#define TSS_PRIVATE_MEMSLOT			(KVM_MEMORY_SLOTS + 0)
+#define APIC_ACCESS_PAGE_PRIVATE_MEMSLOT	(KVM_MEMORY_SLOTS + 1)
+#define IDENTITY_PAGETABLE_PRIVATE_MEMSLOT	(KVM_MEMORY_SLOTS + 2)
 
 #define VMX_NR_VPIDS				(1 << 16)
 #define VMX_VPID_EXTENT_SINGLE_CONTEXT		1


