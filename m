Return-Path: <linux-kernel-owner+w=401wt.eu-S1757998AbXFVPMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998AbXFVPMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757215AbXFVPMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:12:41 -0400
Received: from mx1.suse.de ([195.135.220.2]:47191 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770AbXFVPMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:12:40 -0400
Subject: Re: ACPI Regression on Dell E1501
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Chuck Ebbert <cebbert@redhat.com>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
In-Reply-To: <467BCC3F.4080405@canonical.com>
References: <467AE7E1.4050805@canonical.com>  <467AF204.3060805@redhat.com>
	 <1182462902.3316.105.camel@chaos> <467BC9F8.5000403@canonical.com>
	 <467BCC3F.4080405@canonical.com>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Fri, 22 Jun 2007 17:12:30 +0200
Message-Id: <1182525150.28514.746.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 07:18 -0600, Tim Gardner wrote:
> Tim Gardner wrote:
> > Thomas Gleixner wrote:
> >> On Thu, 2007-06-21 at 17:47 -0400, Chuck Ebbert wrote:
> >>> On 06/21/2007 05:04 PM, Tim Gardner wrote:
> >>>> Hi,
> >>>>
> >>>> Commit e9e2cdb412412326c4827fc78ba27f410d837e6e breaks boot on a Dell
> >>>> E1501 unless 'acpi=off' is specified (also tried nolapic and nohpet but
> >>>> it made no substantive difference). This laptop is an 'AMD Turion(tm) 64
> >>>> X2 Mobile Technology TL-50' CPU, but its booting 32 bit SMP (make
> >>>> defconfig). No kernel built after this commit works for this platform.
> >>>>
> >>>> There is no crash output, it just wedges after 'NET: Registered protocol
> >>>> family 2'.
> >>>>
> >>>> How can I debug this problem?
> >>> That'll be fun.
> >>>
> >>> That's:
> >>>
> >>> 	[PATCH] clockevents: i386 drivers
> >>>
> >>> [Author cc: added]
> >> I'm going nuts on this. 
> >>
> >> Tim, 
> >>
> >> 1.) are you booting a 32bit or a 64 bit kernel ?
> >>
> >> 2.) Can you please try 2.6.22-rc5 + 
> >> http://www.tglx.de/projects/hrtimers/2.6.22-rc5/patch-2.6.22-rc5-hrt1.patch
> >> 	whether this makes any difference 
> >>
> >> Thanks,
> >>
> >> 	tglx
> >>
> > 
> > Thomas,
> > 
> > Your patch (large though it is) did not make any outward difference. As
> > usual, adding 'acpi=off' allows it to boot.
> > 
> > rtg
> 
> Perhaps I was too hasty. Adding 'acpi=off' did not allow it to boot. The
> IDE drive was detected, but I did not see any partitions detected.
> Eventually it dropped to the initrd shell when it could not find a root
> filesystem. Anyways, this is likely a side issue.

I am seeing the same with an ACER F5000.

pci=nomsi let the machine still boot.

I tried a bit and I think I got it, for me it's this one:

commit 78b7611c4a1e3ff008abc4751b566cb533d68f3d
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Fri Jun 1 00:46:33 2007 -0700

My problem: The laptop does not have an serial output device, I try to
set up a fire wire console, but might have cable/HW problems.

What else can I do to help?
What do you need?

Thanks,

   Thomas

