Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbYGCI0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbYGCI0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbYGCIQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:16:48 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:42653 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934234AbYGCHK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:10:26 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-15.tower-51.messagelabs.com!1215069024!3602221!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
Date: Thu, 3 Jul 2008 09:10:19 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Magnus Damm <magnus.damm@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lethal@linux-sh.org" <lethal@linux-sh.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] uio: User IRQ Mode
Message-ID: <20080703071019.GC12214@digi.com>
References: <20080702105951.22648.2197.sendpatchset@rx1.opensource.se> <20080702125400.GC3199@local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080702125400.GC3199@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 03 Jul 2008 07:10:20.0097 (UTC) FILETIME=[DA72E310:01C8DCDB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans J. Koch wrote:
> On Wed, Jul 02, 2008 at 07:59:51PM +0900, Magnus Damm wrote:
> > From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> >
> > This patch adds a "User IRQ Mode" to UIO. In this mode the user space driver
> > is responsible for acknowledging and re-enabling the interrupt.
> 
> This can easily be done without your patch.
> 
> > Shared interrupts are not supported by this mode.
> >
> > Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> > Signed-off-by: Magnus Damm <damm@igel.co.jp>
> > ---
> >
> >  Similar code has been posted some time ago as:
> >  "[PATCH] uio_pdrv: Unique IRQ Mode"
> >  "[PATCH 00/03][RFC] Reusable UIO Platform Driver".
> 
> Yes, and in that thread I gave detailed explanations why I won't accept
> that.
I think for all of your concers one of the following is true:

  - they are not valid any more in this version; or
  - I cannot understand it.

I'll try to list them all below.  Please tell us if the list isn't
complete or if my comments doesn't convince you.  You might have to
repeat yourself, but for me it's hard to sort your arguments because
Magnus' suggestion changed over time.

And please, I try to work out the pros and cons in a constructive way
and hope there is nothing in it you will take personal.  It's really
that I consider the patch valuable and don't understand your concerns.

In the first thread[1] your unique and open concerns (to the best of my
knowledge and belief) with my comments are:

	- "This only works for embedded devices [...]"

	  OK, this doesn't work with shared IRQs which rules out x86.
	  I don't claim to know all the 23[2] other architectures but
	  IMHO if something is good for 3 archs and doesn't hurt the
	  other 21, you should do it.

	- "This would save somebody the trouble to add the above 5 lines
	  to the 30 lines of board/platform support code he has to write
	  anyway. That's the only gain, and that is not enough."

	  IMHO it's worth it.  Because if you add the five lines to a
	  central place you save 5 lines per platform using the driver.
	  Moreover this might prevent some bugs.  (And obviously this
	  function has the potential to have a buggy implementation as
	  the comment by Alan Cox shows.)

	- "And if you _know_ that on your platform the irq is not
	  shared, this might really be a one-liner that simply calls
	  irq_disable. That's OK in board specific code, but not in a
	  generic driver."
	  
	  Please note that the patch only introduces a helper that the
	  platform code *can* use.  You still have the freedom not to
	  use it without any overhead.

	- "I won't accept anything that changes the current UIO
	  behaviour."

	  Not valid anymore.  There is no change in behaviour.

In the second thread[3] I cannot find any open concerns that are not
already listed above.

> >  Changes since Uwe's last version:
> >   - flags should be unsigned long
> >   - simplify uio_userirq_handler()
> 
> That's nearly nothing. All you do is sending the same stuff three weeks
> later in the hope somebody will merge it this time. NAK.
I think nobody really is surprised that you're not happy with the new
post.  But note that Magnus just did what you told him. ("I'm [not] the
big boss who makes the final decision. I can be critized and overridden.
If Greg loves your patch and merges it, fine. Try it.")

In the hope not to have kicked off a flame,
Uwe

[1] http://thread.gmane.org/gmane.linux.kernel/689631
[2] ukleinek@zentaur:~/gsrc/linux-2.6$ ls -l arch/ | grep ^d | wc -l
    24
[3] http://thread.gmane.org/gmane.linux.ports.sh.devel/3917/

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
