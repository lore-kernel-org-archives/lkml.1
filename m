Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYEQP0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYEQP0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 11:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYEQP0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 11:26:00 -0400
Received: from www.tglx.de ([62.245.132.106]:59139 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbYEQPZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 11:25:59 -0400
Date: Sat, 17 May 2008 17:24:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Takashi Iwai <tiwai@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Stas Sergeev <stsp@aknet.ru>
Subject: Re: [Bugme-new] [Bug 10701] New: snd_pcsp lockdep warning
In-Reply-To: <s5hwsltm4bu.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.1.10.0805171720310.14337@apollo.tec.linutronix.de>
References: <bug-10701-10286@http.bugzilla.kernel.org/> <20080515110244.6e15d4c3.akpm@linux-foundation.org> <alpine.LFD.1.10.0805161338500.3255@apollo.tec.linutronix.de> <20080516103827.0d5ab023.akpm@linux-foundation.org> <alpine.LFD.1.10.0805162132050.3255@apollo.tec.linutronix.de>
 <s5hwsltm4bu.wl%tiwai@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008, Takashi Iwai wrote:
> At Fri, 16 May 2008 21:32:49 +0200 (CEST),
> Thomas Gleixner wrote:
> > 
> > On Fri, 16 May 2008, Andrew Morton wrote:
> > > > So the author was well aware of locking problem and the whole code is
> > > > just a stupid hack around the problem without solving it. This code is
> > > > not at all suited for HRTIMER_CB_IRQSAFE.
> > > 
> > > You sound impressed!  So what's the fix?  HRTIMER_CB_SOFTIRQ?
> > 
> > Yeah, impressed by creativity. HRTIMER_CB_SOFTIRQ should be the right
> > thing.
> 
> Well, it'd be basically a similar way like snd-pcsp currently does ("a
> stupid hack" :)  But, it's good to have a fix, anyway, since this
> sounds like a generic problem with a callback in a spinlock.  If the
> callback requires another own lock, this can easily lead to a AB/BA
> deadlock.  Actually, ALSA PCM core had sometimes similar problems,
> too.

HRTIMER_CB_SOFTIRQ is not a stupid hack :) It's the default for
hrtimers and it does not hold any locks when calling the callback. We
really want to avoid tons of callbacks in the timer interrupt itself.

Thanks,
	tglx


