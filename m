Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYKVTJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYKVTJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 14:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKVTI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 14:08:57 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:39449 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751030AbYKVTI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 14:08:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BOXGC9DO9NIPWk5IS1OjHYinMZvF66Wm+QcxLJyzyTdvrXjfCqUqnsUTe37pJtoNkqtoX3sfT+dfE9lr7fEdfzCZv9M4YTc+8+9Ajrm1sxo05D4LJcjeN/9QfT0+A/bPTjQIXoEd5Ov2wpC0Hd5FdoQ19NMh3AoEIcomTfkySvU=  ;
X-YMail-OSG: hKunkFMVM1kxrDS_Zrp7Hel0y4oLrlLPTlaGwsxRDOfMBPWqoMCmm8fgvbOjNGkMHwJKz6PXTCUaz0Dytvm8wVNv1jrhkbAtptSIeBRK0cY7UwtFgmFF4xN2Mgyz_pedcleEcWAm4zYoNmXtorfLyyO2a6PBF3ElrAuTmt3oSH3ZBuwBLUFXXhMOyAOJQIKaPqU6TCd7LELfCSTBSI7g
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Daniel Ribeiro <drwyrm@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
       stefan@datenfreihafen.org
Subject: Re: [spi-devel-general] [patch 05/14] mfd: PCAP2 driver
Date: Sat, 22 Nov 2008 11:08:53 -0800
User-Agent: KMail/1.9.10
Cc: spi-devel-general@lists.sourceforge.net, sameo@openedhand.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <f17812d70811220601p1d7af668mf3265224179753ab@mail.gmail.com> <1227369262.19591.41.camel@brutus>
In-Reply-To: <1227369262.19591.41.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200811221108.54331.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008, Daniel Ribeiro wrote:
> Em Sáb, 2008-11-22 às 22:01 +0800, Eric Miao escreveu:
> > On Sat, Nov 22, 2008 at 1:25 PM, David Brownell <david-b@pacbell.net> wrote:
> > > On Friday 21 November 2008, stefan@datenfreihafen.org wrote:
> > >> Since the last submission we are also using the spi subsystem and
> > >> pxa2xx-spi instead of ssp.c directly as before.
> > >
> > > I took a quick glance at this and it seemed like it should be
> > > able to build without depending on PXA ... should certainly
> > > not include <mach/ssp.h> or <mach/regs-ssp.h>, and it doesn't
> > > look like it needs PXA-specific stuff like <mach/mfp-pxa27x.h>
> > > either.
> > >
> > > It's also worth removing the reverse dependencies ("select X")
> > > from Kconfig; they don't work very well for the things which
> > > those dependencies rely on.
> > >
> > I'm wondering if it call fall into the regulator framework, along with
> > a hwmon driver with its attributes being exported by sysfs.

Make it work like other MFD drivers, with child devices
to encapsulate such functionality ... and drivers specific
to those functionalities.

Such as a regulator framework driver, an RTC, and so on.


> The ADC is also used by the touchscreen driver, and later will be used
> for accessory detection (usb otg, charger, EMU (audio and uart on usb
> port)).

ADC integration may be an interesting little puzzle.

 
> Currently the only user for the voltage regulators is the MMC, i plan to
> use the regulator subsystem when more users arise.
> 


