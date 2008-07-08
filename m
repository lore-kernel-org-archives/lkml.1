Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbYGHXXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbYGHXXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbYGHXO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:59 -0400
Received: from gw.goop.org ([64.81.55.164]:51212 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081AbYGHXOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 39 of 55] xen64: add pvop for swapgs
X-Mercurial-Node: 9fc0718e0991931da4dd220bd37a695919760bfe
Message-Id: <9fc0718e0991931da4dd.1215554821@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swapgs is a no-op under Xen, because the hypervisor makes sure the
right version of %gs is current when switching between user and kernel
modes.  This means that the swapgs "implementation" can be inlined and
used when the stack is unsafe (usermode).  Unfortunately, it means
that disabling patching will result in a non-booting kernel...

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1076,6 +1076,9 @@
 	.set_iopl_mask = xen_set_iopl_mask,
 	.io_delay = xen_io_delay,
 
+	/* Xen takes care of %gs when switching to usermode for us */
+	.swapgs = paravirt_nop,
+
 	.lazy_mode = {
 		.enter = paravirt_enter_lazy_cpu,
 		.leave = xen_leave_lazy,


