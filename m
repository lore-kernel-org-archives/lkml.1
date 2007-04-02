Return-Path: <linux-kernel-owner+w=401wt.eu-S965958AbXDBVwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965958AbXDBVwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965966AbXDBVwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:52:35 -0400
Received: from www.osadl.org ([213.239.205.134]:55971 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965958AbXDBVwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:52:34 -0400
Subject: Re: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20070402213949.GD10574@sequoia.sous-sol.org>
References: <20070331083149.997762000@sous-sol.org>
	 <1175419332.28263.67.camel@localhost.localdomain>
	 <20070401185402.GZ10574@sequoia.sous-sol.org>
	 <1175549504.28263.184.camel@localhost.localdomain>
	 <20070402213949.GD10574@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Mon, 02 Apr 2007 23:52:44 +0200
Message-Id: <1175550764.28263.190.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 14:39 -0700, Chris Wright wrote:
> > > Yes, that's part of why I did some of the cleanups that way, so that we
> > > could merge the two together later.
> > 
> > I'd prefer to get this done now. If we plug it in as is, the "merge
> > later" probably will never happen.
> 
> that's fine, this is just RFC to see if there's obvious broken bits, etc.
> also, i still need to do some split out of the pit.  it and hpet are nearly
> identical though, so i don't noticing any issues with this.

Ok.

> the part i know is broken is lapic broadcast, so i'd like to fix that
> up too.  trouble is, it's broken on vanilla too, so i'm not 100% sure
> what i'm debugging yet.

You need to remove switch_APIC_timer_to_ipi and counterpart so that the
clockevents broadcast gets control over broadcasting. This requires a
change in drivers/acpi/processor_idle.c as well

commit e9e2cdb412412326c4827fc78ba27f410d837e6e has the basic changes. 

	tglx


