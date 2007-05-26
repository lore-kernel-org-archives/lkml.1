Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbXEZGwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbXEZGwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 02:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbXEZGw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 02:52:29 -0400
Received: from colo.lackof.org ([198.49.126.79]:55278 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbXEZGw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 02:52:29 -0400
Date: Sat, 26 May 2007 00:52:20 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Jonathan Lundell <linux@lundell-bros.com>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@ninex.eu.org>, ninex@o2.pl,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
Message-ID: <20070526065220.GB19177@colo.lackof.org>
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org> <m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com> <20070524213157.1d39458f.akpm@linux-foundation.org> <200705250751.45738.ak@suse.de> <036B6511-FC30-4F81-98E7-C86F6993D618@lundell-bros.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <036B6511-FC30-4F81-98E7-C86F6993D618@lundell-bros.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 01:16:57PM -0700, Jonathan Lundell wrote:
> On May 24, 2007, at 10:51 PM, Andi Kleen wrote:
> 
> >>Do we have a feel for how much performace we're losing on those
> >>systems which _could_ do MSI, but which will end up defaulting
> >>to not using it?
> >
> >At least on 10GB ethernet it is a significant difference; you usually
> >cannot go anywhere near line speed without MSI
> >
> >I suspect it is visible on high performance / multiple GB NICs too.
> 
> Why would that be? As the packet rate goes up and NAPI polling kicks  
> in, wouldn't MSI make less and less difference?

CPUs are so fast now that we never even get into polling mode.
So MSI makes even more of a difference.

davem and jamal hadi salim were already years ago seeing workloads
(packet rates) where the CPU utilization would peak at packet rates
that were just high enough for NAPI to occasionally be used.
IIRC, Jamal's OLS 2005 or 2006 paper talks about this behavior.


> I like the fact that MSI gives us finer control over CPU affinity  
> than many INTx implementations, but that's a different issue.

Yes, I agree.

thanks,
grant
