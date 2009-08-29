Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZH2RDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZH2RDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 13:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZH2RDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 13:03:48 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25793 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZH2RDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 13:03:48 -0400
Message-ID: <4A995F53.50509@hp.com>
Date: Sat, 29 Aug 2009 13:03:15 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Rik van Riel <riel@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org> <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain> <4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com> <4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com> <alpine.LFD.2.00.0908281218560.2888@localhost.localdomain> <alpine.DEB.1.10.0908281446520.7317@gentwo.org> <alpine.LFD.2.00.0908282100040.19335@localhost.localdomain> <alpine.DEB.1.10.0908281551450.17784@gentwo.org> <alpine.LFD.2.00.0908282158100.19335@localhost.localdomain> <alpine.DEB.1.10.0908281619520.15573@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0908281619520.15573@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 28 Aug 2009, Thomas Gleixner wrote:
>> What slab queue stuff is running on timers and cannot be switched off
>> in such a context?
> 
> slab does run a timer every 2 second to age queues. If there was activity
> then there can be a relatively long time in which we periodically throw
> out portions of the cached data.

OK, you have me fully confused now.

 From other HPC people, I know the "no noise in my math application"
requirement.  But that means the user code that is running on the
CPU must not do anything that wakes the kernel.  Not even page faults,
so they pin the memory at job start.

Anything the user code does that needs kernel statistics or
kernel action is "I must fix my user code", or "I accept that
the noise is necessary".

So we don't need to offload stats to other CPUs, stats are not needed.

>> Device specific stuff should not happen on such a CPU when there is no
>> device handled on it.
> 
> The device may periodically check for conditions that require action.

Again, what is this device and why is it controlled directly by
user-space code.  Devices should be controlled even in an HPC
environment by the kernel.  AFAIK HPC wants the kernel to be the
bootstrap and data transfer manager running on a small subset of
the total CPUs, with the dedicated CPUs running math jobs.

jim
