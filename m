Return-Path: <linux-kernel-owner+w=401wt.eu-S965518AbXBFVX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518AbXBFVX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965481AbXBFVX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:23:26 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:12231 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965518AbXBFVXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:23:25 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070206210959.GC25430@elte.hu>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos>
	 <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos>
	 <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu>
	 <1170795378.3455.31.camel@dwalker1>  <20070206210959.GC25430@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 13:23:19 -0800
Message-Id: <1170796999.3455.43.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 22:09 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > it's quite easy to explain: because of the new dynticks feature. 
> > > Both 'timer' and 'LOC' counts go way down.
> > 
> > I don't have that enabled tho .. This is with HRT/dynamic tick both 
> > off..
> 
> your kernel utilizes the kernelin a more optimal way: the new 
> clockevents code now utilizes the local APIC timer irq (represented by 
> the LOC field) for periodic interrupts. The local APIC timer irq has a 
> cost of ~2 usecs per IRQ, while the PIT irq is ~10 usecs per irq. With 
> HZ=1000 this means savings of ~8000 usecs per second - i.e. 8 msecs per 
> second, which is 0.8% more raw CPU power available - which isnt that 
> bad.

I'm happy it's better .. I'm not saying it's worse .

> we could make this clearer by renaming 'LOC' (which stands for 'LOCal 
> timer interupts' and was added [and misnamed] by yours truly many moons 
> ago) to 'apic-timer' and 'timer' to 'PIT-timer' but /that/ would be more 
> of a userspace visible change than the change in the counter rates.

If we change the current "timer" entry to be listed as "lapic-timer" and
not "IO-APIC-edge" (or one of the other names) and replace it with the
count from LOC , that would make sense cause that field already changes
depending if you have a io-apic or not ..

I think the regression (if you can call it that) is not scripts
crashing, but more people not know what's going on with there system .. 

Daniel

