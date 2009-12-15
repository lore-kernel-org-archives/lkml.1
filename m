Return-Path: <linux-kernel-owner+w=401wt.eu-S1758602AbZLOBD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602AbZLOBD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbZLOBDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:03:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:40791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbZLOBDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:03:54 -0500
Date: Mon, 14 Dec 2009 17:06:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Salman Qazi <sqazi@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>, Taliver Heath <taliver@google.com>
Subject: Re: RFC: A proposal for power capping through forced idle in the 
 Linux Kernel
Message-ID: <20091214170616.59fc163f@infradead.org>
In-Reply-To: <4352991a0912141636t35a96c14o5fd4b9e152e6e681@mail.gmail.com>
References: <4352991a0912141511k7f9b8b79y767c693a4ff3bc2b@mail.gmail.com>
	<20091214161922.6f252492@infradead.org>
	<4352991a0912141636t35a96c14o5fd4b9e152e6e681@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 16:36:20 -0800
Salman Qazi <sqazi@google.com> wrote:

> On Mon, Dec 14, 2009 at 4:19 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > On Mon, 14 Dec 2009 15:11:47 -0800
> > Salman Qazi <sqazi@google.com> wrote:
> >
> >
> > I like the general idea, I have one request (that I didn't see
> > quite in your explanation): Please make sure that all cpus in the
> > system do their idle injection at the same time, so that memory can
> > go into power saving mode as well during this time etc etc...
> >
> 
> With the current interface, the forced idle percentages on the CPUs
> are controlled independently.  There's a trade-off here.  If we inject

I'm fine with that... just want to ask that even if we inject different
percentages, that we inject them for maximum overlap
(having the memory power in a machine suddenly be half or less is a
huge step in power, for something, the alignment itself, that does not
cost much if any extra performance over randomly distributed idle
insertions)

> idle cycles on all the CPU at the same time, our machine
> responsiveness also degrades: essentially every CPU becomes equally
> bad for an interactive task to run on.  Our aim at the moment is to
> try to concentrate the idle cycles on a small set of CPUs, to strive
> to leave some CPUs where interactive tasks can run unhindered.  But,
> given a different workload and goals the correct policy may be
> different.

as long as the tentative portion of the idle time gets injected at the
same time.. I suspect there can be a decent balance here where most of
the time we get the full CPU *and* memory savings, while we degrade
gracefully for the case where we get increasingly more interactive
activity.

 
> Simultaneously idling multiple "cores" becomes necessary in the SMT
> case: as there is no point in idling a single thread, while the other
> thread is running full tilt.  

I can argue the same for package level btw ;)


> I think the best approach may be to provide a way to specify the
> policy from the user space.  Basically let the user decide at what
> level of CPU hierarchy the forced idle percentages are specified.
> Then, in the levels below, we simply inject at the same time.

it's not so much about the specification part; per logical cpu is a nice
place to specify things... as long as we, in the execution part, align
things up smart.




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
