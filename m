Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbZGDAGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbZGDAGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 20:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZGDAFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 20:05:55 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:57378 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZGDAFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 20:05:54 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 19:05:53 -0500
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
References: <200907031314.36243.lkml@morethan.org> <200907031602.20948.lkml@morethan.org> <4A4E8741.7030806@zytor.com>
In-Reply-To: <4A4E8741.7030806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031905.55258.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri July 3 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> >>>
> >> The CPUID flags, in particular the pse flag.
> >>
> > 
> > I haven't touch anything that would have changed that -
> > so this should be representative (the *&^*% datasheet says yes to pse also)
> > 
> 
> Actually, come to think of it, we don't generate PSE page tables
> initially -- we only later go in and reclaim the page tables if we
> switch to PSE (and $DEITY knows if we're doing it correctly...)
>

I am of that age range where senility has to be considered, but not this time:

"Via C7-M Datasheet", May 2008 (supposed to be most recent) -

page 22 - section 2.3.7 - Table 2-14 "CR4 Bits"
"<5> PAE: Enables address extensions; C7-M:<r>" 
<quote>An "r" means that this bit is reserved.  It appears as a 0 when read,
and a GP exception is signaled if an attemp is made to write a 1 to this bit.</quote>

Same document -
page 16 - section 2.3.2 - Table 2-3 "CPUID Feature Flag Values (EAX=1)"
<EDX:6> PAE: Physical address extensions; C7:<1>

So take your pick - it might be there or it might not - - -
If you like that one, read the MCE bit "Documentation"  ;)

Note: When this bit is (attempted) to be set in head.S I think that the
GP fault is still "no-opted" by that dummy routine.
So we would never hear about it.
Also, according to H.W. the NX bit is a lie told to keep some OS's happy.

And then, of course, the silicon can have micro-code updates - -
All bets are off if mine works the same as yours does.  ;)

Mike
> 	-hpa
> 


