Return-Path: <linux-kernel-owner+w=401wt.eu-S1751286AbXCEBJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbXCEBJl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXCEBJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:09:41 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:64282 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbXCEBJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:09:40 -0500
Date: Sun, 04 Mar 2007 20:09:38 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu
 scheduler
In-reply-to: <20070304231312.GA2268@1wt.eu>
To: linux-kernel@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>, Con Kolivas <kernel@kolivas.org>,
       Al Boldi <a1426z@gawab.com>, ck list <ck@vds.kolivas.org>
Message-id: <200703042009.38270.gene.heskett@gmail.com>
Organization: very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703042335.26785.a1426z@gawab.com>
 <200703050849.29674.kernel@kolivas.org> <20070304231312.GA2268@1wt.eu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2007, Willy Tarreau wrote:
>On Mon, Mar 05, 2007 at 08:49:29AM +1100, Con Kolivas wrote:
>(...)
>
>> > That's just what it did, but when you "nice make -j4", things
>> > (gears) start to stutter.  Is that due to the staircase?
>>
>> gears isn't an interactive task. Apart from using it as a background
>> load to check for starvation because it loads up the cpu fully (which
>> a gpu intensive but otherwise simple app like this should _not_ do)
>> graphics card drivers and interrupts and so on, I wouldn't put much
>> credence on gears as anything else. However I suspect that gears will
>> still get a fair share of the cpu on RSDL which almost never happens
>> on any other scheduler.
>
>Con,
>
>I've now given it a try with HZ=250 on my dual-athlon. It works
> beautifully. I also quickly checked that playing mp3 doesn't skip
> during make -j4, and that gears runs fairly smoothly, since those are
> the references people often use.
>
>But with real work, it's excellent too. When I saturate my CPUs by
> injecting HTTP traffic on haproxy, the load is stable and the command
> line perfectly responsive, while in the past the load would oscillate
> and the command line sometimes stopped to respond for a few seconds.
>
>I've also launched my scheddos program (you may remember, the one we did
> a few experiments with). I could not cause any freeze at all. Plain
> 2.6.20 had already improved a lot in this area, but above 4
> processes/CPU, occasional short freezes did still occur. This time,
> even at 100 processes, the system was rather slow (of course!) but just
> as expected, and nothing more.
>
>I also tried the good old "dd if=/dev/zero bs=1|...|dd bs=1
> of=/dev/null" and it did not cause any trouble.
>
>I will boot 2.6 slightly more often to test the code under various
> conditions, and I will recommend it to a few people I know who tend to
> switch back to 2.4 after one day full of 2.6 jerkiness.
>
>Overall, you have done a great job !
>
>I hope that more people will give it a try, first to help find possible
>remaining bugs, and to pronounce in favour of its inclusion in mainline.
>
>Cheers,
>Willy
>
+1 for mainline, this is a HUGE improvement in usability.  End of 
discussion AFAIK.
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/



-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
