Return-Path: <linux-kernel-owner+w=401wt.eu-S965978AbXDBWYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965978AbXDBWYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965981AbXDBWYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:24:42 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36223 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965978AbXDBWYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:24:41 -0400
Date: Mon, 2 Apr 2007 15:17:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] x86_64: enable clockevents and dynticks
Message-ID: <20070402221742.GE10574@sequoia.sous-sol.org>
References: <20070331083149.997762000@sous-sol.org> <1175419332.28263.67.camel@localhost.localdomain> <20070401185402.GZ10574@sequoia.sous-sol.org> <1175549504.28263.184.camel@localhost.localdomain> <20070402213949.GD10574@sequoia.sous-sol.org> <1175550764.28263.190.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175550764.28263.190.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> On Mon, 2007-04-02 at 14:39 -0700, Chris Wright wrote:
> > the part i know is broken is lapic broadcast, so i'd like to fix that
> > up too.  trouble is, it's broken on vanilla too, so i'm not 100% sure
> > what i'm debugging yet.
> 
> You need to remove switch_APIC_timer_to_ipi and counterpart so that the
> clockevents broadcast gets control over broadcasting. This requires a
> change in drivers/acpi/processor_idle.c as well
> 
> commit e9e2cdb412412326c4827fc78ba27f410d837e6e has the basic changes. 

Yeah, I saw that, and while I didn't remove it yet, it shouldn't be
getting called from anywhere because of CONFIG_GENERIC_CLOCKEVENTS
being set.  In fact, acpi_propagate_timer_broadcast() does get called,
and all that does it drop me back to hpet because of C3.  But, I didn't add
DUMMY yet, and I must've missed smth else.  Some of that got a little
tangled into the nice calibration cleanup, which I didn't want to suck
in until I understood what I had broken ;-)

thanks,
-chris
