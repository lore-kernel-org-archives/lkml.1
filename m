Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0BTJbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:31:11 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:45542 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab0BTJbI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:31:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TPnv1n97RgEh9tH3msGocwfifdesEEw2poVrWTlo1pVQAkLe8r0oouUg80bWwsWNTQ
         Ah/tbsDX5bis1mbig6LZ5e67LD9hH6QD9EwaYROFj5V+BOOnLzVmVOWhIEV+LgEMN3NR
         l7Cd7lOGNMpKofmyaThfkxT0fo69XM6auxQCQ=
MIME-Version: 1.0
In-Reply-To: <1266485775.6539.6.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
Date: Sat, 20 Feb 2010 17:30:55 +0800
Message-ID: <2375c9f91002200130v1af400a3qe6045b484a25299@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 5:36 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-01-29 at 15:41 +1100, Benjamin Herrenschmidt wrote:
>> Hi Ingo !
>>
>> Johannes and I see this on our quad G5s... it -could- be similar to
>> one reported a short while ago by Xiaotian Feng <xtfeng@gmail.com>
>> under the subject [2.6.33-rc4] sysfs lockdep warnings on cpu hotplug.
>>
>> Basically, the machine deadlocks right after printing the following
>> when doing a shutdown:
>>
>> halt/4071 is trying to acquire lock:
>>  (s_active){++++.+}, at: [<c0000000001ef868>]
>> .sysfs_addrm_finish+0x58/0xc0
>>
>> but task is already holding lock:
>>  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<c0000000004cd6ac>]
>> .lock_policy_rwsem_write+0x84/0xf4
>>
>> which lock already depends on the new lock.
>>
>> the existing dependency chain (in reverse order) is:
>
> This is still happening with -rc8. Any news?
>

Hey, johannes

Not sure if you made some mistake here, the one you report here [1]
is _not_ the same with this one reported by Benjamin.

Please make sure what you are talking about here is the same one.

Thanks.

1. http://lkml.org/lkml/2010/2/18/33
