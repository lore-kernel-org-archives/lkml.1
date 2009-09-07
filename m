Return-Path: <linux-kernel-owner+w=401wt.eu-S1751679AbZIGTrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbZIGTrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 15:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZIGTrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 15:47:39 -0400
Received: from mail-yw0-f141.google.com ([209.85.211.141]:47250 "EHLO
	mail-yw0-f141.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZIGTrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 15:47:39 -0400
MIME-Version: 1.0
Date: Mon, 7 Sep 2009 12:47:41 -0700 (PDT)
In-Reply-To: <cVZ3a-71r-5@gated-at.bofh.it>
X-IP: 82.0.91.38
References: <cT8cF-7kN-7@gated-at.bofh.it> <cVZ3a-71r-5@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-Via: 1.1 home (squid/3.0.STABLE8)
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.2) 
	Gecko/20090810 Ubuntu/9.10 (karmic) Firefox/3.5.2,gzip(gfe),gzip(gfe)
Message-ID: <10928a87-c449-4401-8765-9e297ca13a0b@y9g2000yqn.googlegroups.com>
Subject: Re: sdhci can turn off irq up to 200 ms
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 9, 11:30 am, Matthieu CASTET <matthieu.cas...@parrot.com>
wrote:
> Matthieu CASTET a écrit :
>
> > Hi,
>
> > sdhci code got tasklets (sdhci_tasklet_card and sdhci_tasklet_finish),
> > that does :
> > {
> > spin_lock_irqsave
>
> > if (cond) {
> > sdhci_reset
> > sdhci_reset
> > }
>
> > spin_unlock_irqrestore
> > }
>
> > The problem is that sdhci_reset [1] does busy pooling on a register up
> > to a timeout of 100 ms.
> > That's not low latency friendly.
>
> > On our system, we saw that sdhci_reset take 1 ms. That should be because
> > we enter in mdelay, even if the hardware clears the bit faster.
> > I wonder why there is an mdelay(1). Using cpu_relax and
> > time_is_after_jiffies should make sdhci_reset faster.
>
> In case somebody cares, here a patch that reduce on our hardware
> sdhci_reset from 1 ms to 30 us.

On my Core2Duo, cpu_relax (implementing rep;nop) takes 3.2ns, but a
(synchronous) read over the PCI bus takes 0.5-1us, so it's hard to say
how much benefit the cpu_relax call will give, or am I missing
something?

If the code is reading from a memory location, or perhaps writing to
non-writethrough memory, it's a different story.

Daniel
--
Daniel J Blueman
