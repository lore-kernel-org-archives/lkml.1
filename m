Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZIQTmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZIQTmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZIQTmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:42:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34409 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbZIQTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:42:06 -0400
Date: Thu, 17 Sep 2009 20:41:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Lokier <jamie@shareable.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Steve Chen <schen@mvista.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       linux-kernel@vger.kernel.org, Marek Vasut <marek.vasut@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090917194119.GA12510@n2100.arm.linux.org.uk>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <20090915103739.GA19519@elf.ucw.cz> <1253017761.3273.117.camel@linux-1lbu> <200909151541.08852.marek.vasut@gmail.com> <1253032210.3273.128.camel@linux-1lbu> <94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com> <1253043875.3273.131.camel@linux-1lbu> <m3k4zzdimy.fsf@intrepid.localdomain> <20090916134721.GA11218@n2100.arm.linux.org.uk> <20090917193257.GA10599@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917193257.GA10599@shareable.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 08:32:57PM +0100, Jamie Lokier wrote:
> Russell King - ARM Linux wrote:
> > On Tue, Sep 15, 2009 at 11:04:37PM +0200, Krzysztof Halasa wrote:
> > > Steve Chen <schen@mvista.com> writes:
> > > 
> > > > +config OLD_CPU_DELAY
> > > > +	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
> > > > +	bool "Accurate delays"
> > > > +	def_bool n
> > > > +	help
> > > > +	  Enable if observing longer than expected delays and need more
> > > > +	  accuracy.  This only applies to older CPUs.
> > > > +
> > > 
> > > If it's that simple then why not enable the extra delay code
> > > unconditionally when compiling for those CPUs?
> > 
> > Because it's really not that clear cut.  Eg, ARM610 and ARM710 work
> > better with it, but StrongARM suffers from delays being too short.
> > Having a kernel configured for all those processors used to be common
> > (since the Acorn RiscPC had pluggable CPU cards, which could be one
> > of those processors.)
> > 
> > It's really something that only experienced people should worry
> > about, and not Joe "kernel-builder" Bloggs.
> 
> I'm confused now.  If I'm building a "generic" kernel to run on
> several different systems, including some ARM710s and some StrongARMs,
> do I include the code or not?

You should not - because with the code enabled, StrongARM will violate
the guarantee that udelay() shall return after _at_ _least_ the delay
asked for.

However, for short delays, ARM710 will provide a delay unnecessarily in
excess of the requested delay - which conforms to the required guarantee
but is not desirable for some applications (eg, where you're using
udelay() to time hardware signals for clocking data.)

> Btw, do you know where PT110 fits in?  Is it like StrongARM (SA110)?

No idea.
