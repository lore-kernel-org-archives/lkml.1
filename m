Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbXJASyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbXJASyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXJASy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:54:29 -0400
Received: from www.tglx.de ([62.245.132.106]:43810 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJASy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:54:28 -0400
Date: Mon, 1 Oct 2007 20:54:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: David Bahi <dbahi@novell.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Gregory Haskins <GHaskins@novell.com>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
In-Reply-To: <200710011936.01528.ak@suse.de>
Message-ID: <alpine.LFD.0.9999.0710012052310.20478@localhost.localdomain>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710011936.01528.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Andi Kleen wrote:

> On Wednesday 26 September 2007 20:03:12 David Bahi wrote:
> > Thanks to tglx and ghaskins for all the help in tracking down a very
> > early nmi_watchdog crash on certain x86_64 machines.
> 
> The patch is totally bogus. irq 0 doesn't say anything about whether
> the current CPU still works or not. You always need some local
> interrupt. This basically disables the NMI watchdog for the non boot CPUs.
> 
> It's even wrong on i386 -- i wonder how that broken patch
> made it in there. I'll remove it there.

Right, it's wrong for the broadcast case, but simply removing it will
trigger false positives on the CPU which runs the broadcast timer. I
fix this proper.

    tglx
