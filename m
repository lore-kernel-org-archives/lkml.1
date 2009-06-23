Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZFWJlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZFWJlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZFWJky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:40:54 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34278 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZFWJkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=CVfUn4JXLQCEqbGh/ZFJcIBlWjaWCQHmZBXrYIzBwcwqEC6vJiYKE4GBLjuzd7hw+y
         DxtgRS+oGjK+rkGWB8jM8CF2xO68JEYJs5a/+qiBruPyBTGdph5x+vuQgYxmUhVYpCk6
         0N2imO50GmiYtGXdUyEKR2xjgm6JdKdIXIzqY=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1245748205.19816.1550.camel@twins>
References: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com>
	 <9F0C1DB20AFA954FA1DA05309350433D7B2584D1@pdsmsx503.ccr.corp.intel.com>
	 <7c86c4470906230045k578bc146wa0e09e4094d937a5@mail.gmail.com>
	 <20090623075959.GA23534@ywang-moblin2.bj.intel.com>
	 <7c86c4470906230127g4f574b61p24f109c7a94c6e39@mail.gmail.com>
	 <20090623083420.GB23534@ywang-moblin2.bj.intel.com>
	 <1245748205.19816.1550.camel@twins>
Date: Tue, 23 Jun 2009 11:40:55 +0200
Message-ID: <7c86c4470906230240g7d748708s7b7b8af141c53c0c@mail.gmail.com>
Subject: Re: perf_counter Atom patch
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Wang <yong.y.wang@linux.intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 11:10 AM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Tue, 2009-06-23 at 16:34 +0800, Yong Wang wrote:
>> > you could simply consider having 0 fixed counters and everything else would work
>> > as expected. But there is a catch, unfortunately, in that there is erratum AE49
>> > which says that there is only one enable bit to control the two generic counters
>> > on Core Duo/Solo.
>
> Ah, that's similar to P6 like machines. The P6 docs say that to disable
> a counter you should simply write all zeros (except the EN bit for ctr0)
> to the control register (IIRC).
>
> I suppose we could do something similar on these errata cores, make
> x86_pmu_disable_counter() write ARCH_PERFMON_EVENTSEL0_ENABLE instead.
>
> Would that work?
>
I suspect that to make this work correctly on P6 and Core Duo,  you
will have to enforce
only one event/group to maintain the independence you expose at the
user level. An
Alternative would be to ensure that:
   - group leader in always in counter0
   - sibling events are created with disabled=0
   - ioctl(ENABLE/DISABLE) on siblings always fail

Of course, this does not work, if the group leader event requires
counter1. But I have to check
if such restriction exists on Core Duo.
