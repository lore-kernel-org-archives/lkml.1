Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbZKSXN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbZKSXN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 18:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbZKSXN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 18:13:56 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39115 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352AbZKSXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 18:13:56 -0500
Message-ID: <4B05D124.6020808@us.ibm.com>
Date: Thu, 19 Nov 2009 15:13:40 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
References: <20091117074655.GA14023@google.com> <20091117081817.GA7963@elte.hu>	 <1258448121.7816.29.camel@laptop> <4B02CC46.4020506@us.ibm.com>	 <20091118221331.GA1300@google.com> <4B057A7C.80300@us.ibm.com> <8d20b11a0911191325u49624854u6132594f13b0718c@mail.gmail.com>
In-Reply-To: <8d20b11a0911191325u49624854u6132594f13b0718c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> 
> 
> On Thu, Nov 19, 2009 at 9:03 AM, Darren Hart <dvhltc@us.ibm.com 
> <mailto:dvhltc@us.ibm.com>> wrote:
> 
>     Michel Lespinasse wrote:
> 
>         On Tue, Nov 17, 2009 at 08:16:06AM -0800, Darren Hart wrote:
> 
>                 http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git
> 
>             Michael, would you be willing to include a version of this
>             test in the  above test suite? If so, then in keeping with
>             the rest of the test suite, I would recommend splitting into
>             two tests, one of each opcode being tested, and  add
>             argument to define thread count. The run.sh script would
>             then run each thread count as a separate test run.
> 
> 
>         There you go. Hope this helps. Feel free to adapt as needed.
> 
>         Signed-off-by: Michel Lespinasse <walken@google.com
>         <mailto:walken@google.com>>
> 
> 
>     My core-duo laptop hung after 256 threads. I left it running all
>     night and woke to it still sitting at:
> 
>     256 threads: 11792 Kiter/s (14.18s user 0.28s system 8.48s wall 1.71
>     cores)
> 
>     Have experienced a hang with this test on any platform? I'll take a
>     closer look at the source today to see if there is anything in there
>     that requires a certain number of CPUs to function properly.
> 
> 
> Which test were you running, futex_wait_test or futex_setwait_test ?

This is futex_wait_test

> 
> This is not supposed to require any particular number of CPUs, so I am 
> concerned about the hang.
> 
> How reproducible is this for you ? Do you know if the original test code 
> I sent hanged in the same way ?

I'm basically 2 for 2 on each version of the futex_wait_test. I haven't 
seen it run to completion yet. This is on a stock Ubuntu kernel 
(2.6.31-15-generic) on my core duo laptop (32 bit).

Futex locking constructs are tricky. I'll spend some time looking over 
the barriers and locks used in the test. I tried to do some simple 
instrumenting, but that masked the hang (not unexpectedly). I'll keep 
looking.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
