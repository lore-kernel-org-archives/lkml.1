Return-Path: <linux-kernel-owner+w=401wt.eu-S932923AbXBPCJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923AbXBPCJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 21:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932922AbXBPCJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 21:09:15 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33491 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbXBPCJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 21:09:14 -0500
Message-ID: <45D51248.5070408@garzik.org>
Date: Thu, 15 Feb 2007 21:09:12 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "Luck, Tony" <tony.luck@intel.com>,
       Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [git patches] libata updates (mostly fixes)
References: <20070215233411.GA10782@havoc.gtf.org> <Pine.LNX.4.64.0702151546130.20368@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702151546130.20368@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 15 Feb 2007, Jeff Garzik wrote:
>> diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
>> index db185f3..d51f0f1 100644
>> --- a/arch/ia64/Kconfig
>> +++ b/arch/ia64/Kconfig
>> @@ -22,6 +22,7 @@ config IA64
>>  
>>  config 64BIT
>>  	bool
>> +	select ATA_NONSTANDARD if ATA
>>  	default y
> 
> Ok, this is just _strange_.

Agreed.


> Tying ATA_NONSTANDARD into ia64 by tying it to the 64BIT config variable 
> may work (well, I _assume_ it does), but it's just psychedelic.

AFAICT it's an attempt to do an unconditional 'select'.  I'm /not/ 
disputing its psychedilic properties, certainly, just figured that was 
the way that IA64 arch folks did stuff like this.


> How about adding a separate config entry like
> 
> 	config IA64_ATA
> 		bool
> 		depends on ATA
> 		select ATA_NONSTANDARD
> 		default y
> 
> which kind of makes sense when you squint just the right way..

Either way, that seems sane to me.  I'd love to have some IA64 folks to 
comment though.

	Jeff


