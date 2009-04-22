Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbZDVLcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbZDVLcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 07:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZDVLc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 07:32:27 -0400
Received: from web32605.mail.mud.yahoo.com ([68.142.207.232]:45602 "HELO
	web32605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751409AbZDVLc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 07:32:26 -0400
Message-ID: <808633.38942.qm@web32605.mail.mud.yahoo.com>
X-YMail-OSG: Z3IiOEAVM1nN546eYEr43gy1eAWxczdc2h3yTaHEvnhJXOq8frYKFQKy7biZEkBzORedDMa1wRzmMS1Nz_5pCyz5WlHzYp36thlOPqtvfxp.Fd1gsUmwEef.vFHiiXtq1FCfyv3EX5GsHilp6gIXnjqEwMcPXUqRvg7tno2rfDDgyhL8HrwhjwOH033cX8zTljKTuyEjIMQRDgPbIWMoq6pEDQ0LY1zZmWYnGVPXDODiLly8rXBaQBz63O38NYe29bAlbAiOSdrZwtsg2ocxK_edpoTyjGcQDFxc4kmWUlpGqHk-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
Date: Wed, 22 Apr 2009 04:32:25 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Booting 2.6.30-rc2-git7 very slow
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, efault@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Martin Knoblauch <spamtrap@knobisoft.de>
> To: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: linux-kernel@vger.kernel.org
> Sent: Wednesday, April 22, 2009 11:56:27 AM
> Subject: Re: Booting 2.6.30-rc2-git7 very slow
> 
> > From: Rafael J. Wysocki 
> 
> > To: Martin Knoblauch 
> > Cc: linux-kernel@vger.kernel.org
> > Sent: Tuesday, April 21, 2009 9:12:20 PM
> > Subject: Re: Booting 2.6.30-rc2-git7 very slow
> > 
> > On Tuesday 21 April 2009, Martin Knoblauch wrote:
> > > 
> > > Hi, [please CC me on replies, as I am not subscribed]
> > > 
> > >  booting  2.6.30-rc2-git7 on a HP/DL380G3 (x86_64, RHEL4.3, 64 bit 
> userspace) 
> > is much slower that it used to be. It seems I run into timeouts when [trying 
> to] 
> > load intel and tg3 microcodes:
> > > 
> > > [   14.478892] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > > [   74.476741] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > > [  134.476638] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > > [  194.476637] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > > [  254.476493] Microcode Update Driver: v2.00 , 
> > Peter Oruba
> > > [  254.718489] Microcode Update Driver: v2.00 removed.
> > > 
> > >  So, we see 60 seconds for eaoch of the CPUs
> > > 
> > > [  255.273426] tg3 0000:03:01.0: PME# disabled
> > > [  257.833769] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> > > [  257.833775] tg3: eth0: Flow control is off for TX and off for RX.
> > > [  269.643973] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
> > > [  329.640456] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> > > [  329.640463] eth1: TSO capability disabled.
> > > [  329.640487] tg3 0000:03:01.1: PME# disabled
> > > [  333.081753] tg3: eth1: Link is up at 1000 Mbps, full duplex.
> > > [  333.081759] tg3: eth1: Flow control is off for TX and off for RX.
> > > 
> > >  We see 60 seconds for eth1, complaining about a failed firmware load.
> > > /lib/firmware/tigon/tg3_tso.bin does exist and is from the current
> > > build.
> > 
> > Do I assume correctly that 2.6.29 did not have this problem?
> > 
> 
> Just checked. 2.6.29 has exactely the same problem. 2.6.28.2 was OK. This is 
> from the 2.6.29 boot:
> 
> [   14.308340] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> [   74.304612] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> [  134.304651] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> [  194.304638] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> [  254.304597] Microcode Update Driver: v2.00 ,  Peter Oruba
> [  254.546200] Microcode Update Driver: v2.00 removed.

 In case of the platform microcode, the delays happen when doing:

/sbin/modprobe microcode

from the init script. I have a "microcode.dat" File in both /etc/ and /etc/firmware.

> [  255.088405] tg3 0000:03:01.0: PME# disabled
> [  257.669617] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> [  257.669622] tg3: eth0: Flow control is off for TX and off for RX.
> [  269.456132] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
> [  329.456495] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> [  329.456500] eth1: TSO capability disabled.
> [  329.456524] tg3 0000:03:01.1: PME# disabled
> [  332.921832] tg3: eth1: Link is up at 1000 Mbps, full duplex.
> [  332.921837] tg3: eth1: Flow control is off for TX and off for RX.
> 
> 

Thanks
Martin

