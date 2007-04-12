Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXDLTmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXDLTmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbXDLTmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:42:25 -0400
Received: from gw.goop.org ([64.81.55.164]:39233 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbXDLTmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:42:24 -0400
Message-ID: <461E8B7B.1000006@goop.org>
Date: Thu, 12 Apr 2007 12:41:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@novell.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
References: <20070411162904.232696302@mvista.com> <461E6FA7.5080605@goop.org> <20070412105559.385789dd.akpm@linux-foundation.org> <200704122027.14926.ak@novell.com>
In-Reply-To: <200704122027.14926.ak@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> They should always just store the cpu too and educate the users that
> only (cpu, timestamp) pairs make sense to compare.
>
> That said at least my new sched_clock should not normally show 
> large non differences between CPUs, so it can be usually ignored, but they can 
> happen. I believe some of the already existing sched_clocks() (like the
> one used on Altix) have the same property. 
>
> But on VMI/Xen as currently implemented the differences will be large.

Yes, it's pretty much unavoidable.  It seems to me that these
non-scheduler uses of sched_clock should use something else.  Or we
could add a new clock function for the scheduler to use, but
"sched_clock" seems like the best name for it.

    J
