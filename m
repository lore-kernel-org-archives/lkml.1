Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYGMQwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYGMQwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 12:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYGMQwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 12:52:12 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61246 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752063AbYGMQwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 12:52:11 -0400
Date: Sun, 13 Jul 2008 17:51:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too
In-Reply-To: <20080713162804.GI1678@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.55.0807131737240.10630@cliff.in.clinika.pl>
References: <200807080141.05436.yhlu.kernel@gmail.com>
 <200807092017.51004.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com>
 <200807111841.55403.yhlu.kernel@gmail.com> <20080713010843.GD1678@linux-os.sc.intel.com>
 <86802c440807121904m1516b47am22a384a1e5868f68@mail.gmail.com>
 <20080713162804.GI1678@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, Suresh Siddha wrote:

> So we should probably have native_apic_mem_write_around() and use that
> in ack_APIC_irq() and for good apic it is native_apic_mem_write()
> and for !CONFIG_X86_GOOD_APIC, it is native_apic_mem_write_atomic()

 Why don't you simply define apic_write_around() correctly for your
platform? -- for 64-bit it is always the same as apic_write() as
X86_GOOD_APIC may only be cleared for the original Pentium processor, so
any unnecessary code for the opposite case will be optimised away at the
build time, whether you use a macro or an inline function.  Why do you
think you need to create more variations of this contraption which is a
workaround for a corner-case hw erratum anyway?

  Maciej
