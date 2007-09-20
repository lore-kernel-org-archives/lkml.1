Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbXITJ0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbXITJ0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXITJ0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:26:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:53874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbXITJ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:26:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,277,1186383600"; 
   d="scan'208";a="314934427"
Date: Thu, 20 Sep 2007 17:24:41 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
Message-ID: <20070920092441.GA1972@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <46F17CA1.5080205@gmail.com> <20070919195425.GF18707@one.firstfloor.org> <46F17F27.5080000@gmail.com> <21d7e9970709191851s1b3f35c1j42faae3ce6cd0b24@mail.gmail.com> <46F22048.8050401@gmail.com> <21d7e9970709200033k3f0f46feq7dae4e0a106f0372@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970709200033k3f0f46feq7dae4e0a106f0372@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.22-rc6 i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.09.20 17:33:45 +0000, Dave Airlie wrote:
> > Maybe you are rather interested in these dmesg lines:
> > Linux agpgart interface v0.102
> > agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
> > on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
> > agpgart: Detected an Intel G33 Chipset.
> > agpgart: Detected 8192K stolen memory.
> > agpgart: AGP aperture is 256M @ 0xd0000000
> > [drm] Initialized drm 1.1.0 20060810
> > ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
> > [drm] Initialized i915 1.6.0 20060119 on minor 0
> > ...
> > set status page addr 0x00033000
> > agpgart: pg_start == 0x000005ff,intel_private.gtt_entries == 0x00000800
> > agpgart: Trying to insert into local/stolen memory
> >
> > So the problem is, that X passes too low start.
> >
> > The X log:
> > http://www.fi.muni.cz/~xslaby/sklad/Xorg.0.log.old

Could you try current xf86-video-intel driver? just do
git clone git://anongit.freedesktop.org/git/xorg/driver/xf86-video-intel

My G33 was just verified broken today... so I'll try to reproduce it on
another one tomorrow.

> 
> I've cc'd Zhenyu who might be able to shed some light on this? can you
> try 2.6.23-rc7 as maybe the G33 support still needs some work.. or
> maybe I'm missing a patch in the drm..
> 

yep, should try 2.6.23-rc7 first, and it seems not drm relate.
