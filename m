Return-Path: <linux-kernel-owner+w=401wt.eu-S936164AbXGQTw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936164AbXGQTw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936051AbXGQTwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:52:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36710 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935951AbXGQTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:52:17 -0400
Date: Tue, 17 Jul 2007 20:52:14 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paul Fulghum <paulkf@microgate.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
 <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
 <469D2810.9080109@microgate.com> <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, 17 Jul 2007, Paul Fulghum wrote:
> > 
> > The scheduling is to move the processing out of interrupt context.
> > The receive data is often extracted from the hardware
> > at interrupt time and then queued for processing.
> 
> You misunderstand.
> 
> If the "delay" is zero, then why are you using "delayed" workqueues at 
> all?
> 
> A delay of zero tends to be pointless. It's not a delay at all, and you 
> could just use the regular NON-DELAYING workqueues.

Because sometimes you do want the delay. In other parts of the tty 
code we do delay. What should be done is 

        if (tty->low_latency)
                flush_to_ldisc(&tty->buf.work.work);
        else
                schedule_delayed_work(&tty->buf.work, 1);

Is this acceptable to you?

