Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbXDFWHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbXDFWHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933217AbXDFWGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:06:21 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:50529 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222AbXDFWGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:06:18 -0400
Date: Sat, 7 Apr 2007 00:04:23 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Brownell <david-b@pacbell.net>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Tony Lindgren <tony@atomide.com>,
       linux-kernel@vger.kernel.org
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ...
 blinky leds!!)
In-Reply-To: <200704061357.03700.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.61.0704062354530.6042@yvahk01.tjqt.qr>
References: <11757099691323-git-send-email-tony@atomide.com>
 <200704061029.55710.david-b@pacbell.net> <Pine.LNX.4.61.0704061951580.6042@yvahk01.tjqt.qr>
 <200704061357.03700.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,


On Apr 6 2007 13:57, David Brownell wrote:
>> though I do not speak for 
>> them, seem to do it much the way I described, judging from the code they
>> wrote/write.
>
>Your eyes are broken then ...

Sorry? I could have simply told you to look into kernel/signal.c LINE
220 (that's in the recalc_sigpending_tsk() function), to see that
THERE IS code which uses /^\t+\x20/ to indent wrapped if continuation
lines:

fastcall void recalc_sigpending_tsk(struct task_struct *t)
{
	if (t->signal->group_stop_count > 0 ||
	    (freezing(t)) ||
	    PENDING(&t->pending, &t->blocked) ||
	    PENDING(&t->signal->shared_pending, &t->blocked))
		set_tsk_thread_flag(t, TIF_SIGPENDING);
	else
		clear_tsk_thread_flag(t, TIF_SIGPENDING);
}

And this is not the only function. But since I figured you would
anyway object despite what I say...

>or maybe you're focussing exclusively
>on code that violates the most basic coding guidelines like:

...I wrote that script that actually proves my point (minus script
bugs - errare est humanum) that \t+\x20 is PREDOMINANT in kernel
code. Whether that invalidates what CodingStyle says is another
debate (which at best Randy just decides and sends a patch for which
is then hopefully committed instantly).

>	if (...) {
>		THAT WAS ONE MORE TAB
>	}
>
>and
>
>	for (...) {
>		THAT WAS ALSO ONE MORE TAB
>	}
>
>Come on, stop wasting everyone's time with utter nonsense.

I was never debating these two things. I was, however, if you have
not noticed yet, about wrapped if lines:

	if (foo ||
	    continuation_with_2_or_more_spaces)
		code_with_1_tab;
and
	if (foo ||
			continuation_with_2_tabs)
		code_with_1_tab;


The former is what kernel code does "**TODAY**".
Thank you.
Jan
-- 
