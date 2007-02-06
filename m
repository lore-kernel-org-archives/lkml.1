Return-Path: <linux-kernel-owner+w=401wt.eu-S1030535AbXBFXPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030535AbXBFXPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030550AbXBFXPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:15:34 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47170
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030535AbXBFXPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:15:33 -0500
From: Rob Landley <rob@landley.net>
To: dwalker@mvista.com
Subject: Re: 2.6.20-rc6-mm3
Date: Tue, 6 Feb 2007 18:15:40 -0500
User-Agent: KMail/1.9.1
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu
References: <20070129204528.eb8d695e.akpm@osdl.org> <1170793206.3785.16.camel@chaos> <1170794437.3455.20.camel@dwalker1>
In-Reply-To: <1170794437.3455.20.camel@dwalker1>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702061815.41078.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 February 2007 3:40 pm, Daniel Walker wrote:
> In this case "different" goes into userspace .. So different could mean
> userspace regression, which is something that we don't want. I have no
> idea if any apps use /proc/interrupts , but it's possible since it's
> been around for a long time.
> 
> The reason that I'm bringing it up at all is because people have ask me
> "Why isn't my timer ticking??"

Because there are two clock sources in the machine and it's using the other 
one, so the interrupt isn't firing?

Are you saying that the /proc statistics aren't accurate, or that you 
previously misunderstood what it was actually measuring and you'd now like it 
to lie?

> > Uurg. /proc/interrupts has nothing to do with timers. It's interrupts
> > statistics. See LOC entry for the lapic ones.
> 
> Your saying we can't remove it tho, if /proc/interrupts is not related
> to timers why does the entry exist at all ?

I didn't think Thomas even touched the /proc/interrupts reporting code.  It's 
still accurate.  The patch changed the usage of timers, /proc/interrupts is 
accurately showing the change, and you're surprised that what it was 
measuring wasn't what you thought it was measuring all along.

This ain't jiffies.  This is how often the PIT fired.  They are not the same 
thing.

Rob
-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
