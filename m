Return-Path: <linux-kernel-owner+w=401wt.eu-S934346AbYETWYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934346AbYETWYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761333AbYETWYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:24:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760353AbYETWYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:24:11 -0400
Message-ID: <48334E24.7040102@redhat.com>
Date: Tue, 20 May 2008 18:18:12 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: [patch] x86: don't read maxlvt before checking if APIC is mapped
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: don't read maxlvt before checking if APIC is mapped

A check for unmapped apic was added before reading maxlvt but the early
read of maxlvt wasn't removed.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

Index: linux-2.6.25.noarch/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.25.noarch.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6.25.noarch/arch/x86/kernel/apic_64.c
@@ -524,7 +524,7 @@ int setup_profiling_timer(unsigned int m
  */
 void clear_local_APIC(void)
 {
-	int maxlvt = lapic_get_maxlvt();
+	int maxlvt;
 	u32 v;

 	/* APIC hasn't been mapped yet */
