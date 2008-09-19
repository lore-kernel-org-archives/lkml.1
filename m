Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYISOrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYISOrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbYISOq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:46:57 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:37455 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbYISOq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:46:56 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=BaUkJ4HlQeIo_abhGUcA:9 a=VQBRLt_Hx9u0tOfrwq4A:7 a=S3ydakkHyz1fFyuuuPCqH5FmD6AA:4 a=sCdmCc1IbicA:10 a=R0WQXXnd5IYA:10
Message-ID: <48D3BB5B.7060003@shaw.ca>
Date: Fri, 19 Sep 2008 08:46:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Ingo Molnar <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5,
 rc6, probably others)
References: <fa.jQQm4Iwb0lkAWxV+5FAfTMHY4m4@ifi.uio.no> <fa.zGA6t2p+jJeMRIaZFOqy1I8En1c@ifi.uio.no> <fa.AGi3s2gpyC3T3KuCJ8cYQ30teak@ifi.uio.no> <fa.59AlSLNBuMx/BjQSvR6whwGydbU@ifi.uio.no> <fa.NwYDTAB59VZjr1quzgR4OU0+8eQ@ifi.uio.no> <fa.tRre/FoeQKwChGwdusnYJgwjRmw@ifi.uio.no>
In-Reply-To: <fa.tRre/FoeQKwChGwdusnYJgwjRmw@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Noonan wrote:
> Second of all, I'm looking at the ath9k interrupt handler right now,
> and there are a few cases where it returns IRQ_NONE. And here's where
> I'm a bit fuzzy. Since there could be any number of things using IRQ
> 17 (though in my case, ath9k is on its own dedicated IRQ), it seems
> odd that you check the value of sc->sc_invalid, since the cookie
> passed to the handler might not actually be ath9k's cookie if multiple
> drivers have registered IRQ handlers for that particular IRQ. Who
> knows if what you're reading is even valid? Heck, what if some driver
> uses a NULL for their cookie (however unlikely)? You'd get a
> segmentation fault on the second line of the interrupt handler. Of
> course, I could be completely wrong: does parent interrupt handler
> check to see which device driver owns the particular device signaling
> an IRQ and then call the appropriate handler?

All the IRQ handlers registered on that interrupt will get called. The 
cookie will always be the right one for that handler however.

The bug is presumably that it returns IRQ_NONE in some cases where the 
device is actually generating an interrupt. The advice to turn on 
irqpoll is rather useless in this case - that's mainly useful where the 
IRQ routing is messed up and the device can't receive any interrupts at all.
