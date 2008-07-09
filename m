Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbYGIMPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbYGIMPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYGIMPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:15:42 -0400
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:33566
	"EHLO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbYGIMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:15:42 -0400
X-Trace: 142697252/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/195.137.94.162
X-SBRS: None
X-RemoteIP: 195.137.94.162
X-IP-MAIL-FROM: spyro@f2s.com
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhEBAEBvV0jDiV6i/2dsb2JhbAAIrnw
X-IronPort-AV: E=Sophos;i="4.30,331,1212361200"; 
   d="scan'208";a="142697252"
X-IP-Direction: IN
Subject: Re: [patch 4/4] MFD: Change mfd platform device usage to wrapper
	platform_device
From: ian <spyro@f2s.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20080709115045.GK8517@trinity.fluff.org>
References: <20080709104916.200210922@fluff.org>
	 <20080709104933.101610936@fluff.org>
	 <bc64b4640807090415w781507fetfe332271ad158112@mail.gmail.com>
	 <20080709112426.GN8489@trinity.fluff.org>
	 <bc64b4640807090431g5b1960edua2508337973615da@mail.gmail.com>
	 <20080709115045.GK8517@trinity.fluff.org>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 13:13:59 +0100
Message-Id: <1215605639.3295.79.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-09 at 12:50 +0100, Ben Dooks wrote:
> 
> So, the enable/disable calls might be useful, however is there any
> reason this could not be handled by the clock framework? The
> suspend/resume entries where not used, and I belive should not be in
> here.

Hi Ben,

I agree with you on wrapping the platform device, however the enable /
disable methods must stay.

Other cores need them, and they arent only there for clock support.

I've just looked at the TMIO MMC driver to refersh my memory and the
suspend / resume hooks must stay also. TMIO MMC needs to be handled
differently when suspending and when being disabled (loss of state when
disabled).

As yet, only tc6393 is 'in tree' but Im waiting for the core to settle
down before I convert my other TMIO based code (again again) to the new
core.

So, in summary -

ACK to your changes to wrap the device as an 'mfd_device'
NAK to deleting the mfd_cell power management.

