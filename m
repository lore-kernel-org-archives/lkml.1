Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYFYEmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYFYEmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbYFYEhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:25 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37448 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754639AbYFYEhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:17 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 29 of 36] Use __KERNEL_DS as SS when returning to a kernel
	thread (VERIFY)
X-Mercurial-Node: 6ecc6e21fb8715605896662bb51715343e199aa2
Message-Id: <6ecc6e21fb8715605896.1214367565@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    This is needed when the kernel is running on RING3, such as under Xen.
    x86_64 has a weird feature that makes it #GP on iret when SS is a null
    descriptor.

    This need to be tested on bare metal to make sure it doesn't cause any
    problems. AMD specs say SS is always ignored (except on iret?).

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -212,7 +212,7 @@
 	.macro FAKE_STACK_FRAME child_rip
 	/* push in order ss, rsp, eflags, cs, rip */
 	xorl %eax, %eax
-	pushq %rax /* ss */
+	pushq $__KERNEL_DS /* ss */
 	CFI_ADJUST_CFA_OFFSET	8
 	/*CFI_REL_OFFSET	ss,0*/
 	pushq %rax /* rsp */


