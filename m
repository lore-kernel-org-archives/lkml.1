Return-Path: <linux-kernel-owner+w=401wt.eu-S1761939AbZDGV62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761939AbZDGV62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbZDGV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:57:41 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:36436 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbZDGV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:57:39 -0400
X-IronPort-AV: E=Sophos;i="4.39,339,1235970000"; 
   d="scan'208";a="85949342"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: IRQF_SAMPLE_RANDOM question...
Date: Tue, 7 Apr 2009 17:58:50 -0400
User-Agent: KMail/1.9.5
CC: "Sven-Haegar Koch" <haegar@sdinet.de>, "Matt Mackall" <mpm@selenic.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Chris Peterson" <cpeterso@cpeterso.com>
References: <200904061430.26276.rgetz@blackfin.uclinux.org> <alpine.DEB.2.00.0904070003470.6968@aurora.sdinet.de> <49DA91C2.1020106@garzik.org>
In-Reply-To: <49DA91C2.1020106@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200904071758.50823.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 07 Apr 2009 21:56:30.0990 (UTC) FILETIME=[B59BCAE0:01C9B7CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 6 Apr 2009 19:35, Jeff Garzik pondered:
> Sven-Haegar Koch wrote:
> > On Mon, 6 Apr 2009, Matt Mackall wrote:
> > 
> >> On Mon, 2009-04-06 at 14:30 -0400, Robin Getz wrote:
> >>> We have lots of embedded headless systems (no keyboard/mouse, no
> >>> soundcard, no video) systems with *no* sources of entropy - and people
> >>> using SSL. 
> >> I'd rather add a random_sample_network call somewhere reasonably central
> >> in the network stack. Then we can use the knowledge that the sample is
> >> network-connected in the random core to decide how to measure its
> >> entropy. The trouble with IRQF_SAMPLE_RANDOM is that many of its users
> >> are technically bogus as entropy sources in the current model.
> >>
> >> I'm eventually going to move the RNG away from the strict theoretical
> >> entropy accounting model to a more pragmatic one which will be much
> >> happier with iffy entropy sources, but that's a ways off.
> > 
> > Btw, perhaps not the perfect question in this thread:
> > But what should we use to keep servers running without a hardware rng 
> > available and without any external input besides the network?
> > After having ssh and openvpn die because of no random and having 
> > the machines like dead and unreachable for me I use "ln -sf 
> > /dev/urandom /dev/random", but that does not feel so good.
> 
> We see this question every time IRQF_SAMPLE_RANDOM is discussed.
> 
> There is plenty of entropy data available, you just have to look 
> around...  Google around for "EGD", video entropy daemon, audio entropy 
> daemon, etc...
> 
> Even headless servers have entropy sources if you look hard enough.

The original question wasn't headless servers - it was headless, no audio, no 
video, boot from flash, (initrd root file systems), diskless. embedded 
devices.

And few want to load up perl on an embedded device just to gather entropy. :(

-Robin
