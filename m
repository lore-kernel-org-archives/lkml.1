Return-Path: <linux-kernel-owner+w=401wt.eu-S1758406AbZGCQZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406AbZGCQZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbZGCQZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:25:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47352 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756279AbZGCQZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:25:33 -0400
Date: Fri, 3 Jul 2009 17:26:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703172651.619162fd@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703155809.GA20121@elte.hu>
References: <20090703091655.GB3902@elte.hu>
	<20090703104459.1d9d0bbf@lxorguk.ukuu.org.uk>
	<20090703095432.GC21141@elte.hu>
	<20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	<20090703102234.GA32128@elte.hu>
	<20090703114431.37abd528@lxorguk.ukuu.org.uk>
	<20090703131727.GA3207@elte.hu>
	<20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	<20090703144754.GA13246@elte.hu>
	<20090703160230.093e422c@lxorguk.ukuu.org.uk>
	<20090703155809.GA20121@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another question: i'm wondering why you brought up Voyager support 
> here. Are you trying to insult me?

[and]

> Pointing out when your code is unclean does not count as an offense 
> on lkml, i hope

Nor then I trust does pointing out that voyager needs a bit of work ;)


I've no objection to pointing out unclean code (or to patches). If
someone wants to fix all the printk(KERN_ calls in the tty layer for for
it - great newbie project if a bit tedious I'd be delighted to receive the
patches.

I'm still however utterly incredulous that you'd look at that bit of
proposed code and see a formatting glitch but not that fact it couldn't
possibly work. I'm still glad you did look at it - don't get me wrong.

The way the tty layer work is done is like this and has been for almost
two years

	- Identify whats the next best thing to tackle on the giant pile
	  of sucky turd list
	- Rework it
	- Debug it
	- If it makes that piece of the code completeish whack the entire
	  file through the coding style process (eg
	  fe9cd962a62cb5f666cf48b9941d3f3cde134254,
	  fb100b6ea7bf8a95e52b90cc0dc0ea5744a0a40a etc)
	- Whines about > 80 characters get ignored
	  for text strings

That not only makes it easier to keep consistent internal styles, merge
patches without collision and keep code and style changes apart it means
that stuff gets cleaned up that doesn't otherwise change.

A good example of what happens if you don't is

scripts/checkpatch.pl --file arch/x86/kernel/cpu/mtrr/*c

where the core part of the code isn't changed very much even though the
interfaces completely get reworked. Thus it never gets cleaned up and
reviewed as a whole. The code works, will probably work for years but
never gets looked at as a whole and tidied.

Alan



