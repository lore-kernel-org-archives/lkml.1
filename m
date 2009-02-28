Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbZB1XIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbZB1XIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 18:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbZB1XIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 18:08:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:33022 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZB1XIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 18:08:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cLvEf7aSZH0Z0pqJGY9F6VbxHD7EuvKYgIUG7nffrQw3tCuw+/ILWmE8gn7VeZCdj5
         0DCfkPUSfMHvy/RgOam/jQUkKQCWSdFrmxk9MNTXPfhOZF1Y2+KRK0KGhwM7fRYfSyPj
         KLfu6HXz8Ml5PMwNpPdtJthj8nBaCK/pd+pyY=
Message-ID: <49A9C3D7.8060706@gmail.com>
Date: Sun, 01 Mar 2009 00:08:07 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Dhaval Giani <dhaval.lists@thegianis.in>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linville@tuxdriver.com,
       davem@davemloft.net, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ath5k: fix hw rate index condition
References: <1231336282-22283-1-git-send-email-jirislaby@gmail.com> <1231338965-796-1-git-send-email-jirislaby@gmail.com> <20090107152208.GB4207@linux.vnet.ibm.com> <4964CAAA.3040801@gmail.com> <25891f3e0902012357n21e7bc2fmc59fb2a842631651@mail.gmail.com> <20090215134702.GA10180@hash.localnet>
In-Reply-To: <20090215134702.GA10180@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.2.2009 14:47, Bob Copeland wrote:
> On Mon, Feb 02, 2009 at 01:27:39PM +0530, Dhaval Giani wrote:
>> So I finally managed to hit this on 2.6.29-rc3. It is hard to
>> reproduce, so I hope so much information is enough to give you a good
>> guess. This time it hit while trying to connect to an open network at
>> the airport.
>
>> WARNING: at net/mac80211/rx.c:2236 __ieee80211_rx+0x96/0x571 [mac80211]()
>> Hardware name: 2007CS3
>> RATE=255, BAND=8
>
> band is supposed to be sc->curband?  8 is way wrong.

If you look into the patch which outputs this (backtrace in this 
thread), sband->n_bitrates is 8. I have no idea what I have been smoking 
the day I wrote it, but BAND= for sure isn't the right name for that 
thing. Sorry for the confusion.

> rate could be 255
> if, for some reason, the hardware rate wasn't in the rate table.

So, we have a fix for this, right? I mean the u8->s8 sc->rate_idx 
conversion or alike...
