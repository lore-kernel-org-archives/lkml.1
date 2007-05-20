Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbXETQMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbXETQMP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 12:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXETQME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 12:12:04 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:33536 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891AbXETQMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 12:12:01 -0400
Date: Sun, 20 May 2007 18:12:00 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andi Kleen <ak@suse.de>,
       Rik van Riel <riel@redhat.com>, righiandr@users.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070520161159.GD22452@vanheusden.com>
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr> <200705181347.14256.ak@suse.de> <Pine.LNX.4.61.0705190946430.9015@yvahk01.tjqt.qr> <20070520001418.GJ14578@vanheusden.com> <464FC6AA.2060805@cosmosbay.com> <20070520112111.GN14578@vanheusden.com> <20070520090809.4f42d71d@freepuppy>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070520090809.4f42d71d@freepuppy>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Mon May 21 15:25:37 CEST 2007
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > >>>>I do not see such on i386, so why for x86_64?
> > > >>>So that you know that one of your programs crashed. That's a feature.
> > > >>This feature could be handy for i386 too.
> > > >Since 2.6.18.2 I use this patch. With 2.6.21.1 it still applies altough
> > > >with a small offsets. Works like a charm.
> > > >
> > > >Signed-off by: Folkert van Heusden <folkert@vanheusden.com>
> > > >--- linux-2.6.18.2/kernel/signal.c      2006-11-04 02:33:58.000000000 +0100
> > > >+++ linux-2.6.18.2.new/kernel/signal.c  2006-11-17 15:59:13.000000000 +0100
> > ...
> > > >+                       sig, t -> pid, t -> uid, t -> gid, t -> comm);
> > > 
> > > Please check line 219 of Documentation/CodingStyle, Section 3.1: Spaces
> > > 	and no space around the '.' and "->" structure member operators.
> > New version without the spaces around '->' and a nice 'unlikely' added. 
> > Signed-off by: Folkert van Heusden <folkert@vanheusden.com>
> > --- linux-2.6.18.2/kernel/signal.c	2006-11-04 02:33:58.000000000 +0100
> > +++ linux-2.6.18.2.new/kernel/signal.c	2006-11-17 15:59:13.000000000 +0100
> > @@ -706,6 +706,15 @@
> >  	struct sigqueue * q = NULL;
> >  	int ret = 0;
> >  
> > +	if (unlikely(sig == SIGQUIT || sig == SIGILL  || sig == SIGTRAP ||
> > +	    sig == SIGABRT || sig == SIGBUS  || sig == SIGFPE  ||
> > +	    sig == SIGSEGV || sig == SIGXCPU || sig == SIGXFSZ ||
> > +	    sig == SIGSYS  || sig == SIGSTKFLT))
> > +	{
> > +		printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
> > +			sig, t->pid, t->uid, t->gid, t->comm);
> > +	}
> > +
> >  	/*
> >  	 * fast-pathed signals for kernel-internal things like SIGSTOP
> >  	 * or SIGKILL.
> 
> Would turning that into a switch() generate better code.

Doubt it: in the worst case you still nee to check for each possibility.
Furthermore a.f.a.i.k. with switch you cannot do 'unlinkely()'.


Folkert van Heusden

-- 
MultiTail er et flexible tool for å kontrolere Logfiles og commandoer.
Med filtrer, farger, sammenføringer, forskeliger ansikter etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
