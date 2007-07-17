Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbXGQUaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbXGQUaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765934AbXGQU3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:29:49 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:50318
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764176AbXGQU3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:29:47 -0400
Message-ID: <469D2810.9080109@microgate.com>
Date: Tue, 17 Jul 2007 14:35:28 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Simmons <jsimmons@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org> <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
>> -	schedule_delayed_work(&tty->buf.work, 1);
>> +	schedule_delayed_work(&tty->buf.work, 0);
> 
> Is there any real reason for this?
> 
> I think that patch is bogus. Either it should stay at 1, or the whole work 
> should be a non-scheduled one instead.
> 
> Do we really need to handle it asap for the console, or is it ok to wait 
> for the next tick, like the regular tty case used to?
> 
> And if we need to handle it asap, why the "delayed"?

The scheduling is to move the processing out of interrupt context.
The receive data is often extracted from the hardware
at interrupt time and then queued for processing.

-- 
Paul Fulghum
Microgate Systems, Ltd.
