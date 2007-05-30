Return-Path: <linux-kernel-owner+w=401wt.eu-S1761510AbXE3WM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510AbXE3WM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbXE3WMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:12:45 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:35499 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761444AbXE3WMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:12:44 -0400
Message-ID: <465DF627.9090105@cosmosbay.com>
Date: Thu, 31 May 2007 00:09:43 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org> <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 31 May 2007 00:09:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
> On Wed, 30 May 2007, Linus Torvalds wrote:
> 
>>> And then the semantics: do these descriptors should show up in
>>> /proc/self/fd?  Are there separate directories for each namespace?  Do
>>> they count against the rlimit?
>> Oh, absolutely. The'd be real fd's in every way. People could use them 
>> 100% equivalently (and concurrently) with the traditional ones. The whole, 
>> and the _only_ point, would be that it breaks the legacy guarantees of a 
>> dense fd space.
>>
>> Most apps don't actually *need* that dense fd space in any case. But by 
>> defaulting to it, we wouldn't break those (few) apps that actually depend 
>> on it.
> 
> I agree. What would be a good interface to allocate fds in such area? We 
> don't want to replicate syscalls, so maybe a special new dup function?
> 

If the deal is to be able to get faster open()/socket()/pipe()/... calls by 
not finding the first 0 bit in a huge bitmap, a better way would be to have a 
flag in struct task, reset to 0 at exec time.

A new syscall would say : This process is OK to receive *random* fds.


