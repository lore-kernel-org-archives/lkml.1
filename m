Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbZGaLst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbZGaLst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 07:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZGaLst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 07:48:49 -0400
Received: from mail-a03.ithnet.com ([217.64.83.98]:41719 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752572AbZGaLss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 07:48:48 -0400
X-Sender-Authentication: net64
Date: Fri, 31 Jul 2009 13:48:43 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: David Rientjes <rientjes@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "David S. Miller" <davem@davemloft.com>
Subject: Re: [Bug #13648] nfsd: page allocation failure
Message-Id: <20090731134843.6ea9d3dd.skraw@ithnet.com>
In-Reply-To: <alpine.DEB.2.00.0907301423250.18531@chino.kir.corp.google.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera>
	<H5-1lZIIeYK.A.HXG.DXObKB@chimera>
	<20090727130420.1514cf5c.skraw@ithnet.com>
	<alpine.DEB.2.00.0907301423250.18531@chino.kir.corp.google.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 14:30:42 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 27 Jul 2009, Stephan von Krawczynski wrote:
> 
> > This is no regression between 2.6.29 and 2.6.30.
> > In fact we could reproduce the problem with kernel versions:
> > 
> > 2.6.27.26 < X <= 2.6.30.3
> > 
> > (Meaning 2.6.27.26 is the last one _not_ showing the problem).
> > 
> 
> And 2.6.28.10 is showing the exact same problem as initially reported, 
> right?

Yes, that is correct.
 
> I noticed your /var/log/messages is showing you're using slub as opposed 
> to slab (which Justin was using, and causing order-0 allocations errors).  
> SLUB uses order-1 allocations for this cache growth and it's failing 
> because of memory fragmentation, not because you're truly oom.

Originally I used slab, and as someone wanted me to test slub I tried. The
results looked pretty much the same to me.
 
> The only thing that is immediately apparent that changed in this path over 
> these kernel versions (there were significant changes to e1000e) is the 
> CRC stripping.  If it's loaded as a module, perhaps you could try
> 
> 	modprobe e1000e CrcStripping=0,0
> 
> (assuming you have two adapters).

I will try that.
 
> I've cc'd some relevant e1000e driver people in the hopes they'll be able 
> to diagnose this problem.  Memory fragmentation as the result of page 
> group changes wouldn't affect order-0 allocations such as this on slab, so 
> it's doubtful the VM regressed if you can reproduce the problem with 
> CONFIG_SLAB.

I can, as said before, the problem first showed up with slab.


-- 
Regards,
Stephan
