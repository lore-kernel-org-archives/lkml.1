Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYGGTsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYGGTsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbYGGTs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:48:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46125 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbYGGTs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:48:28 -0400
Message-ID: <487272F6.1040507@garzik.org>
Date: Mon, 07 Jul 2008 15:48:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       David Miller <davem@davemloft.net>, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
References: <1215093175.10393.567.camel@pmac.infradead.org>	<20080703173040.GB30506@mit.edu>	<1215111362.10393.651.camel@pmac.infradead.org>	<20080703.162120.206258339.davem@davemloft.net>	<486D6DDB.4010205@infradead.org>	<87ej6armez.fsf@basil.nowhere.org>	<1215177044.10393.743.camel@pmac.infradead.org>	<486E2260.5050503@garzik.org>	<1215178035.10393.763.camel@pmac.infradead.org>	<486E2818.1060003@garzik.org>	<1215179161.10393.773.camel@pmac.infradead.org>	<486E2E9B.20200@garzik.org>	<20080704153822.4db2f325@lxorguk.ukuu.org.uk>	<48715807.8070605@garzik.org>	<20080707165333.6347f564@the-village.bc.nu>	<48725155.2040007@garzik.org>	<20080707191359.11f6297f@the-village.bc.nu>	<48726734.7080601@garzik.org>	<20080707193008.17795d61@the-village.bc.nu>	<48726B7F.5010402@garzik.org> <20080707194558.4be87882@the-village.bc.nu>
In-Reply-To: <20080707194558.4be87882@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> And this is the pot calling the kettle black. You badly
>>> broke Marvell PATA support by setting the Marvell SATA devices to AHCI. I
>>> note you've still not fixed that after some months.
>> Even if we accept that at face value, which I don't (it's more a driver 
>> load order issue), that is no excuse for further regressions.
> 
> So you are allowed to break stuff without fixing it (and driver load
> order issue is not as far as I can tell the case - the AHCI stuff means
> you lose the PATA port)

It is trivial to see -- both drivers compete for the same PCI IDs, 
0x6145 and 0x6121, but with different capabilities.  Load pata_marvell 
first, and it claims those PCI IDs first.


> How about we revert all the marvell changes - or would in truth be
> another case where the good done for most (SATA AHCI support) outweighs
> the bad for a few (PATA port problems) ?

What load order would you suggest?  pata_marvell-first order preserves 
the behavior that existed before the PCI IDs appeared in ahci, by 
ensuring it claims PCI IDs 0x6145 and 0x6121 first.


> Sorry Jeff but you don't get to jump up and down on David without being
> reminded that your own actions are not consistent with your words.

Your sidebar here doesn't change the fact that David's current firmware 
implementation takes away a tool currently in use, replacing it with 
another less-reliable tool.

	Jeff


