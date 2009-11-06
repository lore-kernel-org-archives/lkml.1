Return-Path: <linux-kernel-owner+w=401wt.eu-S932638AbZKFWcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbZKFWcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932548AbZKFWcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:32:08 -0500
Received: from kroah.org ([198.145.64.141]:56997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533AbZKFWXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:15 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:47 2009
Message-Id: <20091106221547.437604054@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [63/99] KVM: get_tss_base_addr() should return a gpa_t
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=kvm-get_tss_base_addr-should-return-a-gpa_t.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Gleb Natapov <gleb@redhat.com>

commit abb3911965c1bd8eea305f64d4840a314259d96d upstream.

If TSS we are switching to resides in high memory task switch will fail
since address will be truncated. Windows2k3 does this sometimes when
running with more then 4G

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3762,7 +3762,7 @@ static int save_guest_segment_descriptor
 	return kvm_write_guest(vcpu->kvm, gpa, seg_desc, 8);
 }
 
-static u32 get_tss_base_addr(struct kvm_vcpu *vcpu,
+static gpa_t get_tss_base_addr(struct kvm_vcpu *vcpu,
 			     struct desc_struct *seg_desc)
 {
 	u32 base_addr;


