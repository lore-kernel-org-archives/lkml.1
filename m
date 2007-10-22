Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbXJVUCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbXJVUCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbXJVUCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:02:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489AbXJVUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:02:43 -0400
Date: Mon, 22 Oct 2007 13:02:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: matthew@wil.cx, arnd@arndb.de, ralf@linux-mips.org, adobriyan@gmail.com,
       viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Message-Id: <20071022130223.f7d75c31.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710221254550.30120@woody.linux-foundation.org>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru>
	<20071022152912.GA841@linux-mips.org>
	<20071022112110.105b8e11.akpm@linux-foundation.org>
	<200710222110.34768.arnd@arndb.de>
	<20071022194714.GI27248@parisc-linux.org>
	<alpine.LFD.0.999.0710221254550.30120@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 12:56:29 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 22 Oct 2007, Matthew Wilcox wrote:
> > 
> > We certainly don't want to encourage people to blindly make those
> > conversions ... and I've seen the results of encouraging kernel janitors
> > to do things a certain way.
> 
> There's another issue: the "irqsave/irqrestore" versions are much safer 
> than the plain "irq" versions, in case the caller already has interrupts 
> disabled. 
> 
> So anybody making the change not only would need to make the performance 
> argument, he'd better not be a janitor that blindly does the change 
> without thinking about all call-sites etc..
> 

It's almost always a bug to do spin_lock_irq() when local interrupts are
disabled.  However iirc when we've tried to add runtime debugging to catch
that, it triggered false-positives which made the idea unworkable.  I forget
where.

However what we could do is to add a new
spin_lock_irq_tell_me_if_i_goofed() which would perform that runtime check.

