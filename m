Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbYAXVOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbYAXVOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbYAXVOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:14:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42159 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbYAXVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:14:32 -0500
Date: Thu, 24 Jan 2008 21:13:00 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       dhowells@redhat.com, jdike@addtoit.com, sam@ravnborg.org,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net
Subject: Re: [patch 02/26] Fix ARM to play nicely with generic Instrumentation menu
Message-ID: <20080124211259.GA10388@flint.arm.linux.org.uk>
References: <20080124202706.250598537@polymtl.ca> <20080124203333.128025422@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124203333.128025422@polymtl.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 03:27:08PM -0500, Mathieu Desnoyers wrote:
> The conflicting commit for 
> move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
> is the ARM fix from Linus :
> 
> commit 38ad9aebe70dc72df08851bbd1620d89329129ba

Since we have changes which depend on the location of these options,
please hold off until the ARM tree merges in the next window:

----------------------- arch/arm/Kconfig.instrumentation -----------------------
index 63b8c6d..453ad8e 100644
@@ -43,6 +43,16 @@ config OPROFILE_MPCORE
 config OPROFILE_ARM11_CORE
 	bool
 
+config KPROBES
+	bool "Kprobes"
+	depends on KALLSYMS && MODULES && !UML && !XIP_KERNEL
+	help
+	  Kprobes allows you to trap at almost any kernel address and
+	  execute a callback function.  register_kprobe() establishes
+	  a probepoint and specifies the callback.  Kprobes is useful
+	  for kernel debugging, non-intrusive instrumentation and testing.
+	  If in doubt, say "N".
+
 config MARKERS
 	bool "Activate markers"
 	help


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
