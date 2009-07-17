Return-Path: <linux-kernel-owner+w=401wt.eu-S964878AbZGQQUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878AbZGQQUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 12:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934733AbZGQQUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 12:20:06 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42047 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934731AbZGQQUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:20:05 -0400
Date: Fri, 17 Jul 2009 09:20:01 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rafael Wysocki <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Nathan Lynch <ntl@pobox.com>,
       Nigel Cunningham <nigel@tuxonice.net>, stable@kernel.org,
       containers@lists.linux-foundation.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [patch 2/2] sched: fix nr_uninterruptible accounting of frozen
	tasks really
Message-ID: <20090717162001.GC5878@count0.beaverton.ibm.com>
References: <20090717121545.489258927@linutronix.de> <20090717122103.225652146@linutronix.de> <20090717155116.GB5878@count0.beaverton.ibm.com> <1247846127.6522.21.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247846127.6522.21.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 05:55:27PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-17 at 08:51 -0700, Matt Helsley wrote:
> 
> > So it's not clear to me how adding PF_FREEZING fixes anything. Am I
> > missing something?
> 
> Yep, PF_FROZEN is only observed going into schedule(), on the way back
> out thaw_process() will already have cleared the flag.
> 
> So we don't increment in deactivate_task(), but we do decrement in
> activate_task(), yielding for some very unbalanced accounting.

Ahhh, right!

OK, so the fix looks good then.

Cheers,
	-Matt Helsley
