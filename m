Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYHARsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYHARsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYHARsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:48:24 -0400
Received: from gw.goop.org ([64.81.55.164]:55908 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYHARsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:48:24 -0400
Message-ID: <48934C54.60806@goop.org>
Date: Fri, 01 Aug 2008 10:48:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Mike Travis <travis@sgi.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
       Alan Mayer <ajm@sgi.com>, Cliff Wickman <cpw@sgi.com>
Subject: Re: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
References: <20080729160939.GA4484@linux.vnet.ibm.com>	<86802c440807291135m7f8e2163xdde14545e311649a@mail.gmail.com>	<86802c440807291220t7813effcwb32ae6c18e3cddfe@mail.gmail.com>	<m1d4kwbg8f.fsf@frodo.ebiederm.org> <488F96DD.6020505@sgi.com>	<m1bq0g8euy.fsf@frodo.ebiederm.org> <488FAAD9.4090907@goop.org>	<m1vdyo44v4.fsf@frodo.ebiederm.org> <488FBAEC.5000306@goop.org> <m1fxps17bu.fsf@frodo.ebiederm.org>
In-Reply-To: <m1fxps17bu.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Sorry.  Probably too much context in my head.
> The model I use is irq sources throw interrupts and then the cpus catch them.
> Sometimes those in flight irqs go through several transformations.
>   

OK, that's more or less my mental model too.

> Given that the event channels that logical irq are bound to change over time
> I would say they appear to be not irq sources.  Those are the physical
> lines coming out of hardware devices (if physical), and the equivalent
> parts of the hardware when the irqs are sent message based.
>
> So it does sound like the event channels function much like vectors.  Which
> are the token thrown from ioapics to cpus to tell them which irq has happened
> but have nothing to do with it.
>   

Yes and no.  The event channels are similar to the actual interrupt 
wires coming out of a PCI card, but they generally connect to virtual 
devices, and so are a lot more dynamic than physical devices.  The event 
channel remapping scenario I described is pretty much exactly analogous 
to having a hotplug PCI device being pulled and then replugged into a 
different slot with a different interrupt line.

> The sources and the linux irq numbers should be stable if you don't unplug
> anything.  The rest are implementation details the architecture should hide.
>   

Yeah, plugging can happen as a quite regular thing.

> In that case I don't see any reason we could not be receiving irqs with the
> cpus catching vectors and with events showing up in event channels.  Having
> both running at the same time is a little odd but doable.
>   

Yes, it's a bit odd, but there are two distinct configurations where 
it's a useful thing to have, where the system is running in a hybrid 
Xen/native environment.

    J
