Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYGINhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYGINhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 09:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYGINhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 09:37:31 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:9908
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbYGINhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 09:37:31 -0400
X-Trace: 109001008/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAAABdcdEjDiV6i/2dsb2JhbAAIsDE
X-IronPort-AV: E=Sophos;i="4.30,331,1212361200"; 
   d="scan'208";a="109001008"
X-IP-Direction: IN
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper
	platform_device
From: ian <spyro@f2s.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Dmitry <dbaryshkov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <74d0deb30807090634h6feb1f2eu53f8b13d810b8b3d@mail.gmail.com>
References: <20080709104916.200210922@fluff.org>
	 <20080709104933.101610936@fluff.org>
	 <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com>
	 <20080709112426.GN8489@trinity.fluff.org>
	 <bc64b4640807090431g5b1960edua2508337973615da@mail.gmail.com>
	 <20080709115045.GK8517@trinity.fluff.org>
	 <bc64b4640807090456u15d12378qe25375ce4a6cd100@mail.gmail.com>
	 <20080709120720.GL8517@trinity.fluff.org>
	 <1215610118.3295.92.camel@wirenth>
	 <74d0deb30807090634h6feb1f2eu53f8b13d810b8b3d@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 14:37:28 +0100
Message-Id: <1215610648.3295.99.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 15:34 +0200, pHilipp Zabel wrote:
> On Wed, Jul 9, 2008 at 3:28 PM, ian <spyro@f2s.com> wrote:
> > On Wed, 2008-07-09 at 13:07 +0100, Ben Dooks wrote:

> I agree "power" and "etc." are issues. Clocks should be handled by the
> clock API just fine.

When its merged.

> > they cant just do it themselves because the subdevices may be used on
> > more than one core that does this hanling in different ways (eg. T7L and
> > TC6393XB handle the 32KHz clock completely differently.
> 
> That shouln't matter with generic clocks. If they
> clk_get(&mfd_cell->pdev.dev, "my_clk_input"), that should be
> dispatched to the correct MFD clock regardless of the actual chip.

I agree but its not merged yet.

Until it is, we should stick with the enable / disable methods.

Also, suspend / resume for TC* need careful sequencing of the GPIOs
attached to #PCLR and #SUSPEND (get it wrong and you reset the chip
instead of sleep it)

:-)

