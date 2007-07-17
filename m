Return-Path: <linux-kernel-owner+w=401wt.eu-S936199AbXGQUrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936199AbXGQUrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933900AbXGQUnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:43:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35478 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934308AbXGQUnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:43:02 -0400
Date: Tue, 17 Jul 2007 13:42:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Simmons <jsimmons@infradead.org>
cc: Paul Fulghum <paulkf@microgate.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
Message-ID: <alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
 <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
 <469D2810.9080109@microgate.com> <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
 <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jul 2007, James Simmons wrote:
> 
> Because sometimes you do want the delay. In other parts of the tty 
> code we do delay.

Ahh, ok, in that it's ok by me.

> What should be done is 
> 
>         if (tty->low_latency)
>                 flush_to_ldisc(&tty->buf.work.work);
>         else
>                 schedule_delayed_work(&tty->buf.work, 1);
> 
> Is this acceptable to you?

In that case, we might as well just always do the scheduled_delayed_work() 
with a zero timeout as per the earlier patch. I'd still like to know who 
*cares*, though? Why not leave it at 1?

		Linus
