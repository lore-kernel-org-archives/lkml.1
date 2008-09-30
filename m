Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbYI3Qqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbYI3Qqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYI3QqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:46:24 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55449 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698AbYI3QqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:46:23 -0400
Subject: Re: Use CPUID to communicate with the hypervisor.
From: Zachary Amsden <zach@vmware.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Alok Kataria <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
In-Reply-To: <48E1DF2C.9050409@redhat.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>
	 <48E15AC7.2080603@redhat.com> <1222734838.30247.102.camel@alok-dev1>
	 <48E1DF2C.9050409@redhat.com>
Content-Type: text/plain
Date: Tue, 30 Sep 2008 09:42:38 -0700
Message-Id: <1222792958.7330.16.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-30 at 01:11 -0700, Gerd Hoffmann wrote:
> Alok Kataria wrote:

> Well, that should be clearly defined, that is my point.  When asking the
> hypervisor for the tsc instead of running a calibration loop, then we
> have a small bit of paravirtualization:  The guest is aware that it runs
> on a hypervisor and just asks it directly.  So while we are at it we can
> also define a way to communicate tsc freq changes between host and
> guest, so the cost of trap'n'emulate tsc reads can be avoided.  Or we
> define "tsc is constant" and leave it to the hypervisor to make sure it

For our purposes, we define TSC is constant.

> actually appears being constant to the guest, even in case it changes on
> the host.  But it must be defined one way or another, so the guest knows
> whenever it should expect the tsc frequency change or not.  And in case
> we allow tsc changes, we also need a way to signal that to the guest.

Non-constant TSCs probably won't want to use CPUID based retreival, due
to the extra trap it would require to read TSC frequency, it can't be
done at every TSC read (or else, virtualizing TSC frequency has the same
cost and you haven't won anything by making it dynamic).  It's also not
clean to issue interrupts to the guest telling it TSC frequency has
changed because the guest may not notice the interrupt before making
computations using the old value, and multiple rapid changes would
require multiple interrupt injections for each affected guest.

> Is the tsc cpu leaf interface set in stone already (aka implemented in
> vmware versions released to public)?

Not to my knowledge.

Zach

