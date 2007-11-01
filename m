Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbXKAVLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbXKAVLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbXKAVLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:11:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58846 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbXKAVLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:11:44 -0400
Date: Thu, 1 Nov 2007 22:11:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tim Bird <tim.bird@am.sony.com>, Matt Mackall <mpm@selenic.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Jon Smirl <jonsmirl@yahoo.com>
Subject: Re: IRQ off latency of printk is very high
Message-ID: <20071101211153.GA11074@elf.ucw.cz>
References: <4720F21F.9090404@am.sony.com> <20071025222804.GA13954@Krystal> <47211E2C.90301@am.sony.com> <20071025231237.GT19691@waste.org> <472129C3.6040405@am.sony.com> <20071029185445.GA7742@ucw.cz> <20071101152714.GA2489@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101152714.GA2489@Krystal>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > It seems draconian to drain the entire buffer with ints disabled.
> > > Is it possible to break this up and send out smaller chunks
> > > at a time?  Maybe by putting a chunk loop in release_console_sem()?
> > 
> > Well, I believe someone got
> > 
> > DDetetccctted ed 113223 HHzz CPUCPU
> > 
> > in his dmesg, and now we have this 'draconian' locking. How can we
> > prevent mangled messages without it?
> 
> The main interest seems to be to protect from mixed printk output
> between different CPUs in process context. I don't think it would be
> that bad if interrupts come and output error messages in the middle of a
> printk, isn't it ?
> 
> therefore, could we do something like :
> 
> 
> if (!in_irq())
>   spin_lock(&logbuf_lock);
> ...
> if (!in_irq())
>   spin_unlock(&logbuf_lock);
> 
> ? (yes, this is a crazy idea)

Two messages in atomic sections on different cpus could still be mixed
:-). But yes, something like this may be the way to go.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
