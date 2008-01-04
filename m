Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYADBn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYADBn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbYADBns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:43:48 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45651 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbYADBnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:43:46 -0500
Date: Thu, 03 Jan 2008 19:43:39 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv + ADMA + Samsung disk problem
In-reply-to: <1199394786.7291.21.camel@pasglop>
To: benh@kernel.crashing.org
Cc: Mark Lord <liml@rtr.ca>, Allen Martin <AMartin@nvidia.com>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Gabor Gombas <gombasg@sztaki.hu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Kuan Luo <kluo@nvidia.com>,
       Peer Chen <pchen@nvidia.com>
Message-id: <477D8F4B.6000601@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu>
 <20080101164416.GA29574@boogie.lpds.sztaki.hu> <477B0429.7040909@gmail.com>
 <477B0CFD.1030603@shaw.ca>
 <F72FA20C31DD4F4C997B91C5B3690A09505577@hqemmail07.nvidia.com>
 <477BDEA5.8040701@garzik.org>
 <F72FA20C31DD4F4C997B91C5B3690A0950557D@hqemmail07.nvidia.com>
 <477C2A99.9010208@shaw.ca> <477C61D3.30009@rtr.ca> <477C6A85.9020607@shaw.ca>
 <477D02E0.5040301@rtr.ca> <477D039F.6000206@rtr.ca>
 <1199394786.7291.21.camel@pasglop>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
>> Another thing about the PacDigi core:  one has to be very careful
>> to avoid sequential accesses to sequential PCI locations when
>> programming the chip -- it cannot handle merged register writes.
>>
>> So for any group of sequentially laid out registers, the code has
>> to ensure it never writes two adjacent registers in sequence..
> 
> Ugh ? Write combining isn't permitted on normal registers afaik...
> 
> Ben.

Byte merging can be done by the chipset on MMIO writes (merging multiple 
8 or 16-bit writes into a single 32-bit cycle).
