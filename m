Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZHBTlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZHBTlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZHBTlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:41:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbZHBTlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:41:12 -0400
Date: Sun, 2 Aug 2009 12:39:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: paulmck@linux.vnet.ibm.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/debug] debug lockups: Improve lockup detection
Message-Id: <20090802123958.cbd497a0.akpm@linux-foundation.org>
In-Reply-To: <20090802192657.GA21882@elte.hu>
References: <tip-c1dc0b9c0c8979ce4d411caadff5c0d79dee58bc@git.kernel.org>
	<20090802114545.f1520c81.akpm@linux-foundation.org>
	<20090802192657.GA21882@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009 21:26:57 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> > I think this just broke all non-x86 non-sparc SMP architectures.
> 
> Yeah - it 'broke' them in the sense of them not having a working 
> trigger_all_cpu_backtrace() implementation to begin with.

c'mon.  It broke them in the sense that sysrq-l went from "works" to
"doesn't work".

It would take months for the relevant arch maintainers to even find out
about this, after which they're left with dud kernels out in the field.

It's better to break the build or to emit warnings than to silently and
secretly break their stuff.


--- a/include/linux/nmi.h~a
+++ a/include/linux/nmi.h
@@ -29,6 +29,9 @@ static inline void acpi_nmi_enable(void)
 #endif
 
 #ifndef trigger_all_cpu_backtrace
+#ifdef CONFIG_SMP
+#warning This architecture is missing a trigger_all_cpu_backtrace() implementation
+#endif
 #define trigger_all_cpu_backtrace() do { } while (0)
 #endif
 
_

