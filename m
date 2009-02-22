Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZBVMrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZBVMrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbZBVMrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:47:24 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:57417 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZBVMrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vpIcoMSuwuG34NG202gKlJGqYBWYFKU868sTdErDiXGymgYjPHSC5oIwvNPIEyVzt2
         mDSA12qrHNl7VWFGqmvbrCVC3pLNJWwMD3JgebGla3JsqvbN4kW3OW+/MKoVZl/YBEJj
         +bwlIw3Ny53/d9nrKrOTbjXpPLC7kbUEXlurg=
Message-ID: <49A14956.7080500@gmail.com>
Date: Sun, 22 Feb 2009 13:47:18 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>, Bob Copeland <me@bob>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222111807.GB5538@silver.sucs.org> <49A13E91.1090601@gmail.com> <20090222122036.GC5538@silver.sucs.org>
In-Reply-To: <20090222122036.GC5538@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.2.2009 13:20, Sitsofe Wheeler wrote:
> On Sun, Feb 22, 2009 at 01:01:21PM +0100, Jiri Slaby wrote:
>> The unsupported jumbo message might be a clue. When we jump to the next:
>> label, the buffer is at the end of the list in software, while in
>> hardware it isn't. In theory, we might hit the bug with rx buffers
>> exhaustion, because the test (bf_last == bf) doesn't work as expected then.
>
> This seems to be happening somewhat regularly now - I've got a small
> collections of the warnings (I'll include them below in case they are
> any help):
[...]
> [11207.741042]   Object 0xd7060000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [11207.741071]   Object 0xd7060010:  80 00 00 00 ff ff ff ff ff ff 00 30 ab 1a 32 3f ....ÿÿÿÿÿÿ.0«.2?

All of them are almost the same scenario, the last one was data not 
beacon, but it's irrelevant. And previously I was wrong, we move the 
buffer to the end even on hardware side. Thanks so far, I personally see 
no reason for this to happen yet.
