Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0CAQpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:45:04 -0500
Received: from darkcity.gna.ch ([195.226.6.51]:39312 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751363Ab0CAQpA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:45:00 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 11:45:00 EST
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to
 sleep  (w. timeout) until wake_up
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <b170af451002270133v6c44a6bcnf5751a6338c61a63@mail.gmail.com>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
	 <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
	 <20100226081418.5902446f.akpm@linux-foundation.org>
	 <b170af451002260933i6a7a5e1el619f8e71c3ae0bc8@mail.gmail.com>
	 <20100226190100.GQ10145@sci.fi>
	 <b170af451002270133v6c44a6bcnf5751a6338c61a63@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 01 Mar 2010 17:37:18 +0100
Message-ID: <1267461438.5157.9586.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-27 at 10:33 +0100, Rafał Miłecki wrote: 
> W dniu 26 lutego 2010 20:01 użytkownik Ville Syrjälä <syrjala@sci.fi> napisał:
> > Disabling the condition check doesn't make sense.
> >
> > You could use a completion.
> >
> > init_completion(vbl_irq);
> > enable_vbl_irq();
> > wait_for_completion(vbl_irq);
> > disable_vbl_irq();
> > and call complete(vbl_irq) in the interrupt handler.
> >
> > The same would of course work with just some flag or counter
> > and a wait queue.
> 
> Ouch, I can see it gone bad already.
> 
> Firstly I simply just wanted to avoid condition in wait_event_*. It
> looked unnecessary as I got interrupts (signals).

So this code runs in user process context? If so, it should return to
userspace ASAP on signal receipt, otherwise e.g. smoothness of X mouse
movement may suffer.

If that's a problem, then maybe the code should run in a different
context, e.g. a tasklet or some kind of worker kernel thread.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
