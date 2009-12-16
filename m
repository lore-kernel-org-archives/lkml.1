Return-Path: <linux-kernel-owner+w=401wt.eu-S934584AbZLPHSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934584AbZLPHSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934031AbZLPHS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:18:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:34486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933636AbZLPHS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:18:29 -0500
Subject: Re: [Next] CPU Hotplug test failures on powerpc
From: Peter Zijlstra <peterz@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <4B288413.2070704@in.ibm.com>
References: <4B2224C7.1020908@in.ibm.com>
	 <7b6bb4a50912152225p4f5dde13re83c439407c16eaf@mail.gmail.com>
	 <4B288131.2050306@in.ibm.com>
	 <7b6bb4a50912152245v61a7f1ebgb41f4857134f3476@mail.gmail.com>
	 <4B288413.2070704@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 08:18:10 +0100
Message-ID: <1260947890.8023.1281.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 12:24 +0530, Sachin Sant wrote:
> Xiaotian Feng wrote:
> > On Wed, Dec 16, 2009 at 2:41 PM, Sachin Sant <sachinp@in.ibm.com> wrote:
> >   
> >> Xiaotian Feng wrote:
> >>     
> >>> Does this testcase hotplug cpu 0 off?
> >>>
> >>>       
> >> No, i don't think so. It skips cpu0 during online/offline
> >> process.
> >>     
> >
> > Then how could this happen ? Looks like cpu 0 is offline ....
> > 0:mon> <4>IRQ 17 affinity broken off cpu 0
> > <4>IRQ 18 affinity broken off cpu 0
> > <4>IRQ 19 affinity broken off cpu 0
> > <4>IRQ 264 affinity broken off cpu 0
> > <4>cpu 0 (hwid 0) Ready to die...
> > <7>clockevent: decrementer mult[83126e97] shift[32] cpu[0]
> >   
> Sorry i was looking at only one script. Looking more closely
> at the test there are 6 different sub tests. The rest of the
> tests do seem to hotplug CPU 0.

Ooh, cute, so you can actually hotplug cpu 0.. no wonder that didn't get
exposed on x86.

Still, the only time cpu_active_mask should not be equal to
cpu_online_mask is when we're in the middle of a hotplug, we clear
active early and set it late, but its all done under the hotplug mutex,
so we can at most have 1 cpu differences with online mask.

Unless of course, I messed up, which appears to be rather likely given
these problems ;-)

