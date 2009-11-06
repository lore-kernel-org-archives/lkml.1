Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZKFWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZKFWW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbZKFWWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:25 -0500
Received: from kroah.org ([198.145.64.141]:56643 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760073AbZKFWWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:23 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:39 2009
Message-Id: <20091106221539.777616263@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andre Przywara <andre.przywara@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [08/99] KVM: ignore reads from AMDs C1E enabled MSR
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=kvm-ignore-reads-from-amds-c1e-enabled-msr.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andre Przywara <andre.przywara@amd.com>

commit 1fdbd48c242db996107f72ae4140ffe8163e26a8 upstream.

If the Linux kernel detects an C1E capable AMD processor (K8 RevF and
higher), it will access a certain MSR on every attempt to go to halt.
Explicitly handle this read and return 0 to let KVM run a Linux guest
with the native AMD host CPU propagated to the guest.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -949,6 +949,7 @@ int kvm_get_msr_common(struct kvm_vcpu *
 	case MSR_P6_EVNTSEL0:
 	case MSR_P6_EVNTSEL1:
 	case MSR_K7_EVNTSEL0:
+	case MSR_K8_INT_PENDING_MSG:
 		data = 0;
 		break;
 	case MSR_MTRRcap:


