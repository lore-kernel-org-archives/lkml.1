Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZF3TP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZF3TP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZF3TPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:15:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34779 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975AbZF3TPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:15:45 -0400
Date: Tue, 30 Jun 2009 22:15:45 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v4] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090630191545.GF8122@redhat.com>
References: <20090630064515.GG20289@redhat.com> <86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com> <20090630155820.GC8122@redhat.com> <m11vp18xmp.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vp18xmp.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 10:00:46AM -0700, Eric W. Biederman wrote:
> Gleb Natapov <gleb@redhat.com> writes:
> 
> > On Tue, Jun 30, 2009 at 12:18:19AM -0700, Yinghai Lu wrote:
> >> how about kexec second kernel in KVM ?
> >> 
> >> x2apic_preenabled will be set in second kernel.
> >> 
> > By the way anybody knows why kexec does not use BIOS reset code
> > (cmos 0xf offset) to jump into new kernel after hard reset?
> 
> After a hard reset.  That simply isn't possible. A hard
> reset clears everything even memory.
> 
I mean "soft reset". At least on 286 in order to move from protected
mode to real mode "soft reset" was issued via kbd controller or via
triple fault. BIOS reset code was used to avoid POST. Obviously back
than this kind of reset haven't cleared memory. I'll try to check what
happens on a modern HW.

BTW Linux sets BIOS reset code to "return by long jump" in
smpboot_setup_warm_reset() for some reason.

> You might be able to get a full cpu reset but not a reset of the I/O
> devices.
> 
> The premise of kexec is that we are doing things on our own, and don't
> get a 3rd piece of software involved that has not been heavily tested
> on the path we want to use.  Occassionally it is a pain to do everything
> ourselves but at least when we do and we test it we know it is going
> to work.
> 
> Cpu designers lately seem fond of adding features that require all
> kind of coordination to turn on and off.  We handle the hardware
> virtualization mode features now, and if x2apic has similar problems
> being turned on and off I am certain we can handle that case in a
> similar fashion.
> 
> When we can my preference is to keep code like that out of the
> kexec on panic path if we can figure out how to write the software
> to do something reasonable.
> 
> Once we figure out how to work without putting the interrupt controllers
> in legacy mode to handle the timer interrupts I expect all kinds of
> things will become simpler.
> 
If the "soft reset" method can work it worth to implemented. I am not
suggesting we should make it default (just line --real-mode is not default).

--
			Gleb.
