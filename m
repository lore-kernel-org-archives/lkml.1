Return-Path: <linux-kernel-owner+w=401wt.eu-S935082AbXFGUGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbXFGUGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934374AbXFGUFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:05:48 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:33751 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100AbXFGUFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:05:47 -0400
Message-ID: <466864F8.2050903@cosmosbay.com>
Date: Thu, 07 Jun 2007 22:05:12 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Kyle Moffett <mrmacman_g4@mac.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com> <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com> <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 07 Jun 2007 22:05:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
> On Thu, 7 Jun 2007, Eric Dumazet wrote:
> 
>> Davide, are you sure we want FIFO for non sequential allocations ?
>>
>> This tends to use all the fmap slots, and not very cache friendly
>> if an app does a lot of [open(),...,close()] things. We already got a 
>> perf drop because of RCUification of file freeing (FIFO mode instead 
>> of LIFO given by kmalloc()/kfree())
>>
>> If the idea behind this FIFO was security (ie not easy for an app to predict 
>> next glibc file handle), we/glibc might use yet another FD_SECUREMODE flag, 
>> wich ORed with O_NONSEQFD would ask to fdmap_newfd() to take the tail of 
>> fmap->slist, not head.
> 
> Uli, would it be OK to rely only on base randomization and use a LIFO 
> instead? We have base randomization, plus LIFO does not mean strictly 
> sequential like legacy allocator, just more compatc and cache friendly.
> 

I am afraid randomization wont really work if /sbin/init or /bin/bash for 
example uses one (or more) unseq fd :
The 'random base' will be propagated at fork()/exec() time ?





