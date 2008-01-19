Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYASW3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYASW3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYASW3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:29:31 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:31122 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbYASW3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:29:30 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <200801191957.21832.ak@suse.de>
References: <20080118627.198787000@suse.de>
	 <20080118172720.86C4F14AAE@wotan.suse.de>
	 <1200766548.32050.32.camel@cthulhu.hellion.org.uk>
	 <200801191957.21832.ak@suse.de>
Content-Type: text/plain
Date: Sat, 19 Jan 2008 22:29:13 +0000
Message-Id: <1200781753.32050.42.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] [4/7] Convert TSC disabling to generic cpuid disable
	bitmap
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-19 at 19:57 +0100, Andi Kleen wrote:
> On Saturday 19 January 2008 19:15:48 Ian Campbell wrote:
> > diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> > index 6f5c74a..b3721fd 100644
> > --- a/arch/x86/xen/time.c
> > +++ b/arch/x86/xen/time.c
> > @@ -592,7 +592,7 @@ __init void xen_time_init(void)
> >  	set_normalized_timespec(&wall_to_monotonic,
> >  				-xtime.tv_sec, -xtime.tv_nsec);
> >  
> > -	setup_clear_cpu_cap(X86_FEATURE_TSC);
> > +	setup_force_cpu_cap(X86_FEATURE_TSC);
> 
> Actually that would be only needed if someone else disabled TSC explicitely before.
> 
> Simply deleting this should be sufficient. Does this patch work for you?

Yes.

> It would break if someone passes notsc to a Xen kernel, but then a lot of options make the kernel
> break if you don't know what you're doing so that doesn't seem like a big issue.

I'm happy either way. I think the Xen paravirt subsystem will use TSC
where it has to due to the Xen architecture regardless of this setting.

Ian.
-- 
Ian Campbell

Good day for overcoming obstacles.  Try a steeplechase.

