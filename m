Return-Path: <linux-kernel-owner+w=401wt.eu-S1762347AbZENXAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347AbZENXAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbZENWm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:57 -0400
Received: from kroah.org ([198.145.64.141]:52676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522AbZENWmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:35 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:27 2009
Message-Id: <20090514223527.592941472@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:33:19 -0700
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
       alan@lxorguk.ukuu.org.uk, Avi Kivity <avi@redhat.com>
Subject: [patch 44/51] KVM: Make EFER reads safe when EFER does not exist
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=kvm-make-efer-reads-safe-when-efer-does-not-exist.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit e286e86e6d2042d67d09244aa0e05ffef75c9d54 upstream.

Some processors don't have EFER; don't oops if userspace wants us to
read EFER when we check NX.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1075,9 +1075,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *
 
 static int is_efer_nx(void)
 {
-	u64 efer;
+	unsigned long long efer = 0;
 
-	rdmsrl(MSR_EFER, efer);
+	rdmsrl_safe(MSR_EFER, &efer);
 	return efer & EFER_NX;
 }
 


