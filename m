Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYCOWLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYCOWLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 18:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYCOWLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 18:11:10 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:59210 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbYCOWLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 18:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=snU3R9Hurih7c2XpmkAIT+9c3GOIZ2zUIVxnVunXD8vJDbRID7w+PSB1yL4najZyCDAs4CgD/IcvRN08LpabdwMjp023p0FAW50cy2rJms1C3SVjXGUQduq7dZ6jj/nJSQB4YkDT9TNdWUFXcHrZbtpc+mSqQfYwE3iqpRH+zKE=
Date: Sat, 15 Mar 2008 19:11:39 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Helge Hafting <helgehaf@mail.aitel.hist.no>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, jens.axboe@oracle.com, mingo@elte.hu
Subject: Re: Swap makes X unfair (was Re: Keys get stuck)
Message-ID: <20080315221139.GA4163@localhost.ift.unesp.br>
Mail-Followup-To: Helge Hafting <helgehaf@mail.aitel.hist.no>,
	Helge Hafting <helge.hafting@aitel.hist.no>,
	Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
	arjan@linux.intel.com, jens.axboe@oracle.com, mingo@elte.hu
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <200803122222.05663.hpj@urpla.net> <1205386933.4797.22.camel@marge.simson.net> <200803131148.22056.jk-lkml@sci.fi> <1205407693.6686.16.camel@marge.simson.net> <20080313120238.GA3860@localhost.ift.unesp.br> <47D937A2.9070305@aitel.hist.no> <20080313151354.GA5252@localhost.ift.unesp.br> <47DA5B36.9060209@mail.aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DA5B36.9060209@mail.aitel.hist.no>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14.Mar'08 at 12:02:14 +0100, Helge Hafting wrote:
> Carlos R. Mafra wrote:
>> On Thu 13.Mar'08 at 15:18:10 +0100, Helge Hafting wrote:
>>   
>>> Carlos R. Mafra wrote:
>>>     
>>>> On Thu 13.Mar'08 at 12:28:13 +0100, Mike Galbraith wrote:
>>>>         
>>>>> [...]
>>>>> Swap can definitely keep X off the cpu for extended periods,
>>>>> [...]
>>>>>             
>>>> So I would like to ask if swap letting X (and everything else
>>>> in my experience) out of the cpu for extended periods is
>>>> considered normal behaviour, in the sense that nobody is
>>>> trying to "fix" it (due to it being considered impossible
>>>> to fix)...?
>>>>         
>>> Yes, this is perfectly normal. A heavily swapping machine
>>> will swap out parts of X.
>>>     
>>
>> Right, but making the mistake of not being very precise
>> I would not say my desktop was "heavily swapping". 
>>   
>>> Now, if X has a need for low-latency for keyboard handling,
>>> then the X developers can use mlock to lock
>>> the X keyboard service in memory, and make it a real-time
>>> (or at least high priority) process too.  This should
>>> avoid the problem even with extreme swapping and/or
>>> high cpu load.
>>>     
>>
>> That would be a great thing for me. But why one wouldn't
>> want this behaviour to be default for a desktop? I mean
>> it should be like that already for a desktop experience.
>>   
> Normally, memory that is used all the time does not get
> swapped out. If you use X while the machine is swapping,
> you will normally see lots of little delays, not
> one longe freeze.  So this may have been something else.
>
> This scenario seems to require only moderate swap. There
> may be another explanation, that require more X knowledge
> than I have:
>
> Some windowing systems give apps the opportunity of
> blocking the entire windowing system while doing stuff.
> This is usually only used for "system modal dialogs" and
> for very quick operations that need to stop all other user interaction.
>
> I don't know to what extent this is possible in X, but if
> it is, then the door is open for badly written apps to
> to stupid things like load a 380M file while the user interface
> is blocked. A well-designed app should do such lengthy jobs
> without blocking everything else, so the user can do other stuff
> while the machine works.  Note that any io-operation _might_ be
> lengthy - even a 50-byte file could reside on a network file
> system on a server located in a different continent.
>
> You may want to write to xjed developers, perhaps they
> can do something about this. Like loading the
> file in the background, perhaps.
> [...]

As I noted in another thread (unfortunately ignored so far),
sometimes xjed opens the file and my desktop is ok, as 
responsive as I expect it to be. 

So this isn't a xjed bug, even tough it could be better
and load parts of the file on demand (like vi appears
to do).


