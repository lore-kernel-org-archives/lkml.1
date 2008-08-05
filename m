Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbYHERm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbYHERm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYHERms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:42:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2399 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754030AbYHERms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:42:48 -0400
Date: Tue, 5 Aug 2008 19:42:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [patch 0/6] AMD C1E aware idle support
Message-ID: <20080805174217.GC8380@ucw.cz>
References: <20080610171639.551369443@linutronix.de> <alpine.LFD.1.10.0806181834110.3074@localhost.localdomain> <20080704143536.GA21102@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704143536.GA21102@alberich.amd.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > AMD CPUs with C1E support are currently excluded from high resolution
> > > timers and NOHZ support. The reason is that C1E is a BIOS controlled
> > > C3 power state which switches off TSC and the local APIC timer. The
> > > ACPI C-State control manages the TSC/local APIC timer wreckage, but
> > > this does not include the C1 based ("halt" instruction) C1E mode. The
> > > BIOS/SMM controlled C1E state works on most systems even without
> > > enabling ACPI C-State control.
> > 
> > What a mess.

Yep, seems like AMD is breaking C1 semantics. Is it even valid from
ACPI spec point of view?

> > What is the measured power savings that justifies this effort?
> 
> IMHO the power savings are not that important when such a kernel runs
> on bare metal:

Ok, so maybe we should disable C1E to work around its misdesign?

It would be certainly nice to have noc1e command line option...

>   But overall no measurable difference in power usage was seen.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
