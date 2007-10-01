Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbXJATRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbXJATRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbXJATRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:17:08 -0400
Received: from mail.suse.de ([195.135.220.2]:53005 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJATRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:17:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Date: Mon, 1 Oct 2007 21:16:59 +0200
User-Agent: KMail/1.9.6
Cc: David Bahi <dbahi@novell.com>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Gregory Haskins <GHaskins@novell.com>
References: <46FA4A800200006C000192FE@sinclair.provo.novell.com> <200710011936.01528.ak@suse.de> <alpine.LFD.0.9999.0710012052310.20478@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710012052310.20478@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710012116.59356.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007 20:54:21 Thomas Gleixner wrote:
> On Mon, 1 Oct 2007, Andi Kleen wrote:
> 
> > On Wednesday 26 September 2007 20:03:12 David Bahi wrote:
> > > Thanks to tglx and ghaskins for all the help in tracking down a very
> > > early nmi_watchdog crash on certain x86_64 machines.
> > 
> > The patch is totally bogus. irq 0 doesn't say anything about whether
> > the current CPU still works or not. You always need some local
> > interrupt. This basically disables the NMI watchdog for the non boot CPUs.
> > 
> > It's even wrong on i386 -- i wonder how that broken patch
> > made it in there. I'll remove it there.
> 
> Right, it's wrong for the broadcast case, but simply removing it will
> trigger false positives on the CPU which runs the broadcast timer. I
> fix this proper.

I already did this here by checking for cpu != 0. But it also needs either tracking
or forbidding migrations of irq 0. I can take care of the patch.

-Andi 
