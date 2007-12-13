Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbXLMNCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbXLMNCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbXLMNB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:01:58 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:58370 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXLMNB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:01:57 -0500
Date: Thu, 13 Dec 2007 08:00:38 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Remy Bohmer <linux@bohmer.net>,
       Daniel Walker <dwalker@mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert lazy irq disable for simple irqs
In-Reply-To: <20071213102259.GQ8977@elte.hu>
Message-ID: <Pine.LNX.4.58.0712130756060.27141@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0712121516400.22305@gandalf.stny.rr.com>
 <20071213102259.GQ8977@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Dec 2007, Ingo Molnar wrote:

>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > [This patch *is* for mainline Linux]
> >
> > In commit 76d2160147f43f982dfe881404cfde9fd0a9da21 lazy irq disabling
> > was implemented, and the simple irq handler had a masking set to it.

>
> thanks, applied. This is for v2.6.24 too, right?
>

Probably should be. The patch only reverts the change for
handle_simple_irq that shouldn't have been done in the first place. At
worse, this patch just takes us back to what handle_simple_irq use to do,
and at best, it prevents bugs where we somehow fall into the "mask" path
of handle_simple_irq and never unmask. But to hit that path, the driver
probably shouldn't be using handle_simple_irq ;-)

Thanks,

-- Steve

