Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZLKRdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZLKRdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756068AbZLKRde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:33:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58588 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbZLKRdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:33:33 -0500
Date: Fri, 11 Dec 2009 18:33:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, lenb@kernel.org, ming.m.lin@intel.com,
       robert.moore@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or
 in_atomic
Message-ID: <20091211173333.GB15760@elf.ucw.cz>
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
 <20091210100907.GA2446@ucw.cz>
 <4B2136D5.1030402@gmail.com>
 <20091210181800.GM19454@elf.ucw.cz>
 <4B214007.2080409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B214007.2080409@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-12-10 21:37:59, Alexey Starikovskiy wrote:
> Pavel Machek ??????????:
> > On Thu 2009-12-10 20:58:45, Alexey Starikovskiy wrote:
> >   
> >> Hi Pavel,
> >>
> >> Please elaborate... Your comments "ugly as hell" are too often to be
> >> specific...
> >> There is only one use of ACPI_PREEMPTION_POINT(), and it is in the
> >> ACPICA code,
> >> which we all agreed to keep OS independent, thus the need for #define.
> >> Do you see any other way to add preemption point without introducing
> >> Linux-specific
> >> code into ACPICA?
> >>     
> >
> > I believe we want linux-specific code in acpica at this point.
> >
> >   
> The point there we call cond_resched() in ACPICA is an interpreter parse
> loop. This parse loop may be executed from within atomic context and even
> with interrupts off. In this case, cond_resched() should not be called
> to not make
> might_sleep() guards angry.

Yes, so pass explicit argument to the interpretter, telling it what
kind of context it runs on. Similar to kmalloc's GFP_KERNEL
vs. GFP_ATOMIC.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
