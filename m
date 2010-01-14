Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818Ab0ANXFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0ANXFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755832Ab0ANXFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:05:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:38597 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0ANXFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:05:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=CWt00giTYYKrgx3l96rHYl1+0xM9yI85ooYGUXd6vnZdj3o+32GDIHfCHUK3d2yynF
         spghVfKnSEgYbM0tbP9Z53MblAPPyy7Mssi6UlNzp99oXOOIs2gacfCyUIT8zdCKSp0d
         YVJbxUdSg0f1qEMJP8fwwUXlSZv/aHgogUp6w=
Message-ID: <4B4FA45B.8030009@gmail.com>
Date: Fri, 15 Jan 2010 00:10:19 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Hollis Blanchard <hollisb@us.ibm.com>, kvm-ppc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc/kvm: kvm_sregs->...sr[] were assigned twice in kvm_arch_vcpu_ioctl_get_sregs()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once is enough.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 3e294bd..85bb787 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -777,7 +777,6 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 	} else {
 		for (i = 0; i < 16; i++) {
 			sregs->u.s.ppc32.sr[i] = vcpu3s->sr[i].raw;
-			sregs->u.s.ppc32.sr[i] = vcpu3s->sr[i].raw;
 		}
 		for (i = 0; i < 8; i++) {
 			sregs->u.s.ppc32.ibat[i] = vcpu3s->ibat[i].raw;
