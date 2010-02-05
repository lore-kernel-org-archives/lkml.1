Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab0BEQW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 11:22:27 -0500
Received: from jgarrett.org ([64.5.53.252]:45920 "EHLO jgarrett.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933361Ab0BEQWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 11:22:25 -0500
Date: Fri, 5 Feb 2010 10:22:23 -0600
To: peng huang <huangpeng.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100205162223.GB2736@jgarrett.org>
References: <20100126084740.GA5265@jgarrett.org> <1264509660.29891.7.camel@huang-laptop> <20100126145951.GA4987@jgarrett.org> <1264598837.32649.9.camel@huang-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1264598837.32649.9.camel@huang-laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jeff Garrett <jeff@jgarrett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 10:27:17PM +0900, peng huang wrote:
> 2010-01-26 (火) の 08:59 -0600 に Jeff Garrett さんは書きました:
> > On Tue, Jan 26, 2010 at 09:41:00PM +0900, peng huang wrote:
> > > Hi,
> > > can you show me the file /proc/acpi/processor/CPU*/power.
> > > and are you sure your cpu usage is 0 or nearly zero.
> > 
> > Yea, I'm pretty sure my cpu usage is nearly zero.  powertop shows fewer
> > than 20 wakeups per second, shows 99% C2 residency, top shows 100% idle,
> > perf top shows acpi_idle_enter_simple as the most common function
> > (~50%).  Very little is running on the box, and I've compiled out the
> > heavier parts of the kernel (such as USB)...
> > 
> > (It still has ordinary userspace running, e.g. udev & hal, and still has
> > sshd and network traffic, as examples.)
> > 
> > This is all consistent with a very idle machine, I think.
> 
> yes,you processor is always in c2,it does means your system is nearly
> ilde.
> 
> > > this is the info of my laptop(using core 2 processors):
> > > powertop's output:
> > > Cn                Avg residency       P-states (frequencies)
> > > C0 (cpu running)        (10.6%)         2.00 Ghz     1.9%
> > > C0                0.0ms ( 0.0%)         1.67 Ghz     0.1%
> > > C1 mwait          0.0ms ( 0.0%)         1333 Mhz     0.0%
> > > C2 mwait          0.0ms ( 0.0%)         1000 Mhz    98.0%
> > > C3 mwait          1.1ms (89.4%)
> > 
> > Yea, my laptop also (also core 2) has 700-1000 wakeups/sec and spends
> > greater than 80% of its time in C3...  That's partly why I'm curious
> > about what my core i7 desktop is doing.
> 
> So I think it is a core i7 thing.I have heard that some intel cpu have a
> problem when in c2-state,maybe that is why you cpu cant enter c3-state.
> I think there is some configuration about deep c-state in the bios,may
> be you can try it(it cannot solve this problem...).

My BIOS has very few options.  Almost nothing with regard to
power management.  They do let me choose whether to enable
Intel SpeedStep.  They also let me choose which state to use
for ACPI suspend (set to S3) but that appears to be it.

> And in some bios there is a enhanced idle state configuration ,but i
> dont known if it is the reason why the cpu cannot enter c3-state.You can
> try it anyway.

I would if I could.  :)

> With disable the deep c-state you BIOS will not give c3-info to the
> OS,then you would see there is no c3-state in the OS.

I also found a thread (I think LKML) which said the max c-state is
limited when HT is disabled.  I had HT disabled in the BIOS.

Re-enabling HT in the BIOS (with CONFIG_X86_HT=y) doesn't
appear to make any difference.

Thanks,
Jeff
