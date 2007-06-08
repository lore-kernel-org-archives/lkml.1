Return-Path: <linux-kernel-owner+w=401wt.eu-S938248AbXFHPpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938248AbXFHPpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXFHPpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:45:43 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:37429 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXFHPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:45:43 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2007 11:45:42 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Subject: Re: [RFC][PATCH 1/6] Storing ipcs into radix trees
Date: Fri, 8 Jun 2007 17:40:16 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, ak@suse.de
References: <20070607165302.917616000@bull.net> <200706072137.34563.ioe-lkml@rameria.de> <46692B7E.40000@bull.net>
In-Reply-To: <46692B7E.40000@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706081740.17732.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 08 June 2007, Nadia Derbey wrote:
> Ingo Oeser wrote:
> > ... together with this means 4*256 -> 1k of precious stack space used.
> > Please consider either lowering IPCS_MAX_SCAN_ENTRIES or kmalloc() that.
> You're completely right, but trying to lower the extraction size, I'm 
> afraid this will have an impact on performances.
> 
> Here are the results of a small test I did: I have run ctxbench on both 
> the 256 and and 16 entries versions
> 
> 1) 256 entries:
> 42523679 itterations in 300.005423 seconds = 141743/sec
> 2) 16 entries:
> 41774255 itterations in 300.005334 seconds = 139245/sec

So that is around 1.8% in a benchmark. 

Not bad, if one considers, that this is an expensive syncronisation primitive 
anyway (and thus shouldn't dominate any real workload). At least _much_
better than possible stack underflow :-)

BTW: You forgot to include measurements with the unmodified code 
	as it is in Linus' tree now. They woule be a nice data point here.

> Will try with a dynamic allocation.

But than you have an additional error path 
or have to sleep until memory becomes available.

Maybe try doubling IPCS_MAX_SCAN_ENTRIES - until the performance impact
is in the noise - is simpler. Up to 64 seems acceptable.

Best Regards

Ingo Oeser
