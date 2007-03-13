Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbXCMFLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbXCMFLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 01:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXCMFLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 01:11:11 -0400
Received: from smtp102.plus.mail.mud.yahoo.com ([68.142.206.235]:45172 "HELO
	smtp102.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753130AbXCMFLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 01:11:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=AnYBQ0BvMKu0qipTMLW2V4yNcS2h0IcFChzKYlGKyoVFY6rTfQVJD5kjqOAKjIn0f7WU0P8En3vhKmPGtVqRwB/uU/rAQBtQpmFqotJ5D1xLCACQ/bMr542H1yAwDbgy+dmOehdJPoabkp90yQOzukKisrNI09hLHb1ektSWUdI=  ;
X-YMail-OSG: ryZd7_0VM1k0lT9dORqWHzdaZxk8ZHx9CS.hTDw.uQ6gvh5732VutNkCmh6xi691U9MIrjnNQ52HQsB0RbV7OXtGMhnHYKTVBsiPZR.dh7CcHCjsekJg6PUPkU4gdtaBFj9e4u0B2t9rMGE-
Message-ID: <45F63266.1080509@yahoo.com.au>
Date: Tue, 13 Mar 2007 16:11:02 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Anton Blanchard <anton@samba.org>
CC: Rik van Riel <riel@redhat.com>, Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten>
In-Reply-To: <20070312220042.GA807@kryten>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard wrote:
>  
> Hi Nick,
> 
> 
>>Anyway, I'll keep experimenting. If anyone from MySQL wants to help look
>>at this, send me a mail (eg. especially with the sched_setscheduler issue,
>>you might be able to do something better).
> 
> 
> I took a look at this today and figured Id document it:
> 
> http://ozlabs.org/~anton/linux/sysbench/
> 
> Bottom line: it looks like issues in the glibc malloc library, replacing
> it with the google malloc library fixes the negative scaling:
> 
> # apt-get install libgoogle-perftools0
> # LD_PRELOAD=/usr/lib/libtcmalloc.so /usr/sbin/mysqld

Hi Anton,

Very cool. Yeah I had come to the conclusion that it wasn't a kernel
issue, and basically was afraid to look into userspace ;)

That bogus setscheduler thing must surely have never worked, though.
I wonder if FreeBSD avoids the scalability issue because it is using
SCHED_RR there, or because it has a decent threaded malloc implementation.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
