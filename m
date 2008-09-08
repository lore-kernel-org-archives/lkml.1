Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbYIHBJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbYIHBJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 21:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYIHBJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 21:09:36 -0400
Received: from mail.tmr.com ([64.65.253.246]:53154 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYIHBJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:09:35 -0400
Message-ID: <48C47B49.9050804@tmr.com>
Date: Sun, 07 Sep 2008 21:09:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 Fedora/1.1.11-1.fc9 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Phil Endecott <phil_wueww_endecott@chezphil.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nice and hyperthreading on atom
References: <1220715811849@dmwebmail.dmwebmail.chezphil.org> <1220795888167@dmwebmail.dmwebmail.chezphil.org>
In-Reply-To: <1220795888167@dmwebmail.dmwebmail.chezphil.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phil Endecott wrote:
> Phil Endecott wrote:
>> Dear Experts,
>>
>> I have an ASUS Eee with an Atom processor, which has hyperthreading 
>> enabled.  If I have two processes, one nice and the other normal, they 
>> each get 50% of the CPU time.  Of course this is what you'd expect if 
>> the scheduler didn't understand that the two virtual processors are 
>> not really independent.  I'd like to fix it.
> 
> I thought I'd try to quantify the effect with real processes.  My 
> "foreground" task is a compilation and my "background" task is a tight 
> loop at nice -9.  No doubt you would get different results with 
> different tasks (amount of I/O, cache hit rate, different nice level etc.).
> 
> With no background task running, the foreground task takes 86s whether 
> or not HT is enabled.  With the background task running, the foreground 
> task takes 97s with HT off and 104s with HT on.  104s is better than I 
> was expecting; in fact it's close enough to 97s that the problem can be 
> overlooked in this case.
> 
> I made a number of other measurements, of which the most significant is 
> that the run time with no background task comes down to 63s with -j2 
> when HT is on.  So for this compilation, hyperthreading makes the CPU 
> perform like 1.36 uniprocessors (in some sense).  I'll have to try to 
> remember how to make -j2 the default...

Phil, I got about the same improvement when CFS was being evaluated from 
patches, so I think you can trust your result, HT really does help in 
the 1.30..1.35 range depending on the application. It also seems to help 
when processes or threads are running data through a pipe, and my check 
at the time showed that this also showed a decrease in context switches.
> 
> Anyway, can I take it that the previous patches to improve this 
> behaviour have never been merged?
> 
Just to provide a confirmation of the magnitude of the benefit, no real 
new information, although you might have a real piped operation to 
track, noting the real time, CPU time, and ctx rate.

I believe that there were reports on this list of unithreaded processes 
running faster with HT on, and some of lower core temp with HT on. The 
lower core temp was at my limit of measurement, so I can only say "I 
think so," 1-3 C is too small to really trust as a power saver test.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
