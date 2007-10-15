Return-Path: <linux-kernel-owner+w=401wt.eu-S932970AbXJOSQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbXJOSQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986AbXJOSP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:15:57 -0400
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:33615 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbXJOSPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:15:55 -0400
Date: Mon, 15 Oct 2007 14:14:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RT: fix spin_trylock_irq
In-Reply-To: <1192470246.17527.15.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0710151406230.26495@gandalf.stny.rr.com>
References: <20071011142417.1d965820@bull.net> 
 <Pine.LNX.4.58.0710111046170.20114@gandalf.stny.rr.com>
 <1192470246.17527.15.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Mon, 15 Oct 2007, Daniel Walker wrote:
> > > +		_spin_trylock_irq, lock))
> > >
> > >  #define spin_trylock_irqsave(lock, flags) \
> > >  	__cond_lock(lock, PICK_SPIN_OP_RET(__spin_trylock_irqsave, 	\
> >
> > Thanks! Applied.
> >
> > Daniel, this BUG was introduced by your conversion to PICK_FUNCTION patch.
> > Please be more careful, and do an audit of your patch. (I don't have time
> > ATM). This could also be the source of other bugs I've been chasing.
> >
> > I might be pulling the PICK_FUNCTION patches if there's more bugs like
> > this.
>
> This is the second fix for this .. The first was in this email (over a
> month ago)
>
> http://lkml.org/lkml/2007/8/31/318

You're right I missed that. (I even read it). But for fixes like this, (or
any patches that are not in the tree), you really need to resend the
series.

When Ingo posts patches to LKML on CFS, if there's a little fix like this,
he'll add that to his next queue and repost.

>
> The above was emailed to Thomas, but I also sent you that link in IRC as
> a link of patches to include .. I'll be happy to audit my code better,
> but you should also audit your inclusion process better.. There have
> been too many missed patches, and too many double and triples fixes..

There wouldn't be if we didn't have to go looking for patches on patches
that are out of the series. If you see that a series is broken, don't
patch against it. Resend the series!

Patches must be against upstream, unless they are more RFC (like what
Gregory is doing). But when you want them to go upstream, they must be
against upstream.  I don't have the time to look for little fixes that
you've done to your own patches that have not been pulled in yet.

-- Steve

