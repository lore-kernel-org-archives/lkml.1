Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbZKWLwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbZKWLwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZKWLwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:52:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:55969 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252AbZKWLwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:52:37 -0500
Date: Mon, 23 Nov 2009 11:52:01 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B07A739.3030104@kernel.org>
References: <4B07A739.3030104@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Re-get cfg_new in case reuse/move irq_desc
Message-ID: <tip-37ef2a3029fde884808ff1b369677abc7dd9a79a@git.kernel.org>
Git-Commit-ID: 37ef2a3029fde884808ff1b369677abc7dd9a79a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37ef2a3029fde884808ff1b369677abc7dd9a79a
Gitweb:     http://git.kernel.org/tip/37ef2a3029fde884808ff1b369677abc7dd9a79a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 21 Nov 2009 00:23:37 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 09:56:05 +0100

x86: Re-get cfg_new in case reuse/move irq_desc

When irq_desc is moved, we need to make sure to use the right cfg_new.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4B07A739.3030104@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/io_apic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ff23719..085e60e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3186,6 +3186,7 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 			continue;
 
 		desc_new = move_irq_desc(desc_new, node);
+		cfg_new = desc_new->chip_data;
 
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
