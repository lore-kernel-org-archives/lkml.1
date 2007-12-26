Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbXLZL2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbXLZL2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbXLZL2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:28:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:31140 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXLZL2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:28:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sQ4oNHo7v1OwFqAlRBusa5PCUn0qQ6lWIlXJnk/7iL318OiEwB/HDrT4ooW8g6oRY/g0kV4wnt3tlq6f9Ll7tOazSgFcvWEb3cQN9Vd37rgDjWYOzscHtg9lcLGM6PdLmp6SqY4zwptY7SEIDAjD3JL+d3kFiqeWciaVduMjZ/s=
Message-ID: <47720C93.2010800@gmail.com>
Date: Wed, 26 Dec 2007 17:10:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       jgarzik@pobox.com, pavel@suse.cz, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24-rc6 and earlier: "host bus error" after STR
References: <20071224204813.GA3546@martell.zuzino.mipt.ru> <20071225094151.GA9769@havoc.gtf.org>
In-Reply-To: <20071225094151.GA9769@havoc.gtf.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jeff Garzik wrote:
>> ata3.00: limiting speed to UDMA/33:PIO4
>> ata3.00: exception Emask 0x0 Sact 0x0 Serr 0x0 action 0x2
>> ata3.00: BMDMA stat 0x6
>> ata3.00: cmd ca/00:08:47:66:6e/00:00:00:00:00/eb tag 0 dma 4096 out
>> 	 res 51/84:08:47:66:6e/00:00:00:00:00/eb Emask 0x30 (host bus error)
>> ata3.00: status: { DRDY ERR }
>> ata3.00: error: { ICRC ABRT }
>> ata3: soft resetting link
> 
> host bus == PCI
> 
> So, your PCI bus is crapping itself in a major way.
> 
> One thing to try might be "libata.noacpi=1"

Yeah, BMDMA stat 0x6 is INTR and ERR which means the controller tried to
perform DMA write but couldn't pull data from main memory.  Maybe PCI
bus isn't setup properly after resuming.  Comparing the result of 'lspci
-xxx' before and after resume and see what changed can be helpful.

Thanks.

-- 
tejun

