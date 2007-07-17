Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbXGQUPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbXGQUPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbXGQUPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:15:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58546 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbXGQUPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:15:30 -0400
Date: Tue, 17 Jul 2007 21:15:26 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Paul Fulghum <paulkf@microgate.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <469D2F67.40305@microgate.com>
Message-ID: <Pine.LNX.4.64.0707172104050.9131@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
 <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
 <469D2810.9080109@microgate.com> <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
 <469D2F67.40305@microgate.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> James Simmons wrote:
> > Because sometimes you do want the delay. In other parts of the tty code we
> > do delay. What should be done is 
> 
> Correct, so we must stick with the delayed work structure
> which requires calling the delayed work function.
> 
> >         if (tty->low_latency)
> >                 flush_to_ldisc(&tty->buf.work.work);
> >         else
> >                 schedule_delayed_work(&tty->buf.work, 1);
> > 
> > Is this acceptable to you?
> 
> That does not make sense to me.
> 
> If you are calling from interrupt context, you do not want
> to call flush_to_ldisc() directly regardless of low_latency.
> This used to be the way it was done and it ended up causing
> deadlocks in just that situation.

The low_latency is used by the drivers in the case where its 
not in a interrupt context. Well we are trusting the drivers.
Now if it is true what you said then tty_flip_buffer_push has
a bug. Looking at several drivers including serial devices
they set the low_latency flag.

> And the initial schedule has no reason to add the extra delay.

So do you support a non delay work queue as well?


