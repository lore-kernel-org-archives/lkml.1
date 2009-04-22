Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbZDVGG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbZDVGG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 02:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbZDVGGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 02:06:17 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:48987 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752995AbZDVGGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 02:06:16 -0400
Message-ID: <796440.13871.qm@web32603.mail.mud.yahoo.com>
X-YMail-OSG: WYCKMQIVM1n1YvFTF8GJD9taGNuhjGlphahijvSZumXlFbaqnlu1UiOhpYyjGErmDWK2EOzPkaQsxg.70e3j88KKxdoyeu_Utmp7znzkxSwUyrQWeC3MPbvnF6ly48wAuR6HVhz9CUK42r4AwvMFBzLVECI8RnTYpQblkg.taCBmGzHrja9acUeW.tnwiDWUauDPUnz5AyAmWpoYrV2XiMshXxExcsxuvUYAQz8Z08DyuHu9y6O3kMs4.LMb5SYE6mXlleFkZb.vuZs9Lu6wMmeYiZKd_koPlNX1EfxSEt6RZHuHcq8-
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
Date: Tue, 21 Apr 2009 23:06:15 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Booting 2.6.30-rc2-git7 very slow
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Rafael J. Wysocki <rjw@sisk.pl>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: linux-kernel@vger.kernel.org
> Sent: Tuesday, April 21, 2009 9:12:20 PM
> Subject: Re: Booting 2.6.30-rc2-git7 very slow
> 
> On Tuesday 21 April 2009, Martin Knoblauch wrote:
> > 
> > Hi, [please CC me on replies, as I am not subscribed]
> > 
> >  booting  2.6.30-rc2-git7 on a HP/DL380G3 (x86_64, RHEL4.3, 64 bit userspace) 
> is much slower that it used to be. It seems I run into timeouts when [trying to] 
> load intel and tg3 microcodes:
> > 
> > [   14.478892] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > [   74.476741] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > [  134.476638] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > [  194.476637] platform microcode: firmware: requesting intel-ucode/0f-04-0a
> > [  254.476493] Microcode Update Driver: v2.00 , 
> Peter Oruba
> > [  254.718489] Microcode Update Driver: v2.00 removed.
> > 
> >  So, we see 60 seconds for eaoch of the CPUs
> > 
> > [  255.273426] tg3 0000:03:01.0: PME# disabled
> > [  257.833769] tg3: eth0: Link is up at 1000 Mbps, full duplex.
> > [  257.833775] tg3: eth0: Flow control is off for TX and off for RX.
> > [  269.643973] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
> > [  329.640456] eth1: Failed to load firmware "tigon/tg3_tso.bin"
> > [  329.640463] eth1: TSO capability disabled.
> > [  329.640487] tg3 0000:03:01.1: PME# disabled
> > [  333.081753] tg3: eth1: Link is up at 1000 Mbps, full duplex.
> > [  333.081759] tg3: eth1: Flow control is off for TX and off for RX.
> > 
> >  We see 60 seconds for eth1, complaining about a failed firmware load.
> > /lib/firmware/tigon/tg3_tso.bin does exist and is from the current
> > build.
> 
> Do I assume correctly that 2.6.29 did not have this problem?
> 

I can tell that 2.6.28.2 did not have that problem. I skipped 2.6.29, so I cannot be sure. This is from the 2.6.28.2 boot sequence:

[   14.148605] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[   14.194728] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[   14.226354] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[   14.258677] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[   14.291483] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   14.530193] Microcode Update Driver: v2.00 removed.
[   17.629690] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[   17.629695] tg3: eth0: Flow control is off for TX and off for RX.
[   33.328198] tg3: eth1: Link is up at 1000 Mbps, full duplex.
[   33.328203] tg3: eth1: Flow control is off for TX and off for RX.
[   44.737601] RPC: Registered udp transport module.
[   44.737606] RPC: Registered tcp transport module.
[   47.637782] warning: process `snmpd' used the deprecated sysctl system call with 7.2.1.
[   57.671627] warning: `ntpd' uses 32-bit capabilities (legacy support in use)


Cheers
Martin
