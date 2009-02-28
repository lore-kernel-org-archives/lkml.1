Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZB1REU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZB1REU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZB1REJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:04:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbZB1REH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:04:07 -0500
Date: Sat, 28 Feb 2009 09:03:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH 2/2] PM: Rework handling of interrupts
 during suspend-resume
In-Reply-To: <200902281106.41793.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902280856270.3111@localhost.localdomain>
References: <Pine.LNX.4.44L0.0902270948540.2926-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0902271221360.3111@localhost.localdomain> <d6200be20902271954q16697282ia056d4f40ab49184@mail.gmail.com> <200902281106.41793.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Feb 2009, Rafael J. Wysocki wrote:
> 
> Still, if Linus agrees, I can put the loop suggested by him directly into
> sysdev_suspend().  Linus?

I don't much care - it's going to be a no-op on architectures that don't 
have that kind of "turn an interrupt into a wakeup event" capability. So 
it's not going to break for things like x86, and it's not like going over 
the irq list one more time is going to be so expensive as to be 
noticeable, even if that architecture doesn't ever get any advantage of 
it.

However - my main worry is that we will notice that different 
architectures (and possibly even different platforms _within_ the same 
architecture - depending on which kind of interrupt/pm controller they 
have) will want to do different things, and actually do something to the 
interrupt controller itself too at that point.

But we can certainly try starting out with just the generic "if a wakeup 
interrupt is pending, sysdev_suspend() returns an error immediately".

			Linus
