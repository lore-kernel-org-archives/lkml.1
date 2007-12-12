Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbXLLTqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbXLLTqn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXLLTqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:46:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36859 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbXLLTqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:46:34 -0500
Date: Wed, 12 Dec 2007 19:46:02 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       RT <linux-rt-users@vger.kernel.org>, Daniel Walker <dwalker@mvista.com>,
       Remy Bohmer <linux@bohmer.net>
Subject: Re: [PATCH RT] Revert Softdisable for simple irqs.
Message-ID: <20071212194602.GB12913@flint.arm.linux.org.uk>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com> <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com> <1196176294.13982.58.camel@localhost.localdomain> <1196177122.23808.7.camel@imap.mvista.com> <1196178834.23808.11.camel@imap.mvista.com> <Pine.LNX.4.58.0712121436260.21795@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0712121436260.21795@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 02:40:09PM -0500, Steven Rostedt wrote:
> 
> In commit 76d2160147f43f982dfe881404cfde9fd0a9da21 lazy irq disabling
> was implemented, and the simple irq handler had a masking set to it.
> 
> Remy Bohmer discovered that some devices in the ARM architecture
> would trigger the mask, but never unmask it. His patch to do the
> unmasking was questioned by Russell King about masking simple irqs
> to begin with. Looking further, it was discovered that the problems
> Remy was seeing was due to improper use of the simple handler by
> devices, and he later submitted patches to fix those. But the issue
> that was uncovered was that the simple handler should never mask.
> 
> This patch reverts the masking in the simple handler.
> 
> [Note: This version is for the RT patch, and the IRQ_PENDING is needed
>  for threaded IRQs]
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks for submitting this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
