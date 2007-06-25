Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbXFYI2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbXFYI2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXFYI2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:28:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59673 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXFYI2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:28:30 -0400
Date: Mon, 25 Jun 2007 01:16:24 -0700
From: Greg KH <greg@kroah.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Adrian Bunk <bunk@stusta.de>,
       david@lang.hm, David Miller <davem@davemloft.net>,
       "bunk@stusta.de; Duncan Sands" <duncan.sands@math.u-psud.fr>,
       Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: multithreaded probing - more
	parallelismcontrol
Message-ID: <20070625081624.GB23847@kroah.com>
References: <20070624070601.GB24941@kroah.com> <9D7649D18729DE4BB2BD7B494F7FEDC2180928@pdsmsx415.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D7649D18729DE4BB2BD7B494F7FEDC2180928@pdsmsx415.ccr.corp.intel.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 11:04:13PM +0800, Huang, Ying wrote:
> >From: Greg KH [mailto:greg@kroah.com]
> >I'm still not convinced that we need to add this kind of complexity to
> >the driver core, instead of just letting the individual driver
> >subsystems do this, if they want to do it.
> 
> It may appear not necessary that providing more multithreaded device
> probing in the driver core, but it seems more necessary that providing
> more parallel control in the driver core to make some device probing
> more single-threaded.
> 
> There does exist multithreaded device probing in current driver core
> implementation, supposing two devices are hot-plugged at the same time.

No, that is a bus-specific thing, and no bus that I know of supports
that at this time.

> But, many device drivers are written without this taken into account.

That's why no bus does this :)

> I think it may be better to make default device probing process more
> single-threaded in the driver core. The single-thread workqueue or some
> customized version of workqueue like that implemented by my patch can be
> used for this. The parallel control mechanism can be used to implement
> multithreaded device probing in needed subsystems too.

But remember, the individual busses already do this all in a single
thread anyway, nothing is needed in the driver core to do this.

thanks,

greg k-h
