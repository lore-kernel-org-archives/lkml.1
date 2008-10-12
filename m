Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbYJLXMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbYJLXMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 19:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYJLXMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 19:12:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:44705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbYJLXMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 19:12:14 -0400
Date: Sun, 12 Oct 2008 19:12:11 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Oliver Neukum <oliver@neukum.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: when spin_lock_irq (as opposed to spin_lock_irqsave) is
 appropriate?
Message-ID: <20081012191211.0327110f@infradead.org>
In-Reply-To: <200810121548.05644.arvidjaar@mail.ru>
References: <200810111929.01927.arvidjaar@mail.ru>
	<20081011091806.2c8eb2d4@infradead.org>
	<200810121548.05644.arvidjaar@mail.ru>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008 15:48:00 +0400
Andrey Borzenkov <arvidjaar@mail.ru> wrote:

> On Saturday 11 October 2008, Arjan van de Ven wrote:
> [... very useful explanation omitted ...]
> > Does this answer your question?
> > 
> 
> As Oliver pointed out, part of confusion wa my asumption that _irqsave
> verion saves actual interrupt mask. It actually does not.
> 
> This leaves me with a question - how can I know whether interrupts may
> (not) be disabled at particular point? 

the _irq versions mask the interrupts in the *cpu*!
Not in the hw.
All CPUs have a flag that says "don't give me interrupts right now
please", and the spin_lock_irq(save) functions work on that flag.
And they block all interrupts (except NMI's, which are very special)

> In particular, is it safe to 
> assume that any place marked at "code may sleep" has interrupts
> enabled?

yes.
That's a good rule of thumb ;-)
Anything else is a lot of "depends"



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
