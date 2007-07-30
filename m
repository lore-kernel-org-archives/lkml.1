Return-Path: <linux-kernel-owner+w=401wt.eu-S939420AbXG3Tnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939420AbXG3Tnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933886AbXG3Tne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:43:34 -0400
Received: from users.ccur.com ([66.10.65.2]:54388 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763081AbXG3Tnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:43:33 -0400
Date: Mon, 30 Jul 2007 15:42:06 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       jason.baietto@ccur.com
Subject: Re: [PATCH] create /proc/all-interrupts
Message-ID: <20070730194206.GA17509@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20070726180522.GA1486@tsunami.ccur.com> <46A8EE78.4040702@zytor.com> <1185816797.3170.1.camel@sven.thebigcorporation.com> <20070730123206.abeab890.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730123206.abeab890.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 12:32:06PM -0700, Andrew Morton wrote:
> On Mon, 30 Jul 2007 10:33:17 -0700
> Sven-Thorsten Dietrich <sdietrich@novell.com> wrote:
> > On Thu, 2007-07-26 at 11:56 -0700, H. Peter Anvin wrote: 
> > > Joe Korty wrote:
> > > > Create /proc/all-interrupts for some architectures.

> > Would it make sense to drop this patch into -mm for feedback?
> > 
> 
> It's a lot of code for something which might be useful to someone sometime.
> 
> It's a bit of a crappy changelog too.  I'd at least like to see a list of
> all the new fields.
> 
> It should be OK to add new lines to /proc/interrupts?  That file varies a
> lot between machines adn between architectures - as long as the new lines
> have similar layout it is unlikely that anything will break.
> 
> +	atomic_inc(&__get_cpu_var(irq_thermal_counts));
> 
> The patch does atomic ops on cpu-local variables.  This isn't needed, and
> is expensive.
> 
> If the field is only ever modified from hard interrupt context then you can
> make the field unsigned long and use plain old `foo++'.
> 
> If the field is modified from both hard-IRQ and from non-IRQ then use a
> local_t and local_inc.
> 
> Or even, given that this is just a statistic and grrat precision is not
> needed, use unsigned long and f++ even if that _is_ racy.  Because the
> consequences of a race will just be a single lost count, which we dont'
> care about enough to add the additional overhead of an atomic op.

Hi Andrew,
Thanks for the comments.  I'll, at least, make the changes you suggested.

(the /proc/interrupts version has the benefit of being smaller too).

Joe

