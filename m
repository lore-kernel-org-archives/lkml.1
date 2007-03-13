Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbXCMKG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbXCMKG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbXCMKG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:06:26 -0400
Received: from smtp109.plus.mail.mud.yahoo.com ([68.142.206.242]:48172 "HELO
	smtp109.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753206AbXCMKGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:06:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=WjJpl9K3JcGfmEGC6Yt86Nxrl9+nX0Hyg/dJdSEkHyp5jUTzsRBnjjkxtDsbi8/L2BOYL9uUjNbgEcOpwMewkZg9bzwbiihbSt62FlCjoIN//sltly8L++12h1DU5ArbhAozP8XuB0L9MKAe8fRtX51zDkf9tLocZH17sKNcuCg=  ;
X-YMail-OSG: hZO5ZtcVM1nqTA.YETvRUOQKuLUoZfHGr2cYPAT32lpKDnj5lKEjOMsC4bAbSW2ALPlXkQdTi75f9XjxTE.tkD1HsOIq3nV8xZOA_Gt8UhudhY7LmllJLSqFnmCzIHRCLPjBLD7qyDeQWjCNq8yShPebQ3akNIKWew--
Message-ID: <45F67796.4040508@yahoo.com.au>
Date: Tue, 13 Mar 2007 21:06:14 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@suse.de>
CC: Anton Blanchard <anton@samba.org>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au> <20070313094559.GC8992@v2.random>
In-Reply-To: <20070313094559.GC8992@v2.random>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Tue, Mar 13, 2007 at 04:11:02PM +1100, Nick Piggin wrote:
> 
>>Hi Anton,
>>
>>Very cool. Yeah I had come to the conclusion that it wasn't a kernel
>>issue, and basically was afraid to look into userspace ;)
> 
> 
> btw, regardless of what glibc is doing, still the cpu shouldn't go
> idle IMHO. Even if we're overscheduling and trashing over the mmap_sem
> with threads (no idea if other OS schedules the task away when they
> find the other cpu in the mmap critical section), or if we've
> overscheduling with futex locking, the cpu usage should remain 100%
> system time in the worst case. The only explanation for going idle
> legitimately could be on HT cpus where HT may hurt more than help but
> on real multicore it shouldn't happen.
> 

Well ignoring the HT issue, I was seeing lots of idle time simply
because userspace could not keep up enough load to the scheduler.
There simply were fewer runnable tasks than CPU cores.

But it wasn't a case of all CPUs going idle, just most of them ;)

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
