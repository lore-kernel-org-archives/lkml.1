Return-Path: <linux-kernel-owner+w=401wt.eu-S1752487AbYKZQRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbYKZQRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYKZQQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:16:49 -0500
Received: from www.tglx.de ([62.245.132.106]:49263 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbYKZQQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:16:47 -0500
Date: Wed, 26 Nov 2008 17:15:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
Subject: Re: [patch 06/24] perfmon: generic x86 definitions (x86)
In-Reply-To: <7c86c4470811260750n4e6737c7h4518d89269f59ecb@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811261711130.3325@localhost.localdomain>
References: <492d0be4.09b6660a.1678.ffffa78b@mx.google.com>  <alpine.LFD.2.00.0811261440330.3325@localhost.localdomain>  <7c86c4470811260619y5c4c788er61c8704a5c62d17e@mail.gmail.com>  <alpine.LFD.2.00.0811261628290.3325@localhost.localdomain>
 <7c86c4470811260750n4e6737c7h4518d89269f59ecb@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On Wed, 26 Nov 2008, stephane eranian wrote:
> > There is no harm, when the context is kept around, right ?
> >
> 
> Well, there are possibly PMU interrupts. If the monitored thread is
> active on the CPU
> by the time the tool dies, then it will keep on running with
> monitoring on, until it is
> context switched out or dies.

If the interrupt detects that the context is dead, then it can disable
the counters and be done with it. And when the thread is switched in
again it just does not enable the counters when the context is dead.

> With the approach currently implemented, the TIF bit will be set and
> as soon as the thread
> leaves the kernel for any reason,  it will execute the cleanup
> function which will stop
> monitoring and free the context.

Well, this does not guarantee that no PMU interrupts happen before it
can process the TIF bit.

> >> Another possible solution (which is not implemented):
> >>      - just let the context attached and run the thread to completion.
> >> If another tool wants to
> >>        attach to the same thread, it will detect there is already a
> >> context attached, and that it is
> >>        marked ZOMBIE, so it will clean it up. This is a lazy cleanup approach.
> >
> > Looks like ctx is a couple of hundred bytes, so just keep it around
> > until thread exit time or until the other tool does the cleanup
> > possibly by recycling the context.
> >
> That's true except for the caveat described above.

Which is fine.

Thanks,

	tglx
