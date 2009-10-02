Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZJBUaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZJBUaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757743AbZJBUaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:30:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757727AbZJBUaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:30:09 -0400
Message-ID: <4AC6623F.70600@ds.jp.nec.com>
Date: Fri, 02 Oct 2009 16:27:43 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Ryo Tsuruta <ryov@valinux.co.jp>, nauman@google.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, agk@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: IO scheduler based IO controller V10
References: <20090929141049.GA12141@redhat.com> <20090930.174319.183036386.ryov@valinux.co.jp> <20090930110500.GA26631@redhat.com> <20091001.154125.104044685.ryov@valinux.co.jp> <20091001133109.GA4058@redhat.com> <20091002025731.GA2738@redhat.com>
In-Reply-To: <20091002025731.GA2738@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote, on 10/01/2009 10:57 PM:
> Before finishing this mail, will throw a whacky idea in the ring. I was
> going through the request based dm-multipath paper. Will it make sense
> to implement request based dm-ioband? So basically we implement all the
> group scheduling in CFQ and let dm-ioband implement a request function
> to take the request and break it back into bios. This way we can keep
> all the group control at one place and also meet most of the requirements.
>
> So request based dm-ioband will have a request in hand once that request
> has passed group control and prio control. Because dm-ioband is a device
> mapper target, one can put it on higher level devices (practically taking
> CFQ at higher level device), and provide fairness there. One can also
> put it on those SSDs which don't use IO scheduler (this is kind of forcing
> them to use the IO scheduler.)
>
> I am sure that will be many issues but one big issue I could think of that
> CFQ thinks that there is one device beneath it and dipsatches requests
> from one queue (in case of idling) and that would kill parallelism at
> higher layer and throughput will suffer on many of the dm/md configurations.
>
> Thanks
> Vivek

As long as using CFQ, your idea is reasonable for me.  But how about for
other IO schedulers?  In my understanding, one of the keys to guarantee
group isolation in your patch is to have per-group IO scheduler internal
queue even with as, deadline, and noop scheduler.  I think this is
great idea, and to implement generic code for all IO schedulers was
concluded when we had so many IO scheduler specific proposals.
If we will still need per-group IO scheduler internal queues with
request-based dm-ioband, we have to modify elevator layer.  It seems
out of scope of dm.
I might miss something...



-- 
IKEDA, Munehiro
   NEC Corporation of America
     m-ikeda@ds.jp.nec.com

