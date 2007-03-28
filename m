Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbXC1PWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbXC1PWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXC1PWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:22:05 -0400
Received: from gw.goop.org ([64.81.55.164]:38699 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbXC1PWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:22:04 -0400
Message-ID: <460A8820.3060708@goop.org>
Date: Wed, 28 Mar 2007 08:22:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Lalancette <clalance@redhat.com>, John Hawkes <hawkes@sgi.com>
Subject: Re: [patch 3/4] Locally disable the softlockup watchdog rather than
 touching it
References: <20070327214919.800272641@goop.org> <20070327215828.085422178@goop.org> <460A6EC0.4020701@redhat.com> <460A7F57.9020006@goop.org> <460A80E6.9040003@redhat.com>
In-Reply-To: <460A80E6.9040003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava wrote:
> You don't have to do them all -- you could do one with (as in my
> previous patch -- which I'm not married to BTW ;) )
>
> touch_cpu_softlockup_watchdog()
>
> and all with
>
> touch_softlockup_watchdog()

Well, I think changing the meaning of touch_softlockup_watchdog() for
all existing callers is wrong - even if you change most of them to refer
to the cpu-local function.  There are definitely specific occasions on
which touching all CPUs is the right thing to do, but not in the general
case.

The only thing I really care about in my patches is ignoring stolen
time.  It may be that fixing that is enough to fix the reported problems
with spurious watchdog messages on tickless idle CPUs.

    J
