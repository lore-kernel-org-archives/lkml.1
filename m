Return-Path: <linux-kernel-owner+w=401wt.eu-S932888AbYD3Vjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbYD3Vjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbYD3Vj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:39:26 -0400
Received: from gw.goop.org ([64.81.55.164]:38515 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbYD3VjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:39:25 -0400
Message-ID: <4818E6FE.50607@goop.org>
Date: Wed, 30 Apr 2008 14:39:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 2/10] x86: convert to generic helpers for IPI function
 calls
References: <1209453990-7735-1-git-send-email-jens.axboe@oracle.com> <1209453990-7735-3-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1209453990-7735-3-git-send-email-jens.axboe@oracle.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> This converts x86, x86-64, and xen to use the new helpers for
> smp_call_function() and friends, and adds support for
> smp_call_function_single().
>   
Seems to work fine with this:

Subject: xen: build fix for generic IPI stuff

Not even one CONFIG_XEN test build?

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/smp.c           |    3 +--
 include/asm-x86/xen/events.h |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -43,8 +43,7 @@
 static DEFINE_PER_CPU(int, debug_irq) = -1;
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
-
-static struct call_data_struct *call_data;
+static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
 
 /*
  * Reschedule call back. Nothing to do,
===================================================================
--- a/include/asm-x86/xen/events.h
+++ b/include/asm-x86/xen/events.h
@@ -4,6 +4,7 @@
 enum ipi_vector {
 	XEN_RESCHEDULE_VECTOR,
 	XEN_CALL_FUNCTION_VECTOR,
+	XEN_CALL_FUNCTION_SINGLE_VECTOR,
 
 	XEN_NR_IPIS,
 };


