Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZHNVho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZHNVho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZHNVho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:37:44 -0400
Received: from mail.candelatech.com ([208.74.158.172]:44109 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbZHNVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:37:43 -0400
Message-ID: <4A85D921.3050604@candelatech.com>
Date: Fri, 14 Aug 2009 14:37:37 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to disable DMA for compact-flash disk?
References: <4A81BDA6.4080804@candelatech.com>	<20090811201206.14556624@lxorguk.ukuu.org.uk>	<4A85CDCF.3060802@candelatech.com>	<20090814221038.19e868a0@lxorguk.ukuu.org.uk>	<4A85D490.6000701@candelatech.com> <20090814223237.1ef61ff1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090814223237.1ef61ff1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 02:32 PM, Alan Cox wrote:
>> Can you give me a clue as to what code needs poking?  I'm working
>> on the latest 31-rc5 tree, btw.
>>
>>
>> PS.  Can't get an ide based 2.6.31-rc5 kernel to boot in F11, though it doesn't seem
>> to be related to ide.  I probably have something wrong in my .config.
>
> Tejun made it all very class based so you have inheriting operations
> structures thus in pata_via.c find
>
> static struct ata_port_operations via_port_ops = {
>          .inherits       =&ata_bmdma_port_ops,
>
> and change it to
>
> static struct ata_port_operations via_port_ops = {
>          .inherits       =&ata_bmdma32_port_ops,

Ok, I notice that my system has sata_via loaded as well,
and it is also not using the 32-bit port ops.  Should I
change it as well?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

