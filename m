Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbXGRUJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbXGRUJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbXGRUJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:09:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313AbXGRUI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:08:59 -0400
Date: Wed, 18 Jul 2007 13:08:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
cc: James Simmons <jsimmons@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
In-Reply-To: <1184783279.3444.15.camel@x2.microgate.com>
Message-ID: <alpine.LFD.0.999.0707181303070.27353@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org> 
 <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org> 
 <469D2810.9080109@microgate.com>  <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>
  <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org> 
 <alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0707181821150.28741@pentafluge.infradead.org>
 <1184783279.3444.15.camel@x2.microgate.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jul 2007, Paul Fulghum wrote:
> 
> It might be safest to drop this portion so you can get the
> obvious part of the patch accepted (consolidating
> the redundant xxx_schedule_flip functions).

But wasn't the whole _point_ that con_schedule_flip() potentially gets 
called from interrupt context, and thus that part is wrong. It's why 
con_schedule_flip() was different from tty_schedule_flip() to begin with, 
no?

If a tty driver has marked itself low-latency, it's still wrong to do the 
flush_to_ldisc() from interrupt context if a console event happens in 
interrupt context.

I thought that was the whole *point* of the difference between 
"tty_schedule_flip()" and "con_schedule_flip()", as far as I know. The 
"con_schedule_flip()" can be called from any context (console messages), 
while "tty_schedule_flip()" is only called from well-behaved tty layer.

But I really don't know. I used to be involved with the tty layer, these 
days I'd rather avoid it. This "simple" patch seems to be anything but, 
and I'd like somebody to just make sure that all the issues are taken care 
of.

Alan?

		Linus
