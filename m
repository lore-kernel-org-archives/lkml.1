Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290AbYJAEfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbYJAEfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 00:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbYJAEfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 00:35:11 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:47424 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbYJAEfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 00:35:10 -0400
Subject: [Hypervisors] TSC frequency change
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>,
       "Jun.Nakajima@Intel.Com" <Jun.Nakajima@Intel.Com>
In-Reply-To: <48E1DF2C.9050409@redhat.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>
	 <48E15AC7.2080603@redhat.com> <1222734838.30247.102.camel@alok-dev1>
	 <48E1DF2C.9050409@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 30 Sep 2008 21:35:09 -0700
Message-Id: <1222835709.32162.26.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[was Re: Use CPUID to communicate with the hypervisor.]

On Tue, 2008-09-30 at 01:11 -0700, Gerd Hoffmann wrote:
> Alok Kataria wrote:
> > Hi Gerd,
> >
> > I really fail to see your point here. Maybe you can point out what am i
> > missing.
> > Think about the current situation, whenever there is migration to such a
> > tsc-is-different system , how does the guest come to know about the
> > frequency change, either through a $event or if it reboots it runs the
> > calibration algorithm.
> 
> Well, that should be clearly defined, that is my point.  When asking the
> hypervisor for the tsc instead of running a calibration loop, then we
> have a small bit of paravirtualization:  The guest is aware that it runs
> on a hypervisor and just asks it directly.  So while we are at it we can
> also define a way to communicate tsc freq changes between host and
> guest, so the cost of trap'n'emulate tsc reads can be avoided.  Or we
> define "tsc is constant" and leave it to the hypervisor to make sure it
> actually appears being constant to the guest, even in case it changes on
> the host.  But it must be defined one way or another, so the guest knows
> whenever it should expect the tsc frequency change or not. 

Hi Gerd,

As Zach explained, we support a view that, tsc is constant. This  Timing
CPUID leaf should be just seen as a way to get the current TSC from the
hypervisor. Also, one thing to note would be that, this interface allows
us to reinitialize the TSC frequency if the need is felt.

Coming back to the migration problem, as you too acknowledge, migration
to a host with a different frequency should be seen as a different
problem. I would be interested in learning about any proposal that you
may have thought about to handle this.

> 
> Is the tsc cpu leaf interface set in stone already (aka implemented in
> vmware versions released to public)?

Yep, this interface is already implemented in the VMware workstation 6.5
product.

> 
> > What special things does Xen do at migration, which would be affected by
> > this interface ?
> 
> paravirtualized xen guests have a paravirtual clock.  That is a struct
> containing three pieces of information: system time, tsc counter for the
> last system time update, tsc frequency.  The guest gets the current time
> by reading the system time and adding a delta calculated from current
> tsc, tsc of last systime update and tsc frequency.  Handling tsc
> frequency changes is obviously trivial here, just update the field on
> the next systime update ;)

Oh nice, that is convenient. 

Thanks,
Alok


