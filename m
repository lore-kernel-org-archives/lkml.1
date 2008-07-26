Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYGZH4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYGZH4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 03:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYGZH4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 03:56:17 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:42604 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYGZH4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 03:56:17 -0400
Message-ID: <488AD656.5060801@miraclelinux.com>
Date: Sat, 26 Jul 2008 16:46:30 +0900
From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ram Gupta <ram.gupta5@gmail.com>, Paul Menage <menage@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH][0/3] introduce rlimit cgroup
References: <488722DF.9080003@miraclelinux.com>	 <20080724150557.8697.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <48885A7F.80106@miraclelinux.com>	 <6599ad830807242305w2895905dgcd91fe3a430806dc@mail.gmail.com> <728201270807250633vcaf8ac2r3be1d37736283385@mail.gmail.com>
In-Reply-To: <728201270807250633vcaf8ac2r3be1d37736283385@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2008.7.26.73923
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for your comments.
I understand that.
I'll look for other approach for this.

thanks

> I understand that there might be some cases where it is useful to
> allow some process to set rlimits of other processes (e.g. some
> launcher process might want to control resources of all the
> applications being launched by it). But this has to be a very special
> case or this process needs to have special permission to do that
> otherwise there will be a lot of problems as a side effect.
> 
> Ram
> 
> On Fri, Jul 25, 2008 at 1:05 AM, Paul Menage <menage@google.com> wrote:
>>> To set rlimit from other processes is my original intention.
>>> For I do not see a way to do it, please let me know if there were any
>>> exists.
>> No, there's no way to do that currently. I'm not sure if it's
>> generally safe to update the rlimit for another process.
>>
>> If we're trying to use rlimits in a cgroup context then some rlimits
>> (e.g. max nice priority) ought to apply as additional caps on the
>> processes in the cgroup (e.g. if you set a max nice priority of 1 on a
>> cgroup, that ought to override any per-process settings) whereas
>> others (e.g. locked memory, open files, num processes) ought to apply
>> as an aggregate limit on the cgroup (so the sum of all open files
>> across the cgroup shouldn't be able to exceed the cgroup's "open
>> files" limit). E.g. see Balbir's memrlimit control groups patches that
>> are currently in -mm.
>>
>> What concrete problem are you trying to solve here?
>>
>> Paul
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 

