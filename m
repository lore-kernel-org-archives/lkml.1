Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZJCRyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZJCRyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZJCRyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:54:07 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37283 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZJCRyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:54:06 -0400
Message-ID: <4AC78F7C.40908@gmail.com>
Date: Sat, 03 Oct 2009 19:53:00 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bug #14301] WARNING: at net/ipv4/af_inet.c:154
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.mdH.sMTxKB@chimera> <4AC70D20.4060009@gmail.com> <4AC710DF.5070705@gmail.com>
In-Reply-To: <4AC710DF.5070705@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Sat, 03 Oct 2009 19:53:03 +0200 (CEST)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Eric Dumazet a écrit :
>> Rafael J. Wysocki a écrit :
>>> This message has been generated automatically as a part of a report
>>> of regressions introduced between 2.6.30 and 2.6.31.
>>>
>>> The following bug entry is on the current list of known regressions
>>> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>>> be listed and let me know (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14301
>>> Subject		: WARNING: at net/ipv4/af_inet.c:154
>>> Submitter	: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
>>> Date		: 2009-09-30 12:24 (2 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=125431350218137&w=4
>>>
>>>
>> If commit d99927f4d93f36553699573b279e0ff98ad7dea6
>> (net: Fix sock_wfree() race) doesnt fix this problem, then
>> maybe we should take a look at an old patch.
>>
>> < data mining... running... output results to lkml/netdev >
>>
>> Random guesses
>>
>>  1) : commit d55d87fdff8252d0e2f7c28c2d443aee17e9d70f
>> (net: Move rx skb_orphan call to where needed)
>>
>> A similar problem on SCTP was fixed by commit 
>> 1bc4ee4088c9a502db0e9c87f675e61e57fa1734
>> (sctp: fix warning at inet_sock_destruct() while release sctp socket)
>>
>> 2) CORK and UDP sockets
>>   It seems we can leave an UDP socket with a frame in sk_write_queue
>>   Purge of this queue is done by udp_flush_pending_frames()
>>    This calls ip_flush_pending_frames()
>>    But this function only calls kfree_skb(), not sk_wmem_free_skb()...
>>
>>
>> Could you try following patch ?
>>
> 
> Hmm, I missed the ip_cork_release(), here is an updated version.
> 

Please ignore this patch, I was wrong, sk_forward_alloc is not used
on xmit side for udp, only receive side. CORK/UDP should be fine

Investigation still needed...


