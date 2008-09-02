Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYIBHOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYIBHOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 03:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYIBHOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 03:14:41 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:32780 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYIBHOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 03:14:40 -0400
X-BigFish: VPS-42(zz1432R98dR936eQ1805M936fQ3117Kzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K6K448-01-BII-01
Date: Tue, 2 Sep 2008 09:14:28 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] x86: fix memory leaks when doing CPU hotplug
Message-ID: <20080902071428.GA6743@alberich.amd.com>
References: <20080806082400.GC5427@alberich.amd.com> <20080811194013.GI12788@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080811194013.GI12788@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 02 Sep 2008 07:14:32.0256 (UTC) FILETIME=[8BF20C00:01C90CCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 09:40:15PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Following patches fix two memory leaks with CPU hotplug. Some per CPU 
> > data is allocated each time a CPU is set online. But this space is 
> > never freed.
> > 
> > Usually this memory leak is not a big deal (for normal CPU hotplug 
> > usage). But during stress tests with lots of CPU offline/online cycles 
> > this really matters.
> > 
> > The entire leak is 40K (10 pages) for each offline/online cycle per 
> > CPU.  I've verified both fixes performing more than 90000 CPU 
> > offline/online cycles.
> 
> applied to tip/x86/core, thanks Andreas.
> 
> > This is not a regression but I think it's still 2.6.27 material. 
> > Please apply.
> 
> it's tricky code so i guess it's best to let it cook in tip/master a 
> bit. If it does not show up upstream by say -rc4 time could you please 
> ping us about it?

Ping!

It's -rc5 time and

b55793f7528ce1b73c25b3ac8a86a6cda2a0f9a4 (x86: cpu_init(): fix memory leak when using CPU hotplug)
49800efcb17afdf973f33e8aa8807b7f83993cc6 (x86: pda_init(): fix memory leak when using CPU hotplug)

are in tip/master but not yet upstream.


Regards,

Andreas


