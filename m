Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXCPQxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXCPQxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965627AbXCPQxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:53:35 -0400
Received: from gw.goop.org ([64.81.55.164]:53205 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965626AbXCPQxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:53:34 -0400
Message-ID: <45FACB8E.7000505@goop.org>
Date: Fri, 16 Mar 2007 09:53:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dan Hecht <dhecht@vmware.com>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       paulus@au.ibm.com, schwidefsky@de.ibm.com,
       Rik van Riel <riel@redhat.com>
Subject: Re: Stolen and degraded time and schedulers
References: <1173816769.22180.14.camel@localhost> <45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <45F846AB.6060200@vmware.com> <45F84E39.7030507@goop.org> <20070314203826.GA15394@elte.hu> <45F86247.40109@goop.org> <20070316083828.GA22168@elte.hu>
In-Reply-To: <20070316083828.GA22168@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i dont understand: how are you separating 'stolen time' drifts from 
> events generated for absolute timeouts?
>   

I'm not sure what you're asking; I think we're talking past each other.

I can extract from Xen how much time was stolen over some real-time
interval.  If I call do_stolen_accounting() at any two arbitrary points,
it will compute the amount of time stolen in the interval.  So that
means I can call it from time to time to update stolen time.  Of course,
this accounting will be out of date for a while, but it doesn't matter
too much.  I call it from the timer interrupt, since it will be called
occasionally on idle CPUs and often on busy CPUs, which is what we want.

Oh, its worth pointing out that stolen time is accounted against CPUs
rather than individual processes, so it doesn't need to be related to
process scheduling.

Also, none of this is in the patch set I posted; I've implemented it
since, and it will be in the next batch.

    J