> The interesting question is whether this is a swapping problem that can be 
> solved by kernel fixing, or if it merely is a problem with the design of the X 
> server.
> In the latter case you need to contact x.org developers instead. xjed 
> developers  can probably work around the problem too, although that 
> would to be unnecessary
> if both the kernel and the x server were ideal.
>
> A test you can do:
> * Start up X as usual and log in
> * Switch to the console (ctrl+alt+F2)
> * Log in on the console, with the same user as you have in the X session.
> * Give the command "export DISPLAY=:0"  (without the quotes)
> *  Start xjed with the big file, from the console. You won't see it there,
>   it will show itself in the X session instead. Make sure you start it in 
> the
>   background, i.e.:   "xjed bigfile & "
>
> The machine should now start using the disk, loading the big file and swap 
> as usual.
> Now try doing stuff in the console shell. Try various commands like
> ls, view some text files in "vim", things like that.
>
> Now, if your console session is just as blocked and sluggish as the X 
> session usually
> gets - then it is a kernel/swapping problem.

So it is a kernel problem!

I did this test a few times today, using today's git kernel and 
it takes 3 seconds for 'ls' to appear in the screen after typing,
and 10 seconds (I checked with the clock) to be executed.

Today I think I've found a reliable way to reproduce this
bad behaviour (I've got it 5 times from 5 attempts so far).
It is independent of elevator={anticipatory, cfq, deadline},
I could get the bad results with all of them.

I just boot the machine, mount the swap partition manually (it
looks like a Mandriva Cooker bug) and start 'xjed bigfile.txt &'
in the terminal (it also happens outside of X).

It takes more than 15 minutes to load the 380MB file when I hit
the problem. It takes like 10 minutes to finish Ingo's cfs-debug
script (I can see it stop _after_ the file is loaded).

I could verify that swap usage goes to 400 MB out of 2 GB, and when
I start the test this is what I have:

             total       used       free     shared    buffers     cached
Mem:        515496     148628     366868          0       9916      80612
-/+ buffers/cache:      58100     457396
Swap:      2144636          0    2144636

In one of the tests I started 'vmstat 1 >> vmstat_log3.txt' a few seconds
before starting xjed. And this is what I got (notice that it has 400 lines,
showing that it took 400 seconds to load the file, but in fact it was
even more. Time seems to be distorted during this test)

www.ift.unesp.br/users/crmafra/vmstat_log3.txt

I could also get some info from latencytop during the test, but
it was very difficult because the terminal screen took ages to
refresh. This is worst log I could get manually:

Cause                                                Maximum     Percentage
get_request_wait __make_request generic_make_reque2201.3 msec          8.4 %
get_request_wait __make_request generic_make_reque1877.3 msec         20.5 %
sync_page __lock_page handle_mm_fault do_page_faul945.5 msec          0.4 %
sync_page __lock_page find_lock_page filemap_fault860.3 msec         17.2 %
sync_page __lock_page handle_mm_fault do_page_faul828.3 msec          0.9 %
sync_page __lock_page handle_mm_fault do_page_faul817.9 msec         21.7 %
sync_buffer __wait_on_buffer __bread ext3_get_bran752.6 msec          2.8 %
get_request_wait __make_request generic_make_reque726.6 msec          0.4 %
sync_page __lock_page find_lock_page filemap_fault617.0 msec          0.3 %
inary search_binary_handler do_execve


Process dhclient-script (3934)
get_request_wait __make_request generic_make_reque1562.5 msec         36.8 %ge shrink_page_list shrink_inactive_list shri
sync_page __lock_page find_lock_page filemap_fault473.4 msec         28.2 %lt do_page_fault error_code
sync_page __lock_page handle_mm_fault do_page_faul405.9 msec         13.3 %
Scheduler: waiting for cpu                        120.1 msec         19.0 %
congestion_wait try_to_free_pages __alloc_pages __ 99.7 msec          2.5 %o_page_cache_readahead filemap_fault __do_faul
congestion_wait __alloc_pages __do_page_cache_read 15.9 msec          0.2 %head filemap_fault __do_fault handle_mm_fault
do_page_fault error_code


So I think I am definitely hitting some kernel bug.

If someone in this list becomes interested in this problem, I will
be happy to help with any testing necessary.

I can live with this problem (I don't even need to read that 
file anymore). But the bug exists.

Another thing I want to mention is about the CFS debug script 
results. For example:

[mafra@localhost:~]$ grep se.wait_max cfs-debug-info-2008.03.15-17.22.51
se.wait_max                        :           320.220900
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :           308.730029
se.wait_max                        :             0.000000
se.wait_max                        :           216.652542
se.wait_max                        :           412.076086
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :           100.015586
se.wait_max                        :             0.000000
se.wait_max                        :           149.990226
se.wait_max                        :            15.718068
se.wait_max                        :            49.988316
se.wait_max                        :             0.000000
se.wait_max                        :            29.287277
se.wait_max                        :            62.785571
se.wait_max                        :           602.883709
se.wait_max                        :            10.646829
se.wait_max                        :             0.008188
se.wait_max                        :            19.871847
se.wait_max                        :            19.740026
se.wait_max                        :             0.027021
se.wait_max                        :            19.817248
se.wait_max                        :             0.026897
se.wait_max                        :             0.640153
se.wait_max                        :             0.808060
se.wait_max                        :             0.389118
se.wait_max                        :             0.027009
se.wait_max                        :             0.083961
se.wait_max                        :             3.264754
se.wait_max                        :             0.564208
se.wait_max                        :             0.092138
se.wait_max                        :             0.991528
se.wait_max                        :             3.058615
se.wait_max                        :             0.026908
se.wait_max                        :            11.891953
se.wait_max                        :            10.954652
se.wait_max                        :             1.115334
se.wait_max                        :             1.226744
se.wait_max                        :            10.947289
se.wait_max                        :            11.980765
se.wait_max                        :             1.349930
se.wait_max                        :            12.950094
se.wait_max                        :             1.438758
se.wait_max                        :            12.995926
se.wait_max                        :             1.523568
se.wait_max                        :            13.067781
se.wait_max                        :            15.039010
se.wait_max                        :             1.646566
se.wait_max                        :            15.134557
se.wait_max                        :             1.757942
se.wait_max                        :             1.830261
se.wait_max                        :            15.265369
se.wait_max                        :             1.921997
se.wait_max                        :            15.192441
se.wait_max                        :             2.097341
se.wait_max                        :             0.243086
se.wait_max                        :             2.028549
se.wait_max                        :             2.169289
se.wait_max                        :             2.280411
se.wait_max                        :             2.356268
se.wait_max                        :             1.719666
se.wait_max                        :             2.451732
se.wait_max                        :             2.535262
se.wait_max                        :             1.846795
se.wait_max                        :             2.489097
se.wait_max                        :             2.550678
se.wait_max                        :             2.816960
se.wait_max                        :             2.728959
se.wait_max                        :             2.068324
se.wait_max                        :             2.912895
se.wait_max                        :             3.072540
se.wait_max                        :             0.952594
se.wait_max                        :             3.334903
se.wait_max                        :             3.160131
se.wait_max                        :             3.399756
se.wait_max                        :            11.581309
se.wait_max                        :             3.684554
se.wait_max                        :           278.279914
se.wait_max                        :            23.601522
se.wait_max                        :            98.543577
se.wait_max                        :           259.453483
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :           127.155292
se.wait_max                        :             0.000000
se.wait_max                        :           494.934718
se.wait_max                        :             0.000000
se.wait_max                        :            20.022997
se.wait_max                        :            40.072908
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :            27.785589
se.wait_max                        :            45.076186
se.wait_max                        :            33.335700
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :           121.580585
se.wait_max                        :             6.825214
se.wait_max                        :            18.178228
se.wait_max                        :             0.000000
se.wait_max                        :           364.938378
se.wait_max                        :           186.608743
se.wait_max                        :             0.000000
se.wait_max                        :           191.874571
se.wait_max                        :            12.138841
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :           365.831692
se.wait_max                        :           196.069929
se.wait_max                        :           186.608743
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :           235.761630
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :            78.088419
se.wait_max                        :            33.871607
se.wait_max                        :             0.000000
se.wait_max                        :            26.201039
se.wait_max                        :           476.629993
se.wait_max                        :           587.639944
se.wait_max                        :           184.918777
se.wait_max                        :           334.997228
se.wait_max                        :           216.701937
se.wait_max                        :             0.909482
se.wait_max                        :           134.804841
se.wait_max                        :           114.442959
se.wait_max                        :           100.189898
se.wait_max                        :           100.155489
se.wait_max                        :           134.945855
se.wait_max                        :           114.634475
se.wait_max                        :             0.000000
se.wait_max                        :           542.107819
se.wait_max                        :            40.222426
se.wait_max                        :             0.000000
se.wait_max                        :            16.558527
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :            99.997595
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :            56.632829
se.wait_max                        :             0.000000
se.wait_max                        :             0.000000
se.wait_max                        :            80.577203


This is the worst register I have, it was obtained after
clearing the CFS stats. But most of the logs I have
from this script are fine (only a few se.wait_max over
40 msecs, with the worst being around 120 or so).



