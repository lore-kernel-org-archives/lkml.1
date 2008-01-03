Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbYACERe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbYACERe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 23:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYACER0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 23:17:26 -0500
Received: from rtr.ca ([76.10.145.34]:1189 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbYACERZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 23:17:25 -0500
Message-ID: <477C61D3.30009@rtr.ca>
Date: Wed, 02 Jan 2008 23:17:23 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
Cc: Allen Martin <AMartin@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>, Peer Chen <pchen@nvidia.com>
Subject: Re: sata_nv + ADMA + Samsung disk problem
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com> <477B0CFD.1030603@shaw.ca> <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com> <477BDEA5.8040701@garzik.org> <F72FA20C31DD4F4C997B91C5B3690A0950557D@hqemmail07.nvidia.com> <477C2A99.9010208@shaw.ca>
In-Reply-To: <477C2A99.9010208@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
..
>  From some of the traces I took previously (posted on LKML as "sata_nv 
> ADMA controller lockup investigation" way back in Feb 07), what seems to 
> occur is that when the second command is issued very rapidly (within 
> less than 20 microseconds, or potentially longer) after the previous 
> command's completion, the ADMA status changes from 0x500 (STOPPED and 
> IDLE) to 0x400 (just IDLE) as it typically does, but then it sticks 
> there, no interrupt is ever raised, and CPB response flags remain at 0.
..

Assuming that NVidia got their ADMA core logic from Pacific Digital
(the inventors), then it may have some of the same bugs as the original.

One of those bugs is that the aGO trigger is sampled in a "racey" way,
such that it sometimes may miss a recent addition to the ring.

The *only* way to guarantee things with the original Pacific Digital core
was to (1) always retrigger aGO for a full ring scan with each new addition,
and (2) poll periodically (every half second or so) rather than relying
exclusively on the IRQ actually working..

Dunno about the NVidia version.

Cheers
 

