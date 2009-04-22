Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbZDVJ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbZDVJ4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZDVJ43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:56:29 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:22215 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750842AbZDVJ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:56:28 -0400
Message-ID: <106159.21345.qm@web32608.mail.mud.yahoo.com>
X-YMail-OSG: hqIOMusVM1laUh9ejg3xOeukzDvVYiOZL3cmecXU4qH4ukvX8owvw3jEycMdr42CqFWmFUyz1HHJaG27PTcPyLNVKkTvNegcToKSRqFxn4w9FHWU8gCoZhNrJwCPWiTZ7xqRrcL8.xEadlvjR626igyIgq.SYiJRy34aeBOlscffOB_pglVqOe_u76o2pijUk7ve9Z_pX.4bu9elje4VBrWycfgxnaWsMr6ckwzmbdInFaHz6Iyw5BeY9a8F5ymGEKs5eWPpErownJGnjnA335MvgPD8gMa9xWuZlFq8SEeOul5jYUzz
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <547506.26789.qm@web32603.mail.mud.yahoo.com> <200904212112.20278.rjw@sisk.pl>
Date: Wed, 22 Apr 2009 02:56:27 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: Booting 2.6.30-rc2-git7 very slow
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200904212112.20278.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

 Just checked. 2.6.29 has exactely the same problem. 2.6.28.2 was OK. This is from the 2.6.29 boot:

[   14.308340] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[   74.304612] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[  134.304651] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[  194.304638] platform microcode: firmware: requesting intel-ucode/0f-04-0a
[  254.304597] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[  254.546200] Microcode Update Driver: v2.00 removed.
[  255.088405] tg3 0000:03:01.0: PME# disabled
[  257.669617] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[  257.669622] tg3: eth0: Flow control is off for TX and off for RX.
[  269.456132] tg3 0000:03:01.1: firmware: requesting tigon/tg3_tso.bin
[  329.456495] eth1: Failed to load firmware "tigon/tg3_tso.bin"
[  329.456500] eth1: TSO capability disabled.
[  329.456524] tg3 0000:03:01.1: PME# disabled
[  332.921832] tg3: eth1: Link is up at 1000 Mbps, full duplex.
[  332.921837] tg3: eth1: Flow control is off for TX and off for RX.


Cheers
Martin
