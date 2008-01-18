Return-Path: <linux-kernel-owner+w=401wt.eu-S1755821AbYARIwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbYARIwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYARIwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:52:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYARIwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:52:05 -0500
Date: Fri, 18 Jan 2008 09:51:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zan Lynx <zlynx@acm.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: echo mem > /sys/power/state
Message-ID: <20080118085139.GB19792@elte.hu>
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org> <1200591411.34145.4.camel@localhost> <20080117111355.29554f38.akpm@linux-foundation.org> <478FCD1F.4090704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478FCD1F.4090704@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> On 01/17/2008 08:13 PM, Andrew Morton wrote:
>> On Thu, 17 Jan 2008 10:36:51 -0700 Zan Lynx <zlynx@acm.org> wrote:
>>> Heh.  Laptop suspend to anything has been so broken for so long in the
>>> -mm series on my Compaq R3000 that I didn't even know it was ever
>>> supposed to work.
>>
>> It gets broken more often than anything else.  I do test each release on
>> two laptops and I get to do a lot of bisection searching and
>> grumpygramming as a result.
>>
>> Probably it would be more efficient to have the people who wrote the code
>> also test it.
>
> Big fat ACK from here. Suspend issues in past few -mms were *very* 
> hard (and time consuming) to track down.

it's really all a matter of reducing latencies. Testing suspend/resume 
is manual work currently (it either needs me hit a key on the laptop or 
necessiates the use of a test-script that might or might not work 
depending on whether the new /dev/rtc driver is enabled). So few people 
besides those that rely on it will do it. The more a patch that breaks 
suspend is out in the open unidentified, the more damage it does: it 
gets into more trees, gets harder to bisect, etc.

So please give us overworked maintainers an easy to use .config option 
dependent on CONFIG_DEBUG_KERNEL=y that automatically triggers a simple 
suspend+resume sequence 60 seconds after bootup. It would be godsent. 
(dont worry about proper gx resume) I compile and boot up every patch i 
add to x86.git, so this would catch crap the moment we add it to the 
tree.

The other, more long-term trick is to make rarely used functionality 
more widely used. Consolidate code. Try to merge as much of 
suspend/resume with bootup/module-insert/shutdown sequences as possible. 
Suspend unused devices more agressively - such as non-mounted block 
devices or downed networking ports. Try create more network effects with 
other functionality, suspend and resume is not just about suspending 
laptops, it can/could be used for so much more stuff. Try to get Pavel's 
"Sleepy Linux" concept to work reasonably well - so that more people 
(including developers) would use it in a daily basis.

Test coverage of a given piece of code is a direct function of its 
utility and of its ease of testing. Decreeing "this is important" really 
wont get more testing done. What you should realize i think is that this 
is not a social/mindset problem (so no need to get frustrated about it), 
this is a mostly technology problem: you can gradually _code_ your way 
into people's test efforts.

	Ingo
