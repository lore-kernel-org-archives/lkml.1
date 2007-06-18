Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbXFRCie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbXFRCie (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 22:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXFRCiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 22:38:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:18384 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbXFRCiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 22:38:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,432,1175497200"; 
   d="scan'208";a="258007110"
Date: Mon, 18 Jun 2007 10:37:26 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Carlo Wood <carlo@alinoe.com>, Dave Airlie <airlied@gmail.com>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070618023726.GA7594@zhen-devel.sh.intel.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Airlie <airlied@gmail.com>, Dave Jones <davej@redhat.com>,
	linux-kernel@vger.kernel.org, eric@anholt.net
References: <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com> <20070617224918.GC12483@redhat.com> <20070618000643.GA1375@alinoe.com> <20070618001627.GA18598@redhat.com> <21d7e9970706171757n4709383cv7a39a66103edc370@mail.gmail.com> <20070618015636.GA8561@alinoe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618015636.GA8561@alinoe.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.18 03:56:36 +0000, Carlo Wood wrote:
> On Mon, Jun 18, 2007 at 10:57:38AM +1000, Dave Airlie wrote:
> > >Right now, I'm at a loss to explain the corruption, so it's
> > >difficult to suggest what to try.
> > 
> > The thing is here, this is PCIE, so if there is a GPU plugged into the
> > PCIE 16x slot in theory the main onboard graphics should disable, AGP
> > code is used to control the GART for the onboard chip, in this case a
> > plugged in card will  not use AGP, I wonder have Intel tested with a
> > pcie card in place...

Agree. We seem to always enable AGP even IGD is disabled or not exists,
other card should not depend on this module ever.

> 
> That is Chinese for me :/.
> Do you want me to try something?

Carlo, I've just built latest kernel git tree on a Dell 965G box and
have a NV card plugged-in. It boots fine.

Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 965G Chipset.
agpgart: AGP aperture is 256M @ 0x0

I don't know why it hangs your machine when loading this module, it should
just not bother anything. But from your last "modprobe: ..." line, it seems
there's really badness somewhere, do you have serial console to see more
in the message?
