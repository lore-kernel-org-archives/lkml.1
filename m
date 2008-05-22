Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbYEVBLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbYEVBLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbYEVBK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:10:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:33269 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYEVBK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:10:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,523,1204531200"; 
   d="scan'208";a="567302181"
Subject: Re: [BISECTED] pata_jmicron: no drives found on post 2.6.25 kernels
From: Shaohua Li <shaohua.li@intel.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <68676e00805211245u1a1973e5g847bd7e8a6c9e5a7@mail.gmail.com>
References: <courier.4832011A.000041C2@fs.ru.acad.bg>
	 <1211248108.19834.2.camel@sli10-desk.sh.intel.com>
	 <courier.4832F7AF.00000DCD@fs.ru.acad.bg>
	 <1211360320.22210.5.camel@sli10-desk.sh.intel.com>
	 <68676e00805211245u1a1973e5g847bd7e8a6c9e5a7@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 22 May 2008 09:15:24 +0800
Message-Id: <1211418924.15223.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 21:45 +0200, Luca Tettamanti wrote:
> On Wed, May 21, 2008 at 10:58 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> > On Tue, 2008-05-20 at 19:09 +0300, Plamen Petrov wrote:
> >> Shaohua Li написа:
> >>
> >> > On Tue, 2008-05-20 at 01:37 +0300, Plamen Petrov wrote:
> >> >> Hello, folks!
> >> >>
> >> >> After 2.6.26 merge window opened, the optical drives in my
> >> >> computer, hanging off a JMicron controler were not detected
> >> >> by linux any more.
> >> >>
> >> >> Luca Tettamanti reported similar troubles:
> >> >> http://marc.info/?l=linux-kernel&m=120958791323911&w=2
> >> >>
> >> >> Its been 20 days, so I decided to bisect.
> >> >> git bisect revealed that commit
> >> >> 7d715a6c1ae5785d00fb9a876b5abdfc43abc44b
> >> >> is the one causing pata_jmicron to fail to detect drives,
> >> >> connected to the JMicron controler on my motherboard.
> >> >> At least in my case, anyway...
> >> >> Changing kernel config to CONFIG_PCIEASPM=n makes the drives
> >> >> attached to the JMicron SATA/PATA controller usable again.
> >> > When you enable this option, did you change any ASPM policy? By default,
> >> > we are using the BIOS setting, so it shouldn't change any thing.
> >> >
> >>
> >> No, I did not change any ASPM policy, mainly because I do not how.
> >>
> >> > Also can you please send me the 'lspci -vvvxxxx' output with/without the
> >> > ASPM enabled?
> >> >
> > Can you please try below patch?
> 
> I confirm that the patch fixes the issue when CONFIG_ASPM is enabled.
> 
> > The Slot 03:00.* of JMicron controller has two functions, but one is
> > PCIE endpoint the other isn't PCIE device, very strange.
> 
> Right, that's what I'm seeing here (motherboard is an ASUS P5B-E). I'm
> attaching the output of lspci.
Jesse, can you take this patch. It should be safe for 2.6.26.

Thanks,
Shaohua

