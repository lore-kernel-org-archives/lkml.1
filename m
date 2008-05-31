Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYFAOqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYFAOqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYFAOpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:45:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4289 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752721AbYFAOpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:45:11 -0400
Date: Sat, 31 May 2008 22:45:42 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] Kill unused parameter to smp_call_function and friends
Message-ID: <20080531204541.GK5405@ucw.cz>
References: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com> <20080529114132.663eff4b@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529114132.663eff4b@core>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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
> One of the joys of the older x86 APIC setups is the APIC messaging bus.
> This can get checksum errors in which case the message is retransmitted:
> 
> In the specific case a message is retransmitted and there are at least
> three parties on the bus (2 CPU APICs and an IOAPIC is enough) you can
> get a situation where one receiver gets the message the second receiver
> errors it and the retransmit causes the IPI to be repeated which causes
> the IPI to be redelivered.

Does that mean smp_call_function on i386 should have a bitmap of cpus
the message was already delivered to, and drop the duplicates?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
