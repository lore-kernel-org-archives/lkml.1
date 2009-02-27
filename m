Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbZB0DUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbZB0DUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 22:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZB0DUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 22:20:30 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4489 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753909AbZB0DU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 22:20:29 -0500
Date: Thu, 26 Feb 2009 22:20:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <alpine.LFD.2.00.0902261620370.3111@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0902262211090.22001-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009, Linus Torvalds wrote:

> The _only_ driver that does enable_irq_wake() on x86 is the cmos timer 
> driver, and even there it actually doesn't use irq_wake, but ACPI. Why? 
> Because I don't think irq wakeup even _works_ on x86.
> 
> So the whole enable_irq_wake is largely some embedded ARM platform issue, 
> and a very special case, and doesn't exist anywhere else.
> 
> Maybe I'm missing something, but it's definitely not the normal case.

What you're missing is that the embedded world is quite a large one.  
As any member of CELF will tell you, there are lots more embedded
systems around than there are desktop/laptop computers.  (I admit, I
don't know what the ratio is if you restrict your attention to systems
running Linux.)  We can't afford to regard them as second-class
citizens.

Plenty of embedded systems use normal interrupts from GPIO lines as 
wakeup sources.  Don't discount the need for this just because desktop 
systems don't use them that way.  It may not be "normal" in the 
circles you're accustomed to, but it _is_ normal elsewhere.

Alan Stern

