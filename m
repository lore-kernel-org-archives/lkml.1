Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZBWQl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZBWQl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZBWQlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:41:06 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:36848 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741AbZBWQlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:41:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PxVxMU9DBT/wVyAdy8ZFUS2HY33ri5oqTTMn9f0KJZC6CDdGIT382qCRDIxwQGZwFC
         6DHNdj6SVgZl4DlTquppIU6Cq/lDvjTfk//i24rf+odZ6OYi4NB9f8M5r1COkTsIDnNx
         1e9phvKnzs5uUi7g4UWtEyr5KIZLVqyMyxhJk=
MIME-Version: 1.0
In-Reply-To: <20090223163032.GA3450@hash.localnet>
References: <20090222122036.GC5538@silver.sucs.org>
	 <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com>
	 <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com>
	 <40f31dec0902230803qcbd4c20kc66a50e6e2e8eef2@mail.gmail.com>
	 <40f31dec0902230815x6b43fa50h41edfeead96822a3@mail.gmail.com>
	 <20090223162103.GA3383@hash.localnet>
	 <40f31dec0902230827j5c0f9f20je02c7fb02709f71e@mail.gmail.com>
	 <20090223163032.GA3450@hash.localnet>
Date: Mon, 23 Feb 2009 18:41:01 +0200
Message-ID: <40f31dec0902230841m712acff4qe1c1617819f028be@mail.gmail.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/23 Bob Copeland <me@bobcopeland.com>:
> On Mon, Feb 23, 2009 at 06:27:35PM +0200, Nick Kossifidis wrote:
>> 2009/2/23 Bob Copeland <me@bobcopeland.com>:
>> > On Mon, Feb 23, 2009 at 06:15:51PM +0200, Nick Kossifidis wrote:
>> >> Typo alert...
>> >> rs->rs_more = !!(rx_status->rx_status_0 & AR5K_5212_RX_DESC_STATUS0_MORE);
>> >
>> > I'm slow... what's wrong with it?
>> >
>>
>> "!!"
>>
>> it should be just
>>
>> rs->rs_more = (rx_status->rx_status_0 & AR5K_5212_RX_DESC_STATUS0_MORE);
>
> No, that's intentional.  That was actually a bug we had at some point
> (rs_more is a u8 so the bitwise AND overflowed).  The "!!" makes it zero
> or one so it fits.
>

AR5K_REG_MS is used for that, we should just shift it as we do with
the other fields and btw i think we must change flags to be bool.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
