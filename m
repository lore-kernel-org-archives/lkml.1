Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYHGQRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYHGQRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYHGQRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:17:31 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50033 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYHGQRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:17:31 -0400
Message-ID: <1923.69.2.248.210.1218124570.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <489B1BDC.1010504@s5r6.in-berlin.de>
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>
    <489B199B.40305@s5r6.in-berlin.de>
    <489B1BDC.1010504@s5r6.in-berlin.de>
Date: Thu, 7 Aug 2008 09:56:10 -0600 (MDT)
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
From: jmerkey@wolfmountaingroup.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Stefan Richter wrote:
>> jmerkey@wolfmountaingroup.com wrote:
>>> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc2-ia32-08-07-08.patch
> ...
>>> +typedef struct _RLOCK
>>> +{
>>> +#if defined(CONFIG_SMP)
>>> +    spinlock_t lock;
>>> +#endif
>>> +    unsigned long flags;
>>> +    unsigned long processor;
>>> +    unsigned long count;
>>> +} rlock_t;
> ...
>> The accessors rspin_lock() and rspin_try_lock() peek into spinlock_t and
>> may therefore not be fully portable.  Also, they and rspin_unlock()
>> don't look SMP safe:
> ...
>>> +   if (rlock->lock.raw_lock.slock && rlock->processor == proc)
>
> Correction:  They _are_ not portable.  Look at the first hit in
> http://lxr.linux.no/linux+v2.6.26/+code=raw_spinlock_t .


OK.  One more to fix.  I have to be able to take nested page faults inside
the debugger in the event I am debugging a page fault handler or paging
event and someone's working set routine crashes.

rspin locks are for these types of cases -- so if I fault on the same
processor I took the lock on it just bumps a counter -- yes, it is atomic
and SMP safe to do it this way.  You are correct that its non-portable
but the file this is in is named mdb-IA32 and is not meant as portable to
anything other than intel anyway.

As for coding style and misuse of a raw lock structure, I agree with you
completely, and I will look for a better way to do this without exposing
this structure.

Jeff

> --
> Stefan Richter
> -=====-==--- =--- --===
> http://arcgraph.de/sr/
>


