Return-Path: <linux-kernel-owner+w=401wt.eu-S1422636AbXCNPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636AbXCNPMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 11:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422645AbXCNPMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 11:12:19 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:34635 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422641AbXCNPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 11:12:18 -0400
Date: Wed, 14 Mar 2007 11:12:17 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dan Hecht <dhecht@vmware.com>, dwalker@mvista.com,
       cpufreq@lists.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Stolen and degraded time and schedulers
Message-ID: <20070314151217.GO22464@csclub.uwaterloo.ca>
References: <45F6D1D0.6080905@goop.org> <1173816769.22180.14.camel@localhost> <45F70A71.9090205@goop.org> <1173821224.1416.24.camel@dwalker1> <45F71EA5.2090203@goop.org> <45F74515.7010808@vmware.com> <45F77C27.8090604@goop.org> <20070314135845.GG22466@csclub.uwaterloo.ca> <45F80FE1.3030603@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F80FE1.3030603@goop.org>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 08:08:17AM -0700, Jeremy Fitzhardinge wrote:
> You're right.  That's a very tough case.  I don't know if there's any
> way to do a reasonable estimate of the slowdown.  You could handwave it
> and say "if both threads are running a process, then apply an X scaling
> factor to their rate of progress".  That might be enough.

I would think that's a bad idea.  I expect future processors to do HT
much better than the P4 did.  There will always be cases where two
processes don't share well, but the majority of cases they probably will
share well.  Of course if you don't have enough processes to keep all
the CPU cores busy, you might as well not schedule something on the
siblings on HT processors, but on the other hand maybe you should if you
can power down other cpus completely to save power and still get all the
work done at maximum speed.

--
Len Sorensen
