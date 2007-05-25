Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbXEYFoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbXEYFoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 01:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXEYFob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 01:44:31 -0400
Received: from colo.lackof.org ([198.49.126.79]:49363 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbXEYFoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 01:44:30 -0400
Date: Thu, 24 May 2007 23:44:22 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Message-ID: <20070525054422.GA23748@colo.lackof.org>
References: <m18xbrnyxi.fsf@ebiederm.dsl.xmission.com> <20070514160005.627435e3@osprey.hogchain.net> <m1odkmmft4.fsf@ebiederm.dsl.xmission.com> <20070515212200.517fcba2@osprey.hogchain.net> <m14pmcmz8r.fsf@ebiederm.dsl.xmission.com> <20070516185225.3f3ac082@osprey.hogchain.net> <m1sl9wl28m.fsf@ebiederm.dsl.xmission.com> <20070522204103.134bf5a2@osprey.hogchain.net> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com> <20070524213157.1d39458f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524213157.1d39458f.akpm@linux-foundation.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 09:31:57PM -0700, Andrew Morton wrote:
> On Thu, 24 May 2007 22:19:09 -0600 ebiederm@xmission.com (Eric W. Biederman) wrote:
> 
> > Currently we blacklist known bad msi configurations which means we
> > keep getting MSI enabled on chipsets that either do not support MSI,
> > or MSI is implemented improperly.  Since the normal IRQ routing
> > mechanism seems to works even when MSI does not, this is a bad default
> > and causes non-functioning systems for no good reason.
...
> Yup.
> 
> Do we have a feel for how much performace we're losing on those 
> systems which _could_ do MSI, but which will end up defaulting
> to not using it?

Rick Jones (HP, aka Mr Netperf.org) just recently posted some data
that happened to compare. I've clipped out thw two relevant lines below:

http://lists.openfabrics.org/pipermail/general/2007-May/035709.html


                              Bulk Transfer                  "Latency"
                          Unidir            Bidir
     Card          Mbit/s SDx   SDr   Mbit/s SDx   SDr   Tran/s SDx   SDr
---------------------------------------------------------------------------
  Myri10G IP 9k     9320  0.862 0.949 10950  1.00  0.86   19260 19.67 16.18 *
  Myri10G IP 9k msi 9320  0.449 0.672 10840  0.63  0.62   19430 11.68 11.56

original posting explains the fields.
SDx (Service Demand on Transmit) is 2x more with MSI disabled. 
SDr (Service Demand on RX) is ~50% higher with MSI disabled.
Ditto for latency metrics.

ISTR to remember seeing ~5-10% difference on tg3 NICs and ~20% with PCI-X
infiniband (all on HP ZX1 chip, bottleneck was PCI-X bus).  When I posted
a tg3 patch to linux-net (which got rejected because of tg3 HW bugs), I
did NOT include any performance numbers like I thought I did. :(

hth,
grant
