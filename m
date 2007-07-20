Return-Path: <linux-kernel-owner+w=401wt.eu-S934976AbXGTPOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934976AbXGTPOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933882AbXGTPOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:14:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934105AbXGTPOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:14:00 -0400
Subject: Re: [PATCH] Use descriptor's functions instead of inline assembly
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
In-Reply-To: <20070720142319.GA23448@slug>
References: <1184939761.16311.22.camel@t60>  <20070720142319.GA23448@slug>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 20 Jul 2007 12:14:48 -0300
Message-Id: <1184944488.16311.27.camel@t60>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 16:23 +0200, Frederik Deweerdt wrote:
> On Fri, Jul 20, 2007 at 10:56:01AM -0300, Glauber de Oliveira Costa wrote:
> > This patch provides a new set of functions for managing the descriptor
> > tables that can be used instead of putting the raw assembly in .c files.
> >     
> > Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> > 
> > -	asm volatile ("str %0"  : "=m" (ctxt->tr));
> > +	store_gdt((struct desc_ptr *)&ctxt->gdt_limit);
> > +	store_idt((struct desc_ptr *)&ctxt->idt_limit);
> > +	ctxt->tr = store_tr();
> > 
> Would'nt a store_tr(&ctxt->tr) be more homogeneous here?
Indeed, it would. The main reason I let it this way was to keep it closer to
the i386 paravirt code (which is the main reason I'm sending this
patches - to pave the way for the x86_64 one), but they seem to be
getting an argument for store_tr in current tree. So there's no arguable
advantage on doing it my way at all ;-)

Thanks

