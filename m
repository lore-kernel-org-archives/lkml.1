Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbZBBNn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbZBBNn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 08:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZBBNnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 08:43:50 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:27375 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZBBNnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 08:43:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=trGNWXqRMeAHRK7XBkn3NwGAeFctVo0ikXz6SNjAJ93dnA8STb9kmndJ9EwLOdvrP9
         6p8ocz9wcr85vuWg/bcJ2sudUEU0bV8ve4wrSGAqTOXFGdNN07GtgYxm+DRKO9PhptyQ
         ZcgVAfAi7Lk3SsA2L8/mxmsa4e55QKG7Gcjpo=
MIME-Version: 1.0
In-Reply-To: <1233580147.4787.207.camel@laptop>
References: <20090202101735.GA12757@barrios-desktop>
	 <28c262360902020225w6419089ft2dda30da9dfb32a9@mail.gmail.com>
	 <1233571202.4787.124.camel@laptop>
	 <20090202112721.GA13532@barrios-desktop>
	 <1233575085.4787.140.camel@laptop>
	 <20090202115627.GB13532@barrios-desktop>
	 <1233580147.4787.207.camel@laptop>
Date: Mon, 2 Feb 2009 22:43:48 +0900
Message-ID: <28c262360902020543we62e394kb21c16f599824552@mail.gmail.com>
Subject: Re: [BUG??] Deadlock between kswapd and sys_inotify_add_watch(lockdep 
	report)
From: MinChan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, linux kernel <linux-kernel@vger.kernel.org>,
       linux mm <linux-mm@kvack.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 10:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-02-02 at 20:56 +0900, MinChan Kim wrote:
>> Thanks for kind explanation. :)
>> Unfortunately, I still have a question. :(
>
> No problem :-)
>
>> > > I think if reclaim context which have GFP_FS already have lock A and then
>> > > do pageout, if writepage need the lock A, we have to catch such a case.
>> > > I thought Nick's patch's goal catchs such a case.
>> >
>> > Correct, it exactly does that.
>>
>> But, I think such a case can be caught by lockdep of recursive detection
>> which is existed long time ago by making you.
>
> (Ingo wrote that code)
>
>> what's difference Nick's patch and recursive lockdep ?
>
> Very good question indeed. Every time I started to write an answer I
> realize its wrong.
>
> The below is half the answer:
>
> /*
>  * Check whether we are holding such a class already.
>  *
>  * (Note that this has to be done separately, because the graph cannot
>  * detect such classes of deadlocks.)
>  *
>  * Returns: 0 on deadlock detected, 1 on OK, 2 on recursive read
>  */
> static int
> check_deadlock(struct task_struct *curr, struct held_lock *next,
>               struct lockdep_map *next_instance, int read)
>
> So in order for the reclaim report to trigger we have to actually hit
> that code path that has the recursion in it. The reclaim context
> annotation by Nick ensures we detect such cases without having to do
> that.

In my case and Nick's patch's example hit code path that has the
recursion in it.
then reported it.

Do I miss something ?

> The second half, to which I cannot seem to get a decent answer to atm,
> is why the recursion case isn't detected by the graph.
>
>
>
>



-- 
Kinds regards,
MinChan Kim
