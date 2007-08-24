Return-Path: <linux-kernel-owner+w=401wt.eu-S1765343AbXHXTF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765343AbXHXTF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbXHXTFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:05:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50877 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758335AbXHXTFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:05:14 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: RFC: issues concerning the next NAPI interface
To: Linas Vepstas <linas@austin.ibm.com>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Reply-To: 7eggert@gmx.de
Date: Fri, 24 Aug 2007 21:04:56 +0200
References: <8VHRR-45R-17@gated-at.bofh.it> <8VKwj-8ke-27@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IOeSm-0000bm-Jo@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+2cGwZ8ftRb/GDtvIhEamL8FSRlmWcMnhLBkZ
 xx4GmSIcf1xuFKzKCvCXkd/ke/YHP6wxq6UT4VJ2mojSOZ43Rp
 266al3AVib3nY3/cUxLQw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas <linas@austin.ibm.com> wrote:
> On Fri, Aug 24, 2007 at 03:59:16PM +0200, Jan-Bernd Themann wrote:

>> 3) On modern systems the incoming packets are processed very fast. Especially
>> on SMP systems when we use multiple queues we process only a few packets
>> per napi poll cycle. So NAPI does not work very well here and the interrupt
>> rate is still high.
> 
> I saw this too, on a system that is "modern" but not terribly fast, and
> only slightly (2-way) smp. (the spidernet)
> 
> I experimented wih various solutions, none were terribly exciting.  The
> thing that killed all of them was a crazy test case that someone sprung on
> me:  They had written a worst-case network ping-pong app: send one
> packet, wait for reply, send one packet, etc.
> 
> If I waited (indefinitely) for a second packet to show up, the test case
> completely stalled (since no second packet would ever arrive).  And if I
> introduced a timer to wait for a second packet, then I just increased
> the latency in the response to the first packet, and this was noticed,
> and folks complained.

Possible solution / possible brainfart:

Introduce a timer, but don't start to use it to combine packets unless you
receive n packets within the timeframe. If you receive less than m packets
within one timeframe, stop using the timer. The system should now have a
decent response time when the network is idle, and when the network is
busy, nobody will complain about the latency.-)
-- 
Funny quotes:
22. When everything's going your way, you're in the wrong lane and and going
    the wrong way.
Friﬂ, Spammer: rsRxhvmk@CaR.7eggert.dyndns.org m@z3T.7eggert.dyndns.org
