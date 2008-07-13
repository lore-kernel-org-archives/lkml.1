Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYGMKs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYGMKs2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 06:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYGMKsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 06:48:18 -0400
Received: from OSB1387.piap.pl ([195.187.100.11]:53124 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbYGMKsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 06:48:17 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [bisected] kernel panic 2.6.22 -> 2.6.26-rc9+
References: <m3d4lisk4i.fsf@maximus.localdomain>
	<20080713013107.23f060f2.akpm@linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 13 Jul 2008 12:48:15 +0200
In-Reply-To: <20080713013107.23f060f2.akpm@linux-foundation.org> (Andrew Morton's message of "Sun\, 13 Jul 2008 01\:31\:07 -0700")
Message-ID: <m3abgmcb68.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> (cc's added)

(cc added) :-)

> I guess you're referring to this:
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-07/msg04754.html

Right.

>> PPP over ATM connection (Thomson/Alcatel
>> Speedtouch). It doesn't seem to occur on the same IXP4xx with Ethernet
>> or V.35 WAN, and it doesn't occur on i386 + the same Speedtouch ADSL.
>> The kernel is basically unpatched, the only extra patch applied is the
>> platform support (nothing magic).
>> 
>> Generally to trigger the panic one has to request a TCP data stream
>> over that PPPoATM connection.

I see what's wrong now: that's the ARM fls() problem, the call in
fls64() to be precise. It seems it was already discussed: the patch in
http://lkml.org/lkml/2008/5/4/233 makes the problem disappear.

Perhaps it's time to fix it definitely?
-- 
Krzysztof Halasa
