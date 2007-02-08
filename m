Return-Path: <linux-kernel-owner+w=401wt.eu-S1161519AbXBHHyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161519AbXBHHyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 02:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161527AbXBHHyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 02:54:07 -0500
Received: from mkedef1.rockwellautomation.com ([208.22.104.18]:55685 "EHLO
	ramilwsmtp01.ra.rockwell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161519AbXBHHyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 02:54:06 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: posix-timers overrun broken?
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5  CCH1 March 07, 2006
Message-ID: <OFB812AC35.7E514449-ONC125727C.0029AA85-C125727C.002B65DA@ra.rockwell.com>
From: Milan Svoboda <msvoboda@ra.rockwell.com>
Date: Thu, 8 Feb 2007 08:55:01 +0100
X-MIMETrack: Serialize by Router on RAMilwSMTP01/Milwaukee/RA/Rockwell(Release 6.5.4FP1|June
 19, 2005) at 02/08/2007 01:55:06 AM,
	Serialize complete at 02/08/2007 01:55:06 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2007-02-07 at 14:36 +0100, Milan Svoboda wrote:
> > But if the next interrupt arrives before function collect_signal is 
called 
> > to actually deliver the
> > siginfo_t to userspace, the si.overrun is cleared in posix_timer_event 
and 
> > we have just forgotten
> > one overrun...
> > 
> > Am I wrong?
> 
> Yes. posix_timer_event() is only called when the timer expires the first
> time. When the signal has been queued, the timer is not rearmed and the
> overrun is calculated in the actual signal delivery path, which calls
> do_schedule_next_timer().

Ok understand.

So it seems to me that drivers/char/mmtimer.c is wrong. It is
driver to additional hardware timers and mmtimer exports them as a posix 
timer.
When interrupt happens, they call posix_timer_event and set hardware 
interrupt
to the next tick. I use the same practise in my driver and found
that overruns are reported wrongly.

How to plug "external" source of ticks to the posix timers?

As far as I know current HRT doesn't allow us to use more sources of
ticks together, only one is selected, correct?

Milan



