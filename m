Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYJIHP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYJIHP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYJIHPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:15:14 -0400
Received: from www.tglx.de ([62.245.132.106]:54297 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYJIHPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:15:13 -0400
Date: Thu, 9 Oct 2008 09:14:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Hansen <x@jeffhansen.com>
cc: Chris Snook <csnook@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] Re: x86_32 tsc/pit and hrtimers
In-Reply-To: <Pine.LNX.4.64.0810081554380.14982@ren>
Message-ID: <alpine.LFD.2.00.0810090910510.3237@apollo>
References: <Pine.LNX.4.64.0810071640110.25661@ren> <48ECFEDC.90305@redhat.com> <Pine.LNX.4.64.0810081342570.11108@ren> <48ED1728.5060708@redhat.com> <Pine.LNX.4.64.0810081542300.14815@ren> <48ED2A89.3000902@redhat.com>
 <Pine.LNX.4.64.0810081554380.14982@ren>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Oct 2008, Jeff Hansen wrote:

> [HRTIMER]: Add highres=noverify option to bypass clocksource verification
> 
> This disregards the CLOCK_SOURCE_MUST_VERIFY flag on all clocksources.
> This is particularly useful on legacy x86_32 systems that have no ACPI,
> LAPIC, or HPET timers, where only TSC and PIT are available.

While I agree in principle, adding this to highres is the wrong thing
to do. This is a property of clocksources and not of high resolution
timer support.

The affected clocksource is TSC and it should go there as a command
line option e.g. tsc=stable, which in turn clears the
CLOCK_SOURCE_MUST_VERIFY flag in the tsc clocksource.

Thanks,

	tglx


