Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZFIKWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZFIKWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760568AbZFIKSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:18:45 -0400
Received: from kroah.org ([198.145.64.141]:54613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760311AbZFIKSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:44 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:58 2009
Message-Id: <20090609094058.091815716@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:14 -0700
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
       alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 26/87] KVM: Make paravirt tlb flush also reload the PAE PDPTRs
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=kvm-make-paravirt-tlb-flush-also-reload-the-pae-pdptrs.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit a8cd0244e9cebcf9b358d24c7e7410062f3665cb upstream.

The paravirt tlb flush may be used not only to flush TLBs, but also
to reload the four page-directory-pointer-table entries, as it is used
as a replacement for reloading CR3.  Change the code to do the entire
CR3 reloading dance instead of simply flushing the TLB.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/mmu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2906,8 +2906,7 @@ static int kvm_pv_mmu_write(struct kvm_v
 
 static int kvm_pv_mmu_flush_tlb(struct kvm_vcpu *vcpu)
 {
-	kvm_x86_ops->tlb_flush(vcpu);
-	set_bit(KVM_REQ_MMU_SYNC, &vcpu->requests);
+	kvm_set_cr3(vcpu, vcpu->arch.cr3);
 	return 1;
 }
 


