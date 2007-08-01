Return-Path: <linux-kernel-owner+w=401wt.eu-S1763723AbXHABMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763723AbXHABMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbXHABMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:12:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57370 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbXHABMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:12:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46AFDDD8.8050903@s5r6.in-berlin.de>
Date: Wed, 01 Aug 2007 03:11:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [Patch 14/16] Remove needless kmalloc casts in the zd1211rw drivers.
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125446.578465000@hawkeye.stone.uk.eu.org> <46AF44C5.50102@gentoo.org>
In-Reply-To: <46AF44C5.50102@gentoo.org>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Drake wrote:
> jack@hawkeye.stone.uk.eu.org wrote:
>> Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
>>
>> CC: Daniel Drake <dsd@gentoo.org>
> 
> NAK: this patch adds a sparse warning
> zd_chip.c:116:15: warning: implicit cast to nocast type

What does this warning mean?  a16 is defined as zd_addr_t *.

>> --- a/drivers/net/wireless/zd1211rw/zd_chip.c
>> +++ b/drivers/net/wireless/zd1211rw/zd_chip.c
>> @@ -115,7 +115,7 @@ int zd_ioread32v_locked(struct zd_chip *
>>  
>>      /* Allocate a single memory block for values and addresses. */
>>      count16 = 2*count;
>> -    a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) +
>> sizeof(u16)),
>> +    a16 = kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
>>                             GFP_KERNEL);
>>      if (!a16) {
>>          dev_dbg_f(zd_chip_dev(chip),
>>

Also, why is there this cast right before that?

	zd_addr_t *a16 = (zd_addr_t *)NULL;

-- 
Stefan Richter
-=====-=-=== =--- ----=
http://arcgraph.de/sr/
