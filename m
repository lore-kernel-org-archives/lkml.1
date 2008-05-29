Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYE2Lr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYE2Lr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 07:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYE2LrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 07:47:21 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10635 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYE2LrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 07:47:21 -0400
Date: Thu, 29 May 2008 13:47:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] Kill unused parameter to smp_call_function and  friends
Message-ID: <20080529114717.GA25504@kernel.dk>
References: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com> <20080529114132.663eff4b@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529114132.663eff4b@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29 2008, Alan Cox wrote:
> On Thu, 29 May 2008 11:00:59 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Hi,
> > 
> > It bothers me how the smp call functions accept a 'nonatomic' or 'retry'
> > parameter (depending on who you ask), but don't do anything with it.
> > So kill that silly thing.
> > 
> > Two patches here, one for smp_call_function*() and one for on_each_cpu().
> > This patchset applies on top of the generic-ipi patchset just sent out.
> 
> Which leads to notice that we seem to have acquired a bug somewhere on
> the way. smp_call_function on x86 is it seems to me implemented as
> "smp_call_function and occasionally run it multiple times"
> 
> One of the joys of the older x86 APIC setups is the APIC messaging
> bus.  This can get checksum errors in which case the message is
> retransmitted:
> 
> In the specific case a message is retransmitted and there are at least
> three parties on the bus (2 CPU APICs and an IOAPIC is enough) you can
> get a situation where one receiver gets the message the second
> receiver errors it and the retransmit causes the IPI to be repeated
> which causes the IPI to be redelivered.
> 
> This used to turn up now and then - particularly on 440BX boards.

That's worrisome, but I would regard that as implementation detail
for the architecture, you really cannot expect the caller to
deal with such obscure behaviour.

Did the x86 code ever deal with this? Were the transmit errors
corner case errors, or could they occur during normal runtime
when everything is/was otherwise OK?

> Alan Gnome #331: Early SMP Implementation Archive Office

;-)

I suggest such behaviour be punished by way of catapult, old
clerk guy.

-- 
Jens Axboe

