Return-Path: <linux-kernel-owner+w=401wt.eu-S968340AbXJSWFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968340AbXJSWFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966611AbXJSWFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:05:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330AbXJSWFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:05:01 -0400
Date: Fri, 19 Oct 2007 15:04:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Git pull] arch/x86 updates
In-Reply-To: <alpine.LFD.0.9999.0710192334440.22770@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0710191459340.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0710192334440.22770@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2007, Thomas Gleixner wrote:
> 
> Pavel Emelyanov (1):
>       i386: consolidate show_regs and show_registers for i386

While I think this is good otherwise, why does it do

	printk(".. comm: %.*s .."
		TASK_COMM_LEN, current->comm,

instead of just using "%s" and "current->comm"? I only noticed because 
there was an unrelated conflict around that thing.

That "current->comm" had better be NUL-terminated already, we use it as 
such all over the place. And if it's not, *that* should be fixed.

I'm editing it back to the simpler pure string.

		Linus
