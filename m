Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbZB0UbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbZB0UbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZB0Uay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:30:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755489AbZB0Uax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:30:53 -0500
Date: Fri, 27 Feb 2009 12:30:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH 2/2] PM: Rework handling of interrupts
 during suspend-resume
In-Reply-To: <Pine.LNX.4.44L0.0902270948540.2926-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0902271221360.3111@localhost.localdomain>
References: <Pine.LNX.4.44L0.0902270948540.2926-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Feb 2009, Alan Stern wrote:
> 
> Perhaps these aren't all the sort of usage you're talking about, but I
> bet most of them are.  It certainly looks like more than just ARM.  
> Maybe not all that much more, but definitely more.  And the number will
> only grow in the future.

Are you really sure? Because it can't be x86. I'm pretty sure that that is 
simply not how x86 wake events _work_ - they're not interrupts.

And that's the big point that people seem to be missing here: the whole 
"wake up interrupt" thing is not some generic model in the first place. I 
strongly suspect that it literally only works on certain architectures.

In other words, I'm getting damn tired of people who CLEARLY DON'T EVEN 
KNOW HOW THE HARDWARE WORKS arguing over this.

Here's another hint: that whole "enable_irq_wake()" - have you possibly 
spent even five seconds to look at what it actually does? I bet you 
haven't. Because what it does is to call the irq controller "set_wake" 
function.

Now, grep for that. Whay do you find? Like maybe ARM and BlackFin? Oh, and 
I note one MIPS platform.

The point is, that whole "irq wake" really is system dependent. We can do 
helper functions for it, but anybody who thinks it's anything "generic" is 
totally mistaken.

In other words, making it a sysdev thing is the CORRECT thing to do. It 
really is not just "here's how you work around something". It really is 
"this is how the hardware FUNDAMENTALLY WORKS".

Please, stop arguing. At least argue only after you understand what the 
physical hardware actyally does. 

			Linus
