Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbXITWKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbXITWKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXITWKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:10:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:40312 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbXITWKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PrZS66+iRpsUwGqcfTMDIAq9IFO7eFdoACBd6hgV3vBJjdj3HI9O5r8ccO2WRNKWk3lcciKeJGTlaBEfB1sFXiWXrR+y1EFY3ZyP7k4u6xf/R2ieCgfb/fHI/Ymbob79sYc9PQy+cjE/vwndipHGfidPktA98SUUXorzRhdPT8o=
Message-ID: <46F2EFD2.2090907@gmail.com>
Date: Fri, 21 Sep 2007 00:10:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <46F17CA1.5080205@gmail.com> <20070919195425.GF18707@one.firstfloor.org> <46F17F27.5080000@gmail.com> <21d7e9970709191851s1b3f35c1j42faae3ce6cd0b24@mail.gmail.com> <46F22048.8050401@gmail.com> <21d7e9970709200033k3f0f46feq7dae4e0a106f0372@mail.gmail.com> <20070920092441.GA1972@zhen-devel.sh.intel.com>
In-Reply-To: <20070920092441.GA1972@zhen-devel.sh.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2007 11:24 AM, Zhenyu Wang wrote:
> On 2007.09.20 17:33:45 +0000, Dave Airlie wrote:
>>> Maybe you are rather interested in these dmesg lines:
>>> Linux agpgart interface v0.102
>>> agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
>>> on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
>>> agpgart: Detected an Intel G33 Chipset.
>>> agpgart: Detected 8192K stolen memory.
>>> agpgart: AGP aperture is 256M @ 0xd0000000
>>> [drm] Initialized drm 1.1.0 20060810
>>> ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
>>> [drm] Initialized i915 1.6.0 20060119 on minor 0
>>> ...
>>> set status page addr 0x00033000
>>> agpgart: pg_start == 0x000005ff,intel_private.gtt_entries == 0x00000800
>>> agpgart: Trying to insert into local/stolen memory
>>>
>>> So the problem is, that X passes too low start.
>>>
>>> The X log:
>>> http://www.fi.muni.cz/~xslaby/sklad/Xorg.0.log.old
> 
> Could you try current xf86-video-intel driver? just do
> git clone git://anongit.freedesktop.org/git/xorg/driver/xf86-video-intel

It works! 3d problem, but it has maybe nothing to do with kernel:
$ glxinfo
name of display: :0.0
Unrecognized deviceID 29c2
X Error of failed request:  GLXBadContext
...

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
