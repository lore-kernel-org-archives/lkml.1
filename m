Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbXF0Qfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbXF0Qfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbXF0Qfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:35:33 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:57155 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756216AbXF0Qfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:35:32 -0400
Date: Wed, 27 Jun 2007 18:35:29 +0200
From: Uwe Kleine-Koenig <ukleinek@informatik.uni-freiburg.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Dynamic ticks make system jerking
Message-ID: <20070627163529.GA12978@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe Kleine-Koenig <ukleinek@informatik.uni-freiburg.de>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>
References: <20070626150015.GA20233@informatik.uni-freiburg.de> <1182872749.11854.27.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182872749.11854.27.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thomas Gleixner wrote:
> On Tue, 2007-06-26 at 17:00 +0200, Uwe Kleine-K??nig wrote:
> > If I enable NO_HZ, the system jerks (I hope this is an understandable
> > term ...).   E.g. 
> > 
> > 	# time find /sys
> > 	...
> > 	real    1m 19.52s
> > 	user    0m 0.18s
> > 	sys     0m 0.15s
> > 
> > on a freshly booted machine.  The output comes in several hunks with
> > pausing between them.  With no_hz=off, I get approx. the same.
> 
> it's nohz=off not no_hz=off
Currently I'm not sure, which I was really using.  I think it was the
right one, because dmesg changed.  But anyhow, I will retest if I made
it wrong.
 
> > First I wondered why set_next_event is called twice between two timer
> > interrupts most of the time.  I found out that the timer is programed
> > for the next tick in any case and if nothing needs the next tick, the
> > interval is enlarged.  I didn't spend time yet to check if it is
> > easier/faster to only program the timer once.
> 
> We optimize for the non-idle path, i.e. we keep the timer running as
> long as we are not idle. Once we go idle we reprogram it.
OK, sounds sane.
 
> I looked at the patch and as far as I can understand it, there is
> nothing obviously wrong about it.
What a pity.

> One remark: why did you expand the clocksource to be 64 bit? The generic
> code handles the 32 bit wrap already, so the expansion in your read
> routine is adding overhead. The counter will wrap every 24 seconds, so
> there is nothing to worry about.
OK, I thought it to be better to have 64bit + some overhead.  I will
change that.
 
> The behavior you are describing is might be related to some problem with
> the clocksource readout, as the reprogramming values are calculated from
> there. 
Any hints how I can debug that?

Currently I cannot retest, but I will dig into it again and rereport.

Thanks for your answer.

Best regards
Uwe

-- 
Uwe Kleine-Koenig

http://www.google.com/search?q=speed+of+light%3D
