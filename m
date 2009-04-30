Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbZD3Rep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbZD3Rep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764599AbZD3RIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:22 -0400
Received: from kroah.org ([198.145.64.141]:56741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764652AbZD3RIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:08:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:47 2009
Message-Id: <20090430165747.291209348@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:49 -0700
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
       alan@lxorguk.ukuu.org.uk, Amit Shah <amit.shah@redhat.com>,
       mtosatti@redhat.com, avi@redhat.com
Subject: [patch 60/88] KVM: SVM: Set the busy flag of the TR selector
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=kvm-svm-set-the-busy-flag-of-the-tr-selector.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Shah <amit.shah@redhat.com>

(cherry picked from c0d09828c870f90c6bc72070ada281568f89c63b)

The busy flag of the TR selector is not set by the hardware. This breaks
migration from amd hosts to intel hosts.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/svm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -781,6 +781,13 @@ static void svm_get_segment(struct kvm_v
 	if (seg == VCPU_SREG_CS)
 		var->g = s->limit > 0xfffff;
 
+	/*
+	 * Work around a bug where the busy flag in the tr selector
+	 * isn't exposed
+	 */
+	if (seg == VCPU_SREG_TR)
+		var->type |= 0x2;
+
 	var->unusable = !var->present;
 }
 


