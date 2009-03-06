Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZCFKIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZCFKIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZCFKIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:08:00 -0500
Received: from wa4ehsobe001.messaging.microsoft.com ([216.32.181.11]:15052
	"EHLO WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751175AbZCFKH7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:07:59 -0500
X-BigFish: VPS-36(zz1432R98dR936eQ1805M936fKzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG2XGY-01-EH9-01
Date: Fri, 6 Mar 2009 11:07:41 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: msr architecture debug code
Message-ID: <20090306100741.GA12960@alberich.amd.com>
References: <1236008575.3332.2.camel@localhost.localdomain> <20090302205437.GB14471@elte.hu> <20090305135444.GB7347@alberich.amd.com> <1236262346.2527.3.camel@ht.satnam> <20090305143726.GC7347@alberich.amd.com> <1236268057.2527.23.camel@ht.satnam> <20090305182318.GE7347@alberich.amd.com> <1236278412.3316.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1236278412.3316.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Mar 2009 10:07:45.0203 (UTC) FILETIME=[650BA830:01C99E43]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 12:10:12AM +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-03-05 at 19:23 +0100, Andreas Herrmann wrote:
> > On Thu, Mar 05, 2009 at 09:17:37PM +0530, Jaswinder Singh Rajput wrote:
> > > 
> > > You are running these commands on shell when every thing is working.
> > > 
> > > What you will do if you are not getting the shell and kernel is dumping
> > > or rebooting before that.
> > 
> > In this case a deep debugfs tree with all the MSR details is not of
> > use either.
> > 
> 
> Yes, then functions from msr_debug.c will dump the details on screen if
> seq is NULL (thats why I am also using printk ;-)

There is no corresponding caller in your patch -- or did I miss it?
Where will you add it?
Maybe you are even suggesting to dump all MSRs on panic?
This wouldn't be helpful at all. Who should sort out the flood of
information when you've dumped more than 100 MSRs per core on a 16
core machine?

In contrary to that it makes sense to evaluate and print certain MSRs, e.g.
- when kernel panics due to uncorrectable MCE or
- when you are debugging specific stuff and know exactly when to check
  which MSR

In the latter case you patch the kernel anyway and then it's no burden
to add a printk directly in the debug code.


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


