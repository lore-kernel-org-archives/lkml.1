Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZA1JgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZA1JgD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 04:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZA1Jfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 04:35:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbZA1Jfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 04:35:50 -0500
Date: Wed, 28 Jan 2009 01:35:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: steiner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 01/14] Add definitions of x86_64 GRU MMRs.
Message-Id: <20090128013527.005648cc.akpm@linux-foundation.org>
In-Reply-To: <20090122175025.475956000@sgi.com>
References: <20090122174917.563627000@sgi.com>
	<20090122175025.475956000@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 11:49:18 -0600 steiner@sgi.com wrote:

> Add definitions for x86_64 GRU MMRs.

Breaks x86_32:

arch/x86/include/asm/uv/uv_mmrs.h:409: error: width of 'real_time_cmpb' exceeds its type
arch/x86/include/asm/uv/uv_mmrs.h:425: error: width of 'real_time_cmpc' exceeds its type
arch/x86/include/asm/uv/uv_mmrs.h:441: error: width of 'real_time_cmpd' exceeds its type
arch/x86/include/asm/uv/uv_mmrs.h:491: error: width of 'address' exceeds its type
<etc>

due to stuff flike

	unsigned long	real_time_cmpb : 56;  /* RW */


this:

--- a/arch/x86/kernel/io_apic.c~a
+++ a/arch/x86/kernel/io_apic.c
@@ -59,8 +59,11 @@
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
+
+#ifdef CONFIG_X86_64
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
+#endif
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
_

seems sufficient, but perhaps it'd be better if it was done within the
header?

