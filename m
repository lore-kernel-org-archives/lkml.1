Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbXLEQW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbXLEQW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXLEQWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:22:53 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:48385 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbXLEQWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:22:52 -0500
Message-ID: <4756D058.1070500@jlab.org>
Date: Wed, 05 Dec 2007 11:22:48 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Simon Holm Th??gersen <odie@cs.aau.dk>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Possible bug from kernel 2.6.22 and above, 2.6.24-rc4
References: <4744966C.900@jlab.org> <4744ADA9.7040905@cosmosbay.com> <4744E0DC.7050808@jlab.org> <1195698770.11808.4.camel@odie.local> <4744F042.4070002@jlab.org> <20071204131707.GA4232@elte.hu> <4756C3D9.9030107@jlab.org> <20071205154014.GA6491@elte.hu>
In-Reply-To: <20071205154014.GA6491@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jie Chen <chen@jlab.org> wrote:
> 
>> I just ran the same test on two 2.6.24-rc4 kernels: one with 
>> CONFIG_FAIR_GROUP_SCHED on and the other with CONFIG_FAIR_GROUP_SCHED 
>> off. The odd behavior I described in my previous e-mails were still 
>> there for both kernels. Let me know If I can be any more help. Thank 
>> you.
> 
> ok, i had a look at your data, and i think this is the result of the 
> scheduler balancing out to idle CPUs more agressively than before. Doing 
> that is almost always a good idea though - but indeed it can result in 
> "bad" numbers if all you do is to measure the ping-pong "performance" 
> between two threads. (with no real work done by any of them).
> 

My test code are not doing much work but measuring overhead of various 
synchronization mechanisms such as barrier and lock. I am trying to see 
the scalability of different implementations/algorithms on multi-core 
machines.

> the moment you saturate the system a bit more, the numbers should 
> improve even with such a ping-pong test.
> 
You are right. If I manually do load balance (bind unrelated processes 
on the other cores), my test code perform as well as it did in the 
kernel 2.6.21.
> do you have testcode (or a modification of your testcase sourcecode) 
> that simulates a real-life situation where 2.6.24-rc4 performs not as 
> well as you'd like it to see? (or if qmt.tar.gz already contains that 
> then please point me towards that portion of the test and how i should 
> run it - thanks!)

The qmt.tar.gz code contains a simple test program call pthread_sync 
under the src directory. You can change the number of threads by setting 
QMT_NUM_THREADS environment variable. You can build the qmt by doing 
configure --enable-public-release. I do not have Intel quad core 
machines, I am not sure whether the behavior will show up on Intel 
platform. Our cluster is dual quad-core opteron which has its own 
hardware problem :-).
http://hardware.slashdot.org/article.pl?sid=07/12/04/237248&from=rss

> 
> 	Ingo

Hi, Ingo:

My test code qmt can be found at ftp://ftp.jlab.org/pub/hpc/qmt.tar.gz. 
There is a minor performance issue in qmt pointed out by Eric, which I 
have not put into the tar ball yet. If I can be any help, please let me 
know. Thank you very much.



-- 
###############################################
Jie Chen
Scientific Computing Group
Thomas Jefferson National Accelerator Facility
12000, Jefferson Ave.
Newport News, VA 23606

(757)269-5046 (office) (757)269-6248 (fax)
chen@jlab.org
###############################################

