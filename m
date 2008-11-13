Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbYKMG3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbYKMG3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 01:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYKMG33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 01:29:29 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:42739 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYKMG32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 01:29:28 -0500
From: Mark Nelson <markn@au1.ibm.com>
Organization: IBM
To: Ingo Molnar <mingo@elte.hu>
Subject: commit "genirq: record trigger type" and powerpc
Date: Thu, 13 Nov 2008 17:30:11 +1100
User-Agent: KMail/1.9.9
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811131730.11506.markn@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I noticed that after commit 0c5d1eb77a8be917b638344a22afe1398236482b
(genirq: record trigger type), several of our powerpc platforms now
spew out warnings about "No set_type function for IRQ..." (in
particular our Cell blades). This is because in our generic platform
code we call set_irq_type() with information from the device tree
when we establish the interrupt mappings; but we do this regardless
of whether the PIC can actually set a type (it might irrelevant
because the type is essentially hardcoded or as in the case for Cell
the interrupts are just messages being past around that have no real
concept of type, or we could even be dealing with a virtual PIC as
on the PS3).

So, would it be possible to turn the:

	pr_warning("No set_type function... 

into a pr_debug() in kernel/irq/manage.c so when our users upgrade
to newer kernels they don't get scared by a whole bunch of new
warnings?

Many thanks!

Mark
