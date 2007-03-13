Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbXCMKiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbXCMKiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 06:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXCMKiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 06:38:00 -0400
Received: from smtp108.plus.mail.mud.yahoo.com ([68.142.206.241]:45786 "HELO
	smtp108.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753217AbXCMKh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 06:37:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=X7Cv+3micT7BhK19/U2SCLko9RysjPm+Z+ZppTcrVhNsZTCvHJ8yeLjhc6y7WvTR+pswTzE+CaN9/2zynkhBmrL/yHqKblef33emlSZS8G/HXBBU/AbcdiMld+xfIPiHufhW8PoD0HXG5VIrIAcXpNwcU7BhEhvFhe2ZAv09f9w=  ;
X-YMail-OSG: zx7G8CcVM1mZ1R4PrMNd6RaqWg.Os9s8yPtsJYyJDz0Tyh349yfXXcHDQazFgTT.3bz33mxf4iMHEuDc7uSxEWWXrESvm.A5BoQw_lKdXfFBLy9YSpaKnA--
Message-ID: <45F67F02.5020401@yahoo.com.au>
Date: Tue, 13 Mar 2007 21:37:54 +1100
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
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au> <20070313094559.GC8992@v2.random> <45F67796.4040508@yahoo.com.au> <20070313103134.GF8992@v2.random>
In-Reply-To: <20070313103134.GF8992@v2.random>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Tue, Mar 13, 2007 at 09:06:14PM +1100, Nick Piggin wrote:
> 
>>Well ignoring the HT issue, I was seeing lots of idle time simply
>>because userspace could not keep up enough load to the scheduler.
>>There simply were fewer runnable tasks than CPU cores.
> 
> 
> When you said idle I thought idle and not waiting for I/O. Waiting for
> I/O would be hardly a kernel issue ;). If they're not waiting for I/O
> and they're not scheduling in userland with nanosleep/pause, the cpu
> shouldn't go idle. Even if they're calling sched_yield in a loop the
> cpu should account for zero idle time as far as I can tell.

Well it wasn't iowait time. From Anton's analysis, I would probably
say it was time waiting for either the glibc malloc mutex or MySQL
heap mutex.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
