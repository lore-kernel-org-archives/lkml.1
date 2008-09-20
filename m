Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYITAox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYITAox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYITAoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:44:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:53643 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYITAop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:44:45 -0400
Date: Fri, 19 Sep 2008 17:44:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: sparse_irq: userspace ABI breakage in -tip tree
Message-ID: <20080919174447.2dd3015a@infradead.org>
In-Reply-To: <86802c440809191710o155fa870j9f1d9443896046fe@mail.gmail.com>
References: <20080919155321.1181638a@infradead.org>
	<86802c440809191710o155fa870j9f1d9443896046fe@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 17:10:42 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> On Fri, Sep 19, 2008 at 3:53 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> >
> > commit 70426a06a58561c401e64c5767d71a011d4b978b
> > Author: Yinghai Lu <yhlu.kernel@gmail.com>
> > Date:   Tue Aug 19 20:50:27 2008 -0700
> >
> >    x86: make 32 bit to use sparse_irq
> >
> > @@ -285,7 +303,7 @@ int show_interrupts(struct seq_file *p, void *v)
> >                action = desc->action;
> >                if (!action && !any_count)
> >                        goto skip;
> > -               seq_printf(p, "%3d: ",i);
> > +               seq_printf(p, "%#x: ",i);
> >  #ifndef CONFIG_SMP
> >                seq_printf(p, "%10u ", kstat_irqs(i));
> >  #else
> >
> >
> > this is a userspace ABI breakage; you're changing /proc/interrupts
> > from decimal to hex! This file is used by both humans and computer
> > programs, and the humans will get confused, but the computer
> > programs will break. Not a good idea to put into mainline.
> 
> change back to decimal could help?

that's a minimum; someone (you?) needs to check if there are other
things changed in the format of this file....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
