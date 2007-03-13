Return-Path: <linux-kernel-owner+w=401wt.eu-S1030624AbXCMPk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624AbXCMPk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 11:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030665AbXCMPk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 11:40:28 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:15855 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030624AbXCMPk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 11:40:28 -0400
Message-ID: <45F6C611.7070400@sw.ru>
Date: Tue, 13 Mar 2007 18:41:05 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Herbert Poetzl <herbert@13thfloor.at>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@sw.ru>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC][PATCH 1/7] Resource counters
References: <45ED7DEC.7010403@sw.ru> <45ED7F69.60108@sw.ru> <45EE39A5.7010804@in.ibm.com> <45EE6769.9060701@sw.ru> <20070309163711.GA3647@MAIL.13thfloor.at> <m1fy8bwqps.fsf@ebiederm.dsl.xmission.com> <20070312011612.GD21861@MAIL.13thfloor.at> <m1bqixtsr1.fsf@ebiederm.dsl.xmission.com> <20070313152150.GK8755@MAIL.13thfloor.at>
In-Reply-To: <20070313152150.GK8755@MAIL.13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> PS: atomic_add_unless() didn't exist back then
>>> (at least I think so) but that might be an option
>>> too ...
>> I think as far as having this discussion if you can remove that race
>> people will be more willing to talk about what vserver does.
> 
> well, shouldn't be a big deal to brush that patch up
> (if somebody actually _is_ interested)
> 
>> That said anything that uses locks or atomic operations (finer grained
>> locks) because of the cache line ping pong is going to have scaling
>> issues on large boxes.
> 
> right, but atomic ops have much less impact on most
> architectures than locks :)

Right. But atomic_add_unless() is slower as it is
essentially a loop. See my previous letter in this sub-thread.

>> So in that sense anything short of per cpu variables sucks at scale.
>> That said I would much rather get a simple correct version without the
>> complexity of per cpu counters, before we optimize the counters that
>> much.
> 
> actually I thought about per cpu counters quite a lot, and
> we (Llinux-VServer) use them for accounting, but please
> tell me how you use per cpu structures for implementing 
> limits

Did you ever look at how get_empty_filp() works?
I agree, that this is not a "strict" limit, but it
limits the usage wit some "precision".

/* off-the-topic */ Herbert, you've lost Balbir again:
In this sub-thread some letters up Eric wrote a letter with
Balbir in Cc:. The next reply from you doesn't include him.
