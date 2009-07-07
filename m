Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbZGGVCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbZGGVCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbZGGVCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:02:40 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:36681 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755453AbZGGVCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:02:40 -0400
Message-ID: <4A53B7DB.5050105@acm.org>
Date: Tue, 07 Jul 2009 15:02:19 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Changli Gao <xiaosuo@gmail.com>, Denys Vlasenko <vda.linux@googlemail.com>,
       Albert ARIBAUD <albert.aribaud@free.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
References: <20090703015554.GB5880@cr0.nay.redhat.com>	 <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>	 <4A4DDD54.9030206@free.fr>	 <200907070643.56394.vda.linux@googlemail.com> <412e6f7f0907070045o6a17fb10x557108ffde0da11@mail.gmail.com> <4A53B202.9080505@davidnewall.com>
In-Reply-To: <4A53B202.9080505@davidnewall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20090707/1MOHnx-0003F5-V5-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Changli Gao wrote:
>>  mkfifo(name);
>>  open(name, O_RDWR);
>>  unlink(name);
>>
>> Is it a trick?
> 
> This does beg the question, why is it necessary to "extend" pipe() in
> this way?

Well, to me it sounds like the goal of the proposal is for very high 
load, high performance socket servers so efficiency matters.

The above is more than 3 times as expensive as one pipe(). Each syscall 
is thousands of machine cycles in overhead. In addition to that all 
three are VFS operations which as I recall are even more expensive than 
other syscalls.

But perhaps mkfifo(NULL) should be the syscall chosen to extend since 
its parameters are much like open() already, and it seems to work in the 
above sequence to create a one-FD FIFO already.

Or instead of, or in addition to a NULL name argument, its mode argument 
could be used as a flags argument to specify an anonymous fifo creation 
with FD return.
-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
