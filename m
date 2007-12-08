Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXLHUS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXLHUS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXLHUSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:18:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38336 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbXLHUSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:18:49 -0500
Date: Sat, 8 Dec 2007 12:18:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] x86: scale cyc_2_nsec according to CPU frequency
Message-ID: <20071208121811.4e202804@laptopd505.fenrus.org>
In-Reply-To: <20071208191629.GB21186@elte.hu>
References: <20071207021952.6f0ac922@morte>
	<alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain>
	<3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com>
	<20071207090252.1caf1509@inria.fr>
	<20071207135525.GA5588@elte.hu>
	<20071207152741.3408aeef@inria.fr>
	<20071207145206.GA21326@elte.hu>
	<20071208075735.4700bcac@laptopd505.fenrus.org>
	<20071208191629.GB21186@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 20:16:29 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > > > > Firstly, we dont need the 'offset' anymore because
> > > > > cpu_clock() maintains offsets itself.
> > > > 
> > > > Yes, but a lower quality one. __update_rq_clock tries to 
> > > > compensate large jumping clocks with a jiffy resolution, while
> > > > my offset arranges for a very smooth frequency transition.
> > > 
> > > yes, but that would be easy to fix up via calling 
> > > sched_clock_idle_wakeup_event(0) when doing a frequency
> > > transition, without burdening the normal sched_clock() codepath
> > > with the offset. See the attached latest version.
> > 
> > can this deal with dual/quad core where the frequency of one core 
> > changes if the sofware changes the frequency of the other core?
> 
> doesnt the notifier still get run on the target CPU?
> 

.... if and only if the BIOS actually gives correct information to the
OS.

In reality... that's not a very common thing on this field sadly

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
