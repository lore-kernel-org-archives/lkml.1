Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZIPNrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZIPNrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZIPNrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:47:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56581 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbZIPNrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:47:40 -0400
Date: Wed, 16 Sep 2009 14:47:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Steve Chen <schen@mvista.com>,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       Marek Vasut <marek.vasut@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090916134721.GA11218@n2100.arm.linux.org.uk>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com> <20090915103739.GA19519@elf.ucw.cz> <1253017761.3273.117.camel@linux-1lbu> <200909151541.08852.marek.vasut@gmail.com> <1253032210.3273.128.camel@linux-1lbu> <94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com> <1253043875.3273.131.camel@linux-1lbu> <m3k4zzdimy.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3k4zzdimy.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 11:04:37PM +0200, Krzysztof Halasa wrote:
> Steve Chen <schen@mvista.com> writes:
> 
> > +config OLD_CPU_DELAY
> > +	depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
> > +	bool "Accurate delays"
> > +	def_bool n
> > +	help
> > +	  Enable if observing longer than expected delays and need more
> > +	  accuracy.  This only applies to older CPUs.
> > +
> 
> If it's that simple then why not enable the extra delay code
> unconditionally when compiling for those CPUs?

Because it's really not that clear cut.  Eg, ARM610 and ARM710 work
better with it, but StrongARM suffers from delays being too short.
Having a kernel configured for all those processors used to be common
(since the Acorn RiscPC had pluggable CPU cards, which could be one
of those processors.)

It's really something that only experienced people should worry
about, and not Joe "kernel-builder" Bloggs.
