Return-Path: <linux-kernel-owner+w=401wt.eu-S1764966AbYD0XRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764966AbYD0XRP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763933AbYD0XQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:16:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35801 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765310AbYD0XQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:16:52 -0400
Date: Sun, 27 Apr 2008 16:11:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Breakage caused by unreviewed patch in x86 tree
Message-ID: <20080427161105.0b452fe4@laptopd505.fenrus.org>
In-Reply-To: <1209337439.3801.84.camel@localhost.localdomain>
References: <1209329485.3801.46.camel@localhost.localdomain>
	<20080427155803.73f0efcf@laptopd505.fenrus.org>
	<1209337439.3801.84.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 19:03:59 -0400
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Sun, 2008-04-27 at 15:58 -0700, Arjan van de Ven wrote:
> > On Sun, 27 Apr 2008 16:51:25 -0400
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > When you're mapping device memory, uncached is the safe default. 
> 
> Well, for certain device mailboxes, uncached does mean less
> performant. The voyager breakage was exceptional ... I expect other
> problems just to result in a loss of performance that caching gave by
> improving the bursting.  If we're lucky, the PCI bridge cache might
> hide a lot of this.

on a PC, NONE of the ioremap()s of PCI stuff were cached before, with the
exception of prefetchable ranges, that some bioses set up a write-combining MTRR for.
(and write-combining is effectively "uncached but with write buffering")

If you look at at what kind of devices have prefetchable ranges, you get two answers:
1) video cards
2) some IB adapters


So your argument that this might change PCI stuff is just false.

Your argument that this "99.9%->100% uncached" should have been announced/discussed
in public, sure. But to make this big a deal out of it?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
