Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbYFDSgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbYFDSgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbYFDSgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:36:33 -0400
Received: from www.tglx.de ([62.245.132.106]:49130 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbYFDSgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:36:33 -0400
Date: Wed, 4 Jun 2008 20:35:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
cc: Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
In-Reply-To: <Pine.LNX.4.55.0806041836110.28685@cliff.in.clinika.pl>
Message-ID: <alpine.LFD.1.10.0806042032400.3235@apollo.tec.linutronix.de>
References: <12124107071847-git-send-email-od@suse.de> <m1tzgauduu.fsf@frodo.ebiederm.org> <4846651F.4070802@suse.de> <m1ve0pqy06.fsf@frodo.ebiederm.org> <48467DA7.9030309@suse.de> <Pine.LNX.4.55.0806041555370.28685@cliff.in.clinika.pl>
 <alpine.LFD.1.10.0806041801260.3235@apollo.tec.linutronix.de> <Pine.LNX.4.55.0806041755040.28685@cliff.in.clinika.pl> <alpine.LFD.1.10.0806041928390.3235@apollo.tec.linutronix.de> <Pine.LNX.4.55.0806041836110.28685@cliff.in.clinika.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Maciej W. Rozycki wrote:
> On Wed, 4 Jun 2008, Thomas Gleixner wrote:
> 
> > There is no way to take care of an unwanted interrupt when there is no
> > handler which knows to deal with the device.
> 
>  Of course.
> 
> > The problem case is mostly preempt-rt, where we receive the interrupt,
> > mask it and wake up the handler thread. We can not leave it unmasked
> > for obvious reasons.
> 
>  Hmm, I can see what the problem is now -- you can mask the input of the
> primary I/O APIC in this case (with no side effects), making other sources
> at that line suffer, but at least you get away.
> 
>  Anyway, my other questions remain open.  How is the INTx message actually
> delivered to the ICH? 

I have roughly as much clue as you about that. The datashi^Heet is not
really helpful.

> And why is the command line option needed?

We don't want to impose that in the first place, but OTOH to get test
coverage it's probably better to do it unconditionally.

Thanks,

	tglx
