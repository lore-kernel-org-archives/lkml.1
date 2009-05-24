Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZEXM1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZEXM1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 08:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZEXM1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 08:27:32 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:56521 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZEXM1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 08:27:31 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sun, 24 May 2009 07:27:27 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <200905231304.55973.lkml@morethan.org> <4A188A48.5000208@zytor.com>
In-Reply-To: <4A188A48.5000208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905240727.30677.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat May 23 2009, H. Peter Anvin wrote:
> Hi Harald,
> 
> It looks like there might be a problem with the C7-M ... Michael reports
> that if he sets LOCK_PREFIX to "lock;" it works, but that shouldn't be
> necessary for a uniprocessor.
> 
> I'm wondering if we have to revive the OOSTORE hack, or some other
> workaround.  It is of course hard for me to track this down since (a) I
> don't have access to the CPU documentation, and (b) I work for Intel
> now, which limits the amount of time I can realistically spend on this.
>

@hpa - I still like your suggestion that it is only one (or a few)
uses of atomic ops that is incorrect and in general atomic ops
should compile away on uni-processor.

Let me translate the findings (see further in the included post) -
The C7-M/CN896 (no tech manual released for CN896 yet) and
the C7-M/CX700 (tech manual released since drivers written)

*) I never tested -09143lk on the C7-M/CN896 because -09143 did
not fail all day (a record for 2.6.30 at the moment).

*) The difference on the C7-M/CX700 between the -09143 and -09143lk
I consider significant.

***) But, keep in mind, just because the system chip set is different,
there are other unknowns - -
We can *not* say at the moment that both machines where using the same 
execution paths - even though the binaries where identical.

Also, there where probably different external modules loaded in the
two runs - not many, mostly things are built-in.

The truly significant point on the C7-M/CX700 running -09143lk was that
when the echi-hcd driver got hung in its failure loop, generating a 
flood of messages - it did not take down or lock the kernel.

I consider this "forward progress" - it should be possible to build-in
the lock-dep checkers and get something in the message buffer -
rather than just have the machine halt.  Its hard to debug a halted
machine with only a glowing power-on light for feed-back.  ;)

Mike


 
> 	-hpa
> 
> [Cc: Alan, who I believed developed the OOSTORE hack back when.]
> 
> 
> Michael S. Zick wrote:
> > On Fri May 22 2009, H. Peter Anvin wrote:
> >> Michael S. Zick wrote:
> >>> Same integrated motherboard.
> >> Which means same CPU, same BIOS, same motherboard (none of which you're
> >> telling us.)
> >>
> >> cpuinfo and dmidecode would be informative.
> >>
> > 
> > The -09143lk files are posted.
> > 
> > Download location:
> > http://hp-umpc.com/ce1200v
> > 
> > Details so far today:
> > http://forum.netbookuser.com/viewtopic.php?pid=6968#p6968
> > 
> > Summary:
> > HP-2133 (C7-M/CN896) - 09143 - No results - Still up 3 1/2 hours.
> > Cloudbook (C7-M/CX700) - 09143 - 45 minutes.
> > Cloudbook (C7-M/CX700) - 09143lk - No results - Still up 1 1/2 hours.
> > 
> > OK - time to look for the missing "memory" in the clobber lists.  ;)
> > 
> 


