Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbYLWTMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbYLWTMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 14:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLWTMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 14:12:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52460 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYLWTMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 14:12:23 -0500
Message-ID: <495137F4.9010404@vlnb.net>
Date: Tue, 23 Dec 2008 22:11:48 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC 2/23]: SCST core
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net>	 <20081210191213.GA15273@uranus.ravnborg.org>	 <49414DBE.6070801@vlnb.net>	 <20081211210917.GB27010@uranus.ravnborg.org>	 <4942BA85.3070408@vlnb.net>	 <1229118607.24995.18.camel@localhost.localdomain>	 <4943CAAB.4050008@vlnb.net>	 <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>	 <494A37E9.5000009@vlnb.net> <c62985530812200506u647fc135wcc818bc57d06cb04@mail.gmail.com>
In-Reply-To: <c62985530812200506u647fc135wcc818bc57d06cb04@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18RMj/ZXVvvqKFnIb6SN4lmT5tY0xcN2ur+Vs+
 UuaDN0PHX/NkJaDKnUbjTBNoZslDCUtDvdlEdIgoWM/zJJ3vC6
 8Er5RFs15aD9SyqIxTuig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frédéric,

Frédéric Weisbecker, on 12/20/2008 04:06 PM wrote:
> Hi Vladislav,
> 
> 2008/12/18 Vladislav Bolkhovitin <vst@vlnb.net>:
>> Frédéric Weisbecker, on 12/14/2008 03:35 AM wrote:
>>> 2008/12/13 Vladislav Bolkhovitin <vst@vlnb.net>:
>>>> Also (maybe I simply miss something) looks like ftrace doesn't trace exit
>>>> from functions, only entrance to them. Is it true? Is it possibly to log
>>>> exit from functions as well?
>>> That's true with 2.6.28, the function tracer traces on function entries
>>> only.
>>> But there is an add-on on ftrace which let one to trace on entry and
>>> on return, the function
>>> graph tracer. This tracer uses this facility to output a graph of
>>> function calls and measure
>>> the time elapsed during each function call.
>>> You can also register two custom handlers to do some things you need
>>> on entry and on return.
>> Word "graph" is quite confusing. We don't need any graphs, we need a plain
>> execution path tracing as in the attached example (this is what's currently
>> done).
> 
> The word graph is actually here to explain here that we not only trace
> each function call
> but we can actually retrieve all of the call path of a function and
> then draw it as if it was
> C code:
> 
>  0) ! 108.528 us  |            }
>  0)               |            irq_exit() {
>  0)               |              do_softirq() {
>  0)               |                __do_softirq() {
>  0)   0.895 us    |                  __local_bh_disable();
>  0)               |                  run_timer_softirq() {
>  0)   0.827 us    |                    hrtimer_run_pending();
>  0)   1.226 us    |                    _spin_lock_irq();
>  0)               |                    _spin_unlock_irq() {
>  0)   6.550 us    |                  }
>  0)   0.924 us    |                  _local_bh_enable();
>  0) + 12.129 us   |                }
>  0) + 13.911 us   |              }
>  0)   0.707 us    |              idle_cpu();
>  0) + 17.009 us   |            }
>  0) ! 137.419 us  |          }
>  0)   <========== |
>  0)   1.045 us    |          }
>  0) ! 148.908 us  |        }
>  0) ! 151.022 us  |      }
>  0) ! 153.022 us  |    }
>  0)   0.963 us    |    journal_mark_dirty();
>  0)   0.925 us    |    __brelse();

Unfortunately, it lacks very useful "TASK-PID, CPU#, TIMESTAMP" header 
fields..

