Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbXCRV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbXCRV0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 17:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXCRV0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 17:26:00 -0400
Received: from www.osadl.org ([213.239.205.134]:48474 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753284AbXCRVZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 17:25:59 -0400
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Bauer <JohannesBauer@gmx.de>, linux-kernel@vger.kernel.org,
       schwab@suse.de, Stable Kernel Team <stable@kernel.org>,
       Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <45FDAC3B.6000202@redhat.com>
References: <45F6F3A6.9060405@gmx.de> <45F7033B.2030204@redhat.com>
	 <1173817985.13341.120.camel@localhost.localdomain>
	 <1173866413.13341.154.camel@localhost.localdomain>
	 <20070316124313.9f0afc05.akpm@linux-foundation.org>
	 <1174079120.13341.286.camel@localhost.localdomain>
	 <45FDAC3B.6000202@redhat.com>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 22:32:59 +0100
Message-Id: <1174253579.13341.477.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-18 at 17:16 -0400, Chuck Ebbert wrote:
> Thomas Gleixner wrote:
> > 
> > I'd prefer this one: The maximum seconds value we can handle on 32bit is
> > LONG_MAX.
> > 
> > diff --git a/include/linux/ktime.h b/include/linux/ktime.h
> > index c68c7ac..248305b 100644
> > --- a/include/linux/ktime.h
> > +++ b/include/linux/ktime.h
> > @@ -57,7 +57,11 @@ typedef union {
> >  } ktime_t;
> >  
> >  #define KTIME_MAX			((s64)~((u64)1 << 63))
> > -#define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
> > +#if (BITS_PER_LONG == 64)
> > +# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
> > +#else
> > +# define KTIME_SEC_MAX			LONG_MAX
> > +#endif
> >  
> >  /*
> >   * ktime_t definitions when using the 64-bit scalar representation:
> > 
> 
> Just to be clear: this replaces the earlier patch, right?

This replaces the fix Andrew did.

http://marc.info/?l=linux-kernel&m=117407812411997&w=2

	tglx


