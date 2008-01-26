Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbYAZQaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbYAZQaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYAZQaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:30:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35728 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbYAZQai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:30:38 -0500
Date: Sat, 26 Jan 2008 08:30:19 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86.git] new CPA implementation
Message-ID: <20080126083019.6b280d6c@laptopd505.fenrus.org>
In-Reply-To: <p73myqu7yc9.fsf@bingen.suse.de>
References: <20080125002401.GA31745@elte.hu>
	<200801250901.48422.ak@novell.com>
	<20080125133015.GA29040@elte.hu>
	<p73myqu7yc9.fsf@bingen.suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2008 15:51:18 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Andi Kleen <ak@novell.com> wrote:
> >
> >> > - the new implementation is much more scalable, because it is 
> >> > lockless
> >> >   in the fastpath
> >> 
> >> What fast path?  This should not really be called that often, 
> >> especially not when DEBUG_PAGEALLOC has its own simple
> >> implementation.
> 
> > that's a point you are still missing badly in all these discussions 
> > about unification and sound design practices: code reuse and a
> > clean, layered design.
> 
> kernel_map_pages does its own thing for flushes. I must admit I always
> considered that abuse because it gives a somewhat fragile special case
> where c_p_a() is not allowed to set up any state for g_f_t() for some
> specific cases. Clean layering looks different to me.
> 
> > PAGEALLOC now uses change_page_attr() again and that 
> > approach is working really well.
> 
> I don't really see any attempt to stop the
> 
> allocation -> kernel_map_pages -> split -> allocation ->
> kernel_map_pages -> other split -> allocation -> ....
> 

but.. if you start out with everything not split, and only split on free....
well arguably that's the same thing yeah.. but it could be done such that you can use the
page you just freed for the split ;-)
