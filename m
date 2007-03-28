Return-Path: <linux-kernel-owner+w=401wt.eu-S1751663AbXC1NgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbXC1NgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXC1NgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:36:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbXC1NgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:36:07 -0400
Message-ID: <460A6EC0.4020701@redhat.com>
Date: Wed, 28 Mar 2007 09:33:52 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Lalancette <clalance@redhat.com>, John Hawkes <hawkes@sgi.com>
Subject: Re: [patch 3/4] Locally disable the softlockup watchdog rather than
 touching it
References: <20070327214919.800272641@goop.org> <20070327215828.085422178@goop.org>
In-Reply-To: <20070327215828.085422178@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jeremy Fitzhardinge wrote:
>
> I haven't really worked out how this should interact with the nmi
> watchdog; touch_nmi_watchdog() still ends up calling
> touch_softlockup_watchdog(), so there's still some redundancy here.
>
>   

touch_nmi_watchdog is attempting to tickle _all_ CPUs softlockup watchdogs.

Currently, the code is incorrect -- it is calling 
touch_softlockup_watchdog which touches only the current CPU's 
softlockup watchdog.

I don't like the idea of having touch_softlockup_watchdog exported with 
your new code -- we still have two methods of effecting the softlockup 
watchdog and that's confusing and its going to cause serious problems 
down the road.  The nmi watchdog code seems fine with just touching the 
CPU's nmi watchdogs.

Is there a reason that you're pushing the enable/disable?  All the cases 
called out seem to be just fine with calls to either effect that CPU's 
softlockup watchdog or doing all CPU's softlockup watchdogs.  I'm not 
sure I see the benefit of complicating the softlockup watchdog code with 
this ...

I agree with the first patch of this set -- it makes sense.  But beyond 
that I'm not convinced the rest of the code is needed ... IMO.

P.
