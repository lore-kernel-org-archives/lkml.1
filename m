Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbXBFVmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbXBFVmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933300AbXBFVmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:42:51 -0500
Received: from www.osadl.org ([213.239.205.134]:34911 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933318AbXBFVmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:42:50 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
To: dwalker@mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1170796999.3455.43.camel@dwalker1>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos>
	 <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos>
	 <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu>
	 <1170795378.3455.31.camel@dwalker1>  <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 22:43:01 +0100
Message-Id: <1170798181.3785.32.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 13:23 -0800, Daniel Walker wrote:
> > we could make this clearer by renaming 'LOC' (which stands for 'LOCal 
> > timer interupts' and was added [and misnamed] by yours truly many moons 
> > ago) to 'apic-timer' and 'timer' to 'PIT-timer' but /that/ would be more 
> > of a userspace visible change than the change in the counter rates.
> 
> If we change the current "timer" entry to be listed as "lapic-timer" and
> not "IO-APIC-edge" (or one of the other names) and replace it with the
> count from LOC , that would make sense cause that field already changes
> depending if you have a io-apic or not ..

No. We are not fiddling with the IRQ subsystem statistics. IRQ subsystem
is unrelated to timers. And we do switch away from PIT if we have an
local apic timer, so the output of /proc/interrupt is just a mirror of
the real system and not some made up thing, which will make it harder to
debug real problems.

> I think the regression (if you can call it that) is not scripts
> crashing, but more people not know what's going on with there system .. 

I did not hear a complaint of anyone except you. I doubt that there will
be a big confusion as long as the kernel does work as expected.

	tglx


