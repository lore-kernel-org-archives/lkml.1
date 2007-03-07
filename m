Return-Path: <linux-kernel-owner+w=401wt.eu-S2992454AbXCGWCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992454AbXCGWCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992464AbXCGWCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:02:08 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42759 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992454AbXCGWB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:01:59 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Mar 2007 14:01:56 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703071347380.5963@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703071353430.12756@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
 <20070307155553.06c82ca1.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
 <20070307233833.f1482f86.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703070943180.12283@alien.or.mcafeemobile.com>
 <45EF20F7.1050307@goop.org> <Pine.LNX.4.64.0703071241590.12756@alien.or.mcafeemobile.com>
 <45EF2DFF.4060209@goop.org> <Pine.LNX.4.64.0703071329080.12756@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703071347380.5963@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Linus Torvalds wrote:

> 
> 
> On Wed, 7 Mar 2007, Davide Libenzi wrote:
> > 
> > You have the *choice* to do that:
> > 
> > 1) You want standard delivery only:
> > 
> >    - Just dont use signalfd
> > 
> > 2) you want signalfd only:
> > 
> >    - Do a sigprocmask(SIG_BLOCK) of the same mask you pass to signalfd
> > 
> > If you want both, you can have it. Race free.
> 
> .. but maybe with more code and lots of confusion. I'm still unclear on 
> any upsides here. 

Ok, given that you have to place the notifiers (you had a direct call to 
wake_up, same thing - but was not handling the "the sighand has been 
detched" case), your queue_signal() call translates to:

	sq = list_entry(ctx->squeue.next, struct signalfd_sq, lnk);
	list_del(&sq->lnk);

That's pretty much it. There is more code WRT your patch, but there are 
more things handled too (reuse of the fd, notify detachment, send siginfo).
And those has to be handled in any case.



- Davide


