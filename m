Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbZBIUEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbZBIUEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 15:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbZBIUEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 15:04:06 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:34065 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbZBIUEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 15:04:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i24jwMJNchmTmzB+giAar3b8hqGHuRnL/NK+t4rsOPeK/KQ5BWhtJp8tWJWbEs5ORd
         9omY6jy+KLK2Gr46F5d8T2ivV6u6awGssO+SdrPqzTfQh9uDmx6t/b6FtavIoY67yETU
         GwPp3D3p2NlcD5q4XJZNJ4WoZdqR2WPj11cgc=
MIME-Version: 1.0
In-Reply-To: <1234209174.5951.165.camel@laptop>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <1234209174.5951.165.camel@laptop>
Date: Mon, 9 Feb 2009 20:04:03 +0000
Message-ID: <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
Subject: Re: cgroup, RT reservation per core(s)?
From: Rolando Martins <rolando.martins@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the quick reply.

On Mon, Feb 9, 2009 at 7:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2009-02-09 at 19:30 +0000, Rolando Martins wrote:
>> Hi,
>> I would like to have in a quad-core, 2 cores totally (100%) dedicated
>> to RT tasks (SCHED_RR and SCHED_FIFO) and the other 2 cores with
>> normal behavior, better said,  allowing SCHED_OTHER & SCHED_FIFO &
>> SCHED_RR tasks but still with a RT reservation. Follows an example:
>>
>>
>> # Setup first domain (cpu 0,1)
>> echo 0-1 > /dev/cgroup/0/cpuset.cpus
>> echo 0 > /dev/cgroup/0/cpuset.mems
>>
>> # Setup RT bandwidth for firstdomain (80% for RT, 20% others)
>> echo 1000000 > /dev/cgroup/0/cpu.rt_period_us
>> echo 800000 > /dev/cgroup/0/cpu.rt_runtime_us
>>
>>
>> # Setup second domain (cpu 2,3)
>> mkdir /dev/cgroup/1
>> echo 2-3 > /dev/cgroup/1/cpuset.cpus
>> echo 0 > /dev/cgroup/1/cpuset.mems
>>
>> # Setup RT bandwidth for second domain (100% for RT)
>> echo 1000000 > /dev/cgroup/1/cpu.rt_period_us
>> echo 1000000 > /dev/cgroup/1/cpu.rt_runtime_us
>>
>> Is there anyway for doing this?
>
> Nope, but why do you need bandwidth groups if all you want is a full
> cpu?
>
> Just the cpuset should be plenty
You have a point;)
>
>
I should have elaborated this more:

                     root
                  ----|----
                  |          |
(0.5 mem) 0         1 (100% rt, 0.5 mem)
                         ---------
                         |    |    |
                         2   3   4  (33% rt for each group, 33% mem
per group(0.165))
Rol
