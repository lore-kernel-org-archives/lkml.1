Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbXLMHGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbXLMHGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762102AbXLMG4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55287 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762082AbXLMG4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:45 -0500
Date: Wed, 12 Dec 2007 22:52:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [patch 25/60] KVM: VMX: Force vm86 mode if setting flags during
	real mode
Message-ID: <20071213065212.GZ6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-vmx-force-vm86-mode-if-setting-flags-during-real-mode.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Avi Kivity <avi@qumranet.com>

patch 78f7826868da8e27d097802139a3fec39f47f3b8 in mainline.

When resetting from userspace, we need to handle the flags being cleared
even after we are in real mode.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/vmx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -463,6 +463,8 @@ static unsigned long vmx_get_rflags(stru
 
 static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
+	if (vcpu->rmode.active)
+		rflags |= IOPL_MASK | X86_EFLAGS_VM;
 	vmcs_writel(GUEST_RFLAGS, rflags);
 }
 

-- 
