Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbYACEzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbYACEzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 23:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYACEzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 23:55:07 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:50788 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYACEzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 23:55:05 -0500
Date: Wed, 02 Jan 2008 22:54:29 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv + ADMA + Samsung disk problem
In-reply-to: <477C61D3.30009@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: Allen Martin <AMartin@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Gabor Gombas <gombasg@sztaki.hu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kuan Luo <kluo@nvidia.com>, Peer Chen <pchen@nvidia.com>
Message-id: <477C6A85.9020607@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu>
 <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com>
 <477B0CFD.1030603@shaw.ca>
 <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com>
 <477BDEA5.8040701@garzik.org>
 <F72FA20C31DD4F4C997B91C5B3690A0950557D@hqemmail07.nvidia.com>
 <477C2A99.9010208@shaw.ca> <477C61D3.30009@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Robert Hancock wrote:
> ..
>>  From some of the traces I took previously (posted on LKML as "sata_nv 
>> ADMA controller lockup investigation" way back in Feb 07), what seems 
>> to occur is that when the second command is issued very rapidly 
>> (within less than 20 microseconds, or potentially longer) after the 
>> previous command's completion, the ADMA status changes from 0x500 
>> (STOPPED and IDLE) to 0x400 (just IDLE) as it typically does, but then 
>> it sticks there, no interrupt is ever raised, and CPB response flags 
>> remain at 0.
> ..
> 
> Assuming that NVidia got their ADMA core logic from Pacific Digital
> (the inventors), then it may have some of the same bugs as the original.
> 
> One of those bugs is that the aGO trigger is sampled in a "racey" way,
> such that it sometimes may miss a recent addition to the ring.
> 
> The *only* way to guarantee things with the original Pacific Digital core
> was to (1) always retrigger aGO for a full ring scan with each new 
> addition,
> and (2) poll periodically (every half second or so) rather than relying
> exclusively on the IRQ actually working..
> 
> Dunno about the NVidia version.

Theirs works rather differently - the GO bit is there, but there's 
another append register which is used to tell the controller that a new 
tag has been added to the CPB list.

The only thing we currently use the GO bit for is to switch between ADMA 
and port register mode. Could be there's something we need to do there, 
though, who knows..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

