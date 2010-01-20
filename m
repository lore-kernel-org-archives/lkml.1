Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854Ab0ATWxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0ATWxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834Ab0ATWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:53:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50261
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754712Ab0ATWxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:53:06 -0500
Date: Wed, 20 Jan 2010 14:53:16 -0800 (PST)
Message-Id: <20100120.145316.109996493.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: jarkao2@gmail.com, shemminger@linux-foundation.org, mbreuer@majjas.com,
       akpm@linux-foundation.org, flyboy@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       mchan@broadcom.com, pcnet32@verizon.net, romieu@fr.zoreil.com,
       mcarlson@broadcom.com
Subject: Re: [PATCH] sky2: Fix WARNING: at lib/dma-debug.c:902 check_sync
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100120222414.57909d14@lxorguk.ukuu.org.uk>
References: <20100120094103.GA6225@ff.dom.local>
	<20100120222414.57909d14@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 20 Jan 2010 22:24:14 +0000

>> > Seems like an underlying bug in the DMA api. Maybe it just can't
>> > handle operations on partial mapping.
>> > 
>> > Other drivers with same problem:
>> >   bnx2, cassini, pcnet32, r8169, rrunner, skge, sungem, tg3, 
>> 
>> It seems using the same length (even without pci_unmap_len()) is
>> crucial here, but I hope maintainers (added to CC) will take care.
> 
> The API needs fixing - if you've got a large mapping and you want to sync
> part of it then we need to support that. Now it might well be that the
> implementation on some braindead platform has to sync the entire thing,
> and some implementations entire pages or cache lines.
> 
> You can't fix this in the drivers, they requested a service and they
> don't have enough information nor is it their job to know about all the
> platform specific rules.

Absolutely and %100 agreed, the DMA debugging layer and documentation
are both buggy.

The intention from the beginning was always to allow partial SYNCs
exactly for the reasons Alan and myself are mentioning here.
