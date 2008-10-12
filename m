Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYJLIKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYJLIKo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 04:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYJLIK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 04:10:29 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:38354 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbYJLIKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 04:10:24 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: when spin_lock_irq (as opposed to spin_lock_irqsave) is appropriate?
Date: Sun, 12 Oct 2008 10:08:50 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200810111929.01927.arvidjaar@mail.ru> <200810111741.53404.oliver@neukum.org> <200810111955.14667.arvidjaar@mail.ru>
In-Reply-To: <200810111955.14667.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810121008.50657.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 11. Oktober 2008 17:55:13 schrieb Andrey Borzenkov:
> On Saturday 11 October 2008, Oliver Neukum wrote:
> > Am Samstag, 11. Oktober 2008 17:29:01 schrieb Andrey Borzenkov:
> > > Logically, one piece of kernel code has no way to know whether another
> > > piece of kernel code (or may be hard-/firmware) has disabled some
> > > interrupt line. So it looks like spin_lock_irq should not even exist,
> > > except may be for very specific cases (where we are sure no other piece
> > > of kernel code may run concurrently)?
> > > 
> > > Sorry for stupid question, I an not actually a HW type of person ...
> > > 
> > 
> > This has no connection with individual irq lines. It's about being able
> > to sleep. Kernel code usually knows whether it can sleep.
> > If it knows to be able to sleep it can use spin_lock_irq() which is
> > more efficient than spin_lock_irqsave()
> > 
> 
> Sorry? I can't sleep under spinlock ... *any* spinlock? Or has this changed?

You cannot sleep under spinlock.

> May I be I was not clear with question. spin_lock_irq implies spin_unlock_irq,
> which unconditionally enables interrupts. But I have no idea which interrupts
> were disabled before spin_lock_irq; so I may accidentally enable too much?
> 
> Or what exactly "irq" in spin_(un-)lock_irq means?

I think I see the source of the problem. The interrupt controller is not
involved. The interrupts are masked in the cpu. This mask switches off
all interrupts (save nmi). When you unmask them again all interrupts
the interrupt controllers allow are active again. This is perfectly safe.

	HTH
		Oliver


