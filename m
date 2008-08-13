Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYHMHtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYHMHtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYHMHs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:48:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37118 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbYHMHs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:48:26 -0400
Date: Wed, 13 Aug 2008 09:39:13 +0200
From: Pavel Machek <pavel@suse.cz>
To: Milan Broz <mbroz@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
	(bisected)
Message-ID: <20080813073912.GA19877@elf.ucw.cz>
References: <20080806090246.GA1572@elf.ucw.cz> <48A1779B.5020303@redhat.com> <20080812115530.GB8806@elf.ucw.cz> <200808121634.34634.rjw@sisk.pl> <48A1A4F6.9080706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A1A4F6.9080706@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-08-12 16:57:58, Milan Broz wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday, 12 of August 2008, Pavel Machek wrote:
> >> On Tue 2008-08-12 13:44:27, Milan Broz wrote:
> >>> Pavel Machek wrote:
> >>>> Hi!
> >>>>>> On Tue, Aug 12, 2008 at 11:41:35AM +0200, Pavel Machek wrote:
> >>>>>>>>> Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
> >>>>>>>>> Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
> >>>>>>>>> shutting down.
> >>>>>>>>> Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
> >>>>>>>>>
> >>>>>>>>> ...and machine went down at that point :-(.
> >>>>>>>> I hope you can easily reproduce it?
> >>>>>>>>
> >>>>>>>> So it's new in 2.6.27rc1 and wasn't in 2.6.26? Can you please
> >>>>>>> Yes, I'm very sure. It makes machine basically unusable.
> >>>>>> Does this mean you can easily reproduce it?  
> >>>>>> Please do a bisect then. 
> >>>>>>
> >>>>>>> Not that one :-(. Thinkpad does not even have fan device: it is
> >>>>>>> controlled by hardware.
> >>>>> Hi,
> >>>>> I see exactly the same on my x60s, but during upgrade to 2.6.26.2.
> >>>> Are you sure?
> >>> yes. maybe some userspace tool controlling frequency is involved, no idea yet.
> >>> But it is 2.6.26 tree for sure.
> >> So it definitely is in 2.6.26.2, and it definitely is in 2.6.26?
> 
> 
> The bug is _not_ in 2.6.26, it was introduced in 2.6.26.1.
> 
> The problem is, that now the CPU frequency doesn't decrease at some
> temperature level and fan is unable to cool it properly.
> 
> bisect on 2.6.26.y tree finished in this patch:
> (I expect similar patch in 2.6.27-rc)
> 
> commit 04f496871e8af87a1e40c504371a206fd7389193
> Author: Thomas Renninger <trenn@suse.de>
> Date:   Wed Jul 30 18:20:10 2008 +0000
> 
>     cpufreq acpi: only call _PPC after cpufreq ACPI init funcs got called already
> 
>     commit a1531acd43310a7e4571d52e8846640667f4c74b upstream
> 
>     Ingo Molnar provided a fix to not call _PPC at processor driver
>     initialization time in "[PATCH] ACPI: fix cpufreq regression" (git
>     commit e4233dec749a3519069d9390561b5636a75c7579)
> 
>     But it can still happen that _PPC is called at processor driver
>     initialization time.
> 
>     This patch should make sure that this is not possible anymore.
> 
> 
> 
> That seems strange to me... please could anyone verify that it 
> on some other x60?

Verified. Your patch from the next email fixes the problem here.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
