Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbZDFVOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbZDFVOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759379AbZDFVN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:13:28 -0400
Received: from waste.org ([66.93.16.53]:39126 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759366AbZDFVN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:13:26 -0400
Subject: Re: IRQF_SAMPLE_RANDOM question...
From: Matt Mackall <mpm@selenic.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Peterson <cpeterso@cpeterso.com>
In-Reply-To: <200904061430.26276.rgetz@blackfin.uclinux.org>
References: <200904061430.26276.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 12:01:23 -0700
Message-Id: <1239044483.14392.55.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 14:30 -0400, Robin Getz wrote:
> Although there was some discussion  
> http://thread.gmane.org/gmane.linux.kernel/680723
> 
> about removing IRQF_SAMPLE_RANDOM from the remaining network drivers in May of 
> 2008, but they still appears to be there in 2.6.29.
> 
> drivers/net/ibmlana.c
> drivers/net/macb.c
> drivers/net/3c523.c
> drivers/net/3c527.c
> drivers/net/netxen/netxen_nic_main.c
> drivers/net/cris/eth_v10.c
> drivers/net/xen-netfront.c
> drivers/net/atlx/atl1.c
> drivers/net/qla3xxx.c
> drivers/net/tg3.c
> drivers/net/niu.c
> 
> So what is the plan? If I send a patch to add IRQF_SAMPLE_RANDOM to others 
> (like the Blackfin) networking drivers - will it get rejected?
> 
> We have lots of embedded headless systems (no keyboard/mouse, no soundcard, no 
> video) systems with *no* sources of entropy - and people using SSL.

I'd rather add a random_sample_network call somewhere reasonably central
in the network stack. Then we can use the knowledge that the sample is
network-connected in the random core to decide how to measure its
entropy. The trouble with IRQF_SAMPLE_RANDOM is that many of its users
are technically bogus as entropy sources in the current model.

I'm eventually going to move the RNG away from the strict theoretical
entropy accounting model to a more pragmatic one which will be much
happier with iffy entropy sources, but that's a ways off.

-- 
http://selenic.com : development and support for Mercurial and Linux


