Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYHYUeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYHYUeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 16:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYHYUe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 16:34:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39893 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYHYUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 16:34:27 -0400
Date: Mon, 25 Aug 2008 22:36:49 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080825203649.GH26610@one.firstfloor.org>
References: <48AE20B8.9000204@kernel.org> <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com> <48B19799.6090703@kernel.org> <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com> <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com> <20080824181304.GA5963@redhat.com> <20080825183611.GE26610@one.firstfloor.org> <20080825185450.GD11894@redhat.com> <20080825193926.GF26610@one.firstfloor.org> <20080825195029.GA27030@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825195029.GA27030@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On some systems (for which there aren't BIOS updates) the trip points are
> set too low.  

There were patches floating to make this configurable. I was always
a little sceptical of them, but they exist.

> If we get a thermal event that was caused by temporary
> increased workload, temperature will drop off again when that workload
> is complete.

But none of the cpufreq governours do this. They only care about
load, not about temperature.

> For sustained workloads we'd get additional thermal events, at which
> time we make a decision "ok, we've throttled as far as we can, and
> things are still going badly, power off".

That is what the ACPI driver does when the trip point is reached.

> In the event of a failed fan or similar, shutting down is obviously
> the right thing to do, and we'd get further thermal events after
> throttling which would allow us to do so.

So you're saying processor_thermal should let the system cook
for some time first before really taking action?

-Andi
