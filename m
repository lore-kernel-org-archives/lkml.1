Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYJXFmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYJXFmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYJXFmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:42:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:25920 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897AbYJXFmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:42:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,475,1220252400"; 
   d="scan'208";a="64724769"
Date: Fri, 24 Oct 2008 13:42:14 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_PCIEASPM needed for ASPM?
Message-ID: <20081024054213.GA8194@sli10-desk.sh.intel.com>
References: <43e72e890810231840t2b5dd812p50d2325a967e6d4@mail.gmail.com> <20081024024747.GA3900@sli10-desk.sh.intel.com> <43e72e890810231958n2ef4f709k86e3d3adf81f5f73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890810231958n2ef4f709k86e3d3adf81f5f73@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 10:58:06AM +0800, Luis R. Rodriguez wrote:
> On Thu, Oct 23, 2008 at 7:47 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> > On Fri, Oct 24, 2008 at 09:40:27AM +0800, Luis R. Rodriguez wrote:
> >> I know, the question is silly right? I thought so too, but I started
> >> reviewing the code and noticed most of it is just setting up values in
> >> data structures for the kernel's awareness of capabilities, it also
> >> updates the state in case of BIOS foobar, and there is also clock
> >> retraining if possible to reduce latency. Is that it? Did I miss
> >> something or is it really possible for devices to be able to use
> >> L0s|L1 or L1 by just having a BIOS which does things correctly?
> >>
> >> That is can our devices be using ASPM without any OS interaction,
> >> without CONFIG_PCIEASPM enabled?
> > you didn't miss anything. If BIOS enables ASPM, even OS doesn't do anything,
> > ASPM will be used.
> 
> I see, interesting... how about the clock selection and training? The
> ASPM code has it, but without it will it have taken place in hardware
> behind the scenes?
this is just required when we setup ASPM, and not be done frequently. I
suggest you look at the spec of pcie.
 
> > ASPM enter/leave is controlled by hardware, OS just
> > enables the capability.
> 
> What do you mean by the OS enabling the capability? All I see is
> setting the capability bits on the pci struct so the OS can reflect
> this internally and to userspace, say through lspci. Is that it?
The driver does set some pci config space registers not just set capability
bits on the pci struct.

Thanks,
Shaohua
