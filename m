Return-Path: <linux-kernel-owner+w=401wt.eu-S1764098AbXGVUGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764098AbXGVUGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762070AbXGVUG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:06:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762022AbXGVUG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:06:27 -0400
Date: Sun, 22 Jul 2007 21:06:12 +0100
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: New wake ups from sky2
Message-ID: <20070722210612.1fa32740@oldman>
In-Reply-To: <46A1CB36.5010609@m3y3r.de>
References: <46A10CC3.6050909@m3y3r.de>
	<20070720225038.7635da3f@oldman>
	<46A1CB36.5010609@m3y3r.de>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 11:00:38 +0200
Thomas Meyer <thomas@m3y3r.de> wrote:

> Stephen Hemminger schrieb:
> > Thomas Meyer <thomas@m3y3r.de> wrote:
> >
> >   
> >> Today i did a git pull to be up to date again and i noticed in the
> >> powertop tool that i'll get this new entry
> >>
> >>   14,2% (  9,1)     <kernel core> : sky2_probe (sky2_idle)
> >>
> >> with around 10 interrupts per second.
> >>
> >> i think (i.e. i don't know and just guessing!) this commit is
> >> responsible for these wake ups:
> >>
> >> git show eb35cf60e462491249166182e3e755d3d5d91a28
> >>
> >> Author: Stephen Hemminger <shemminger@osdl.org>
> >> Date:   Tue Jun 13 17:17:31 2006 +0900
> >>
> >>     [PATCH] sky2: stop/start hardware idle timer on suspend/resume
> >>
> >>     The resume bug was caused not by an early interrupt but because the idle
> >>     timeout was not being stopped on suspend.  Also disable hardware IRQ's
> >>     on suspend.  Will need to revisit this with hotplug?
> >>
> >>     Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
> >>     Signed-off-by: Linus Torvalds <torvalds@osdl.org>
> >>
> >> Any ideas?
> >>
> >>     
> >
> > Last version has idle timer enabled.
> > It is a tradeoff between device hanging due to lost interrupt or wasting power.
> > You can make the timeout longer by setting idle_timeout module parameter larger,
> > (or zero which will disable it).
> >   
> Ok. But do you need to start the timer when no cable is plugged in, like
> in the case above?

Probably not, because risk of missed PHY interrupt is miniscule.
