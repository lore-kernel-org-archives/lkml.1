Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbYGIN2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbYGIN2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYGIN2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:28:41 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:4338
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbYGIN2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:28:41 -0400
X-Trace: 108994929/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAAAPtZdEjDiV6i/2dsb2JhbAAIsDA
X-IronPort-AV: E=Sophos;i="4.30,331,1212361200"; 
   d="scan'208";a="108994929"
X-IP-Direction: IN
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper
	platform_device
From: ian <spyro@f2s.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20080709120720.GL8517@trinity.fluff.org>
References: <20080709104916.200210922@fluff.org>
	 <20080709104933.101610936@fluff.org>
	 <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com>
	 <20080709112426.GN8489@trinity.fluff.org>
	 <bc64b4640807090431g5b1960edua2508337973615da@mail.gmail.com>
	 <20080709115045.GK8517@trinity.fluff.org>
	 <bc64b4640807090456u15d12378qe25375ce4a6cd100@mail.gmail.com>
	 <20080709120720.GL8517@trinity.fluff.org>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 14:28:38 +0100
Message-Id: <1215610118.3295.92.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 13:07 +0100, Ben Dooks wrote:
> > They should be here for exactly the same reason. They are used by
> the drivers
> > that will be submitted later. E.g. OHCI driver needs such
> > suspend/resume handling.
> 
> No, you don't understand. I'll make a rather explicit point about the
> very clever way the device tree works since the devices are registered
> with their parent device set.

Actually I misthought here too.

The problem comes when the subdevices arent *quite* truely independant
of their core, and thus need to ask the core to turn off power /
clokcs / etc. for them

they cant just do it themselves because the subdevices may be used on
more than one core that does this hanling in different ways (eg. T7L and
TC6393XB handle the 32KHz clock completely differently. on tc6393xb,
theres a clock gate on the MFD core chip and on t7l66xb the clock has to
be handled right back at the platform layer, in board specific code
because the core has no gate, and the clock is fed to it from an
external pin.

Thats one example - there are others, not all clocks.

