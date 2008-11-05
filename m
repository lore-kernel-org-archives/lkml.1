Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYKEIFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYKEIFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 03:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYKEIFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 03:05:03 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:24395 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYKEIFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 03:05:01 -0500
Message-ID: <491153AA.3010105@msgid.tls.msk.ru>
Date: Wed, 05 Nov 2008 11:04:58 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on	re-insert
References: <490B2659.9010304@msgid.tls.msk.ru> <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com> <20081104195728.GC5862@ucw.cz> <ac3eb2510811041213l4a20fa12h3c5beb3c2d317574@mail.gmail.com> <20081104202011.GA7135@ucw.cz> <4910BD2B.1020808@msgid.tls.msk.ru> <20081104212811.GC8349@elf.ucw.cz>
In-Reply-To: <20081104212811.GC8349@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2008-11-05 00:22:51, Michael Tokarev wrote:
>> Pavel Machek wrote:
[]
>>> So can we simply claim 'media changed' on last close/unmount? Sure,
>>> sometimes media was not changed, but that only hurts performance, not
>>> correctness... ?

>> Well, that's what my tiny proggy, which I used here to work around the
>> problem, does.  It constantly opens/closes the /dev/sdFOO, every 0.5s
>> currently (I don't think I will be able to replace a media faster than
>> half a second :), in order to catch REMOVALs of media -- because when
>> the drive does not see the media anymore, it correctly reports that
>> the media has changed...


> Ok, so we you need to do is to put it into kernel and activate it
> via blacklist...?

I'm fine with my solution.. ;)  Especially once Kay suggested to
look at /proc/mounts for notifications.

Original problem was that I didn't understand what happens, and
blamed kernel for "breaking" the working device (it looks like
it never worked in the first place, it was just that we never hit
the bug before).  Once the problem become clear (thanks Kay!),
I wrote the proggy mentioned above - it's obviously a gross hack,
but it stops the corruption for me.

Generally the solution can be one of the 3:

a) leave it as it is now, since it had never been bought up
   before and hence does not affect many people.  And because
   even if it was, it becomes less and less of a problem with
   bad drives going away slowly...

b) to use a mechanism like blacklist in kernel to force
   invalidation on CLOSE automatically for such drives (not
   when it really necessary as my program detects - on REMOVAL).
   Less efficient than my  solution, but much easier to deal
   with in kernel.

c) I will use my variant for my problem.. while finding a
  replacement for the bad hardware.

So no, I'm not asking to put that proggy into the kernel.. ;)
For kernelspace solution that'd be a much simple way.  If at
all.

So to summary: if it is EASY (read: trivial) to do such blacklist
in kernel space, I'd do it right away, because potentially it
is still possible to see similar corruptions elsewhere.  If not,
just forget the case as "solved for the reporter" ;)

Thanks!

/mjt
