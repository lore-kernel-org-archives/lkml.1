Return-Path: <linux-kernel-owner+w=401wt.eu-S1760517AbYJISke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517AbYJISke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754742AbYJISkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:40:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37904 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbYJISkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:40:23 -0400
Message-ID: <48EE4FC4.7070902@redhat.com>
Date: Thu, 09 Oct 2008 14:39:00 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jeff Hansen <x@jeffhansen.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
References: <Pine.LNX.4.64.0810071640110.25661@ren> <48ECFEDC.90305@redhat.com> <Pine.LNX.4.64.0810081342570.11108@ren> <48ED1728.5060708@redhat.com> <Pine.LNX.4.64.0810081542300.14815@ren> <48ED2A89.3000902@redhat.com> <Pine.LNX.4.64.0810081554380.14982@ren> <alpine.LFD.2.00.0810090910510.3237@apollo>
In-Reply-To: <alpine.LFD.2.00.0810090910510.3237@apollo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 8 Oct 2008, Jeff Hansen wrote:
> 
>> [HRTIMER]: Add highres=noverify option to bypass clocksource verification
>>
>> This disregards the CLOCK_SOURCE_MUST_VERIFY flag on all clocksources.
>> This is particularly useful on legacy x86_32 systems that have no ACPI,
>> LAPIC, or HPET timers, where only TSC and PIT are available.
> 
> While I agree in principle, adding this to highres is the wrong thing
> to do. This is a property of clocksources and not of high resolution
> timer support.
> 
> The affected clocksource is TSC and it should go there as a command
> line option e.g. tsc=stable, which in turn clears the
> CLOCK_SOURCE_MUST_VERIFY flag in the tsc clocksource.
> 
> Thanks,
> 
> 	tglx

Fair enough, but do you think it's worthwhile to have an option to 
disable CLOCK_SOURCE_MUST_VERIFY checking for all timers, or should we 
implement this on a case-by-case basis when there's legitimate cause, 
like with TSC?

-- Chris
