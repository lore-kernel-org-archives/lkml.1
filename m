Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbZIEAVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbZIEAVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934637AbZIEAVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:12 -0400
Received: from kroah.org ([198.145.64.141]:42135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934605AbZIEAUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:51 2009
Message-Id: <20090905001451.601997092@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Amit Shah <amit.shah@redhat.com>, avi@redhat.com
Subject: [patch 27/71] KVM: Ignore reads to K7 EVNTSEL MSRs
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-ignore-reads-to-k7-evntsel-msrs.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Amit Shah <amit.shah@redhat.com>

(cherry picked from commit 9e6996240afcbe61682eab8eeaeb65c34333164d)

In commit 7fe29e0faacb650d31b9e9f538203a157bec821d we ignored the
reads to the P6 EVNTSEL MSRs. That fixed crashes on Intel machines.

Ignore the reads to K7 EVNTSEL MSRs as well to fix this on AMD
hosts.

This fixes Kaspersky antivirus crashing Windows guests on AMD hosts.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -900,6 +900,7 @@ int kvm_get_msr_common(struct kvm_vcpu *
 	case MSR_VM_HSAVE_PA:
 	case MSR_P6_EVNTSEL0:
 	case MSR_P6_EVNTSEL1:
+	case MSR_K7_EVNTSEL0:
 		data = 0;
 		break;
 	case MSR_MTRRcap:


