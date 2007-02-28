Return-Path: <linux-kernel-owner+w=401wt.eu-S1751157AbXB1CXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbXB1CXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 21:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbXB1CXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 21:23:50 -0500
Received: from smtp102.plus.mail.mud.yahoo.com ([68.142.206.235]:24872 "HELO
	smtp102.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751157AbXB1CXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 21:23:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=0aVU3H+wib36f7h16JpIabq0o4VmLV0Y0U+0HFNGlfpzQmzis1N5cgIQZ1AplkkqEAnQCmfIDBB6se1mgyy1/4HagCFszwAy9hv+VaJNjSSJeyJOMabezgmZDzaW6DKrY8Q+B+g7AgfWW2doE4TxG+lNJ1SfZgl09bImNt8cNBU=  ;
X-YMail-OSG: IU84U5cVM1lZyOBXjVeraLfHnsKBBxUzmmZfelVD3096Ms3z0h73zcDa.r9WMt3MTuwGBxG.0W3rU7CTZaPd8GWSmQCvY0JNjyvUIlWYNRuCkLrWqfHV50V.a8Rjbnpax6WNXEZnGzL7LZY-
Message-ID: <45E4E780.8010109@yahoo.com.au>
Date: Wed, 28 Feb 2007 13:22:56 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: Rik van Riel <riel@redhat.com>, Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan>	 <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <29495f1d0702271727w358cc9o644c4017d50634a9@mail.gmail.com>
In-Reply-To: <29495f1d0702271727w358cc9o644c4017d50634a9@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nish Aravamudan wrote:
> On 2/26/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> Rik van Riel wrote:
>> > Lorenzo Allegrucci wrote:
>> >
>> >> Hi lkml,
>> >>
>> >> according to the test below (sysbench) Linux seems to have scalability
>> >> problems beyond 8 client threads:
>> >> http://jeffr-tech.livejournal.com/6268.html#cutid1
>> >> http://jeffr-tech.livejournal.com/5705.html
>> >> Hardware is an 8-core amd64 system and jeffr seems willing to try more
>> >> Linux versions on that machine.
>> >> Anyway, is there anyone who can reproduce this?
>> >
>> >
>> > I have reproduced it on a quad core test system.
>> >
>> > With 4 threads (on 4 cores) I get a high throughput, with
>> > approximately 58% user time and 42% system time.
>> >
>> > With 8 threads (on 4 cores) I get way lower throughput,
>> > with 37% user time, 29% system time 35% idle time!
>> >
>> > The maximum time taken per query also increases from
>> > 0.0096s to 0.5273s. Ouch!
>> >
>> > I don't know if this is MySQL, glibc or Linux kernel,
>> > but something strange is going on...
>>
>> Like you, I'm also seeing idle time start going up as threads increase.
>>
>> I initially thought this was a problem with the multiprocessor scheduler,
>> because the pattern is exactly like some artificat in the load balancing.
>>
>> However, after looking at the stats, and testing a couple of things, I
>> think it may not be after all.
>>
>> I've reproduced this on a 8-socket/16-way dual core Opteron. So far what
>> I am seeing is that MySQL is having trouble putting enough load into the
>> scheduler.
> 
> 
> Here are some graphs from the 4-socket/8-way Xeon box (no SMT, no MC
> in .config) I posted about earlier.
> 
> transactions.png resembles Nick's results pretty closely, in that a
> drop-off occurs, at the same # of threads, too. That seems weird to
> me, but I haven't thought about it too closely. Shouldn't Nick's be
> dropping off closer to 16 threads (that would be 1 per core, then,
> right?)

I don't think it is exactly a matter of processes >= cores, but rather
just a general problem at higher concurrency.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
