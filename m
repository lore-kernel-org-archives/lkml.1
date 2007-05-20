Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbXETQK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbXETQK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759742AbXETQKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:10:09 -0400
Received: from smtp.osdl.org ([207.189.120.12]:41432 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759594AbXETQKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:10:06 -0400
Date: Sun, 20 May 2007 09:08:09 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andi Kleen <ak@suse.de>,
       Rik van Riel <riel@redhat.com>, righiandr@users.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070520090809.4f42d71d@freepuppy>
In-Reply-To: <20070520112111.GN14578@vanheusden.com>
References: <464C81B5.8070101@users.sourceforge.net>
	<464C9D82.60105@redhat.com>
	<Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr>
	<200705181347.14256.ak@suse.de>
	<Pine.LNX.4.61.0705190946430.9015@yvahk01.tjqt.qr>
	<20070520001418.GJ14578@vanheusden.com>
	<464FC6AA.2060805@cosmosbay.com>
	<20070520112111.GN14578@vanheusden.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 13:21:11 +0200
Folkert van Heusden <folkert@vanheusden.com> wrote:

> > >>>>I do not see such on i386, so why for x86_64?
> > >>>So that you know that one of your programs crashed. That's a feature.
> > >>This feature could be handy for i386 too.
> > >Since 2.6.18.2 I use this patch. With 2.6.21.1 it still applies altough
> > >with a small offsets. Works like a charm.
> > >
> > >Signed-off by: Folkert van Heusden <folkert@vanheusden.com>
> > >--- linux-2.6.18.2/kernel/signal.c      2006-11-04 02:33:58.000000000 +0100
> > >+++ linux-2.6.18.2.new/kernel/signal.c  2006-11-17 15:59:13.000000000 +0100
> ...
> > >+                       sig, t -> pid, t -> uid, t -> gid, t -> comm);
> > 
> > Please check line 219 of Documentation/CodingStyle, Section 3.1: Spaces
> > 	and no space around the '.' and "->" structure member operators.
> 
> New version without the spaces around '->' and a nice 'unlikely' added. 
> 
> Signed-off by: Folkert van Heusden <folkert@vanheusden.com>
> 
> --- linux-2.6.18.2/kernel/signal.c	2006-11-04 02:33:58.000000000 +0100
> +++ linux-2.6.18.2.new/kernel/signal.c	2006-11-17 15:59:13.000000000 +0100
> @@ -706,6 +706,15 @@
>  	struct sigqueue * q = NULL;
>  	int ret = 0;
>  
> +	if (unlikely(sig == SIGQUIT || sig == SIGILL  || sig == SIGTRAP ||
> +	    sig == SIGABRT || sig == SIGBUS  || sig == SIGFPE  ||
> +	    sig == SIGSEGV || sig == SIGXCPU || sig == SIGXFSZ ||
> +	    sig == SIGSYS  || sig == SIGSTKFLT))
> +	{
> +		printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
> +			sig, t->pid, t->uid, t->gid, t->comm);
> +	}
> +
>  	/*
>  	 * fast-pathed signals for kernel-internal things like SIGSTOP
>  	 * or SIGKILL.
> 
> 
> Folkert van Heusden
> 

Would turning that into a switch() generate better code.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
