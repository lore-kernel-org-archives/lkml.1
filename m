Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYI3XjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYI3XjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYI3Xiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:38:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34368 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751838AbYI3Xiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:38:54 -0400
Date: Sun, 28 Sep 2008 21:42:01 +0200
From: Pavel Machek <pavel@suse.cz>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       rpurdie@rpsys.net, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator
	driver
Message-ID: <20080928194201.GA1310@ucw.cz>
References: <20080919143744.009764000@polaris-admin.engr.sgi.com> <20080919143744.190005000@polaris-admin.engr.sgi.com> <20080922114820.GA13990@elte.hu> <48D7AEE6.7080804@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D7AEE6.7080804@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Another relevant point is that I will be adding a bit more functionality
> to disable the timer interrupt on truly "idle" cpus (like have been idle
> for some amount of seconds).  We would then use the "exit from idle"
> callback to reestablish the timer interrupt.  [This would allow them to
> enter power down states if appropriate.]

Should you look at nohz instead of reinventing it? 

> > As i suggested in my previous mail about this topic, a low-frequency 
> > sampling method should be used instead, to indicate system status. I 
> > thought the leds drivers have all that in place already.
> 
> It is low frequency (once per second), this is just setting what's to
> be sampled.
> 
> As I mentioned, this is not for LED displays (human readable), it's for the
> system controller to monitor how all parts of the system are running, and
> this one is just the cpu parts.  The LED driver approach would have me
> registering 4096 led devices, with all their callbacks, 4096 strings saying
> "LED0001", etc., and I still cannot associate a specific register bit
> (AKA LED if that's what it was), with a specific cpu using the LED driver.
> 
> The LED driver is fine for a couple of blinking lights indicating overall
> system activity, disk activity, etc.  (Btw, I did not see a network trigger,
> or a paging trigger, or an out of memory trigger, or some other things that
> might be useful for real time monitoring of the system.)

...so add them...

> But the LED driver has way more overhead than needed for this simple application.
> 

So overhead from led driver is not okay, while overhead from messing
with idle loop is okay? Interesting...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
