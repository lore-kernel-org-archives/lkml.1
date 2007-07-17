Return-Path: <linux-kernel-owner+w=401wt.eu-S933444AbXGQUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbXGQUCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbXGQUCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:02:43 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:43742
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbXGQUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:02:43 -0400
X-Greylist: delayed 2124 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2007 16:02:43 EDT
Message-ID: <469D2F67.40305@microgate.com>
Date: Tue, 17 Jul 2007 15:06:47 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org> <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org> <469D2810.9080109@microgate.com> <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org> <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Simmons wrote:
> Because sometimes you do want the delay. In other parts of the tty 
> code we do delay. What should be done is 

Correct, so we must stick with the delayed work structure
which requires calling the delayed work function.

>         if (tty->low_latency)
>                 flush_to_ldisc(&tty->buf.work.work);
>         else
>                 schedule_delayed_work(&tty->buf.work, 1);
> 
> Is this acceptable to you?

That does not make sense to me.

If you are calling from interrupt context, you do not want
to call flush_to_ldisc() directly regardless of low_latency.
This used to be the way it was done and it ended up causing
deadlocks in just that situation.

And the initial schedule has no reason to add the extra delay.

-- 
Paul Fulghum
Microgate Systems, Ltd.
