Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbZFLMNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbZFLMNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZFLMNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:13:25 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:20854 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZFLMNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZocjVZ9qDgz09BQo2f+9BZVq1DXnAR/nMz5839vPaw9H2ko+qAbtkBg9S8Vy17h6Gj
         auEXiYm0wAfvl+NXkWBEnwMzAWhQmJGs8rzWb2QTsDv9te4+YVLpEnv1PAeSgmJbkED3
         RuECmcVRfvAmm+iaVs3ZConzaASoL5xd0iAe4=
MIME-Version: 1.0
In-Reply-To: <20090612120507.GH16044@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> 
	<20090612120507.GH16044@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 08:13:06 -0400
Message-ID: <8bd0f97a0906120513u4e823460t8192f00fd0460ab@mail.gmail.com>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open 
	when supported
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 08:05, Ingo Molnar wrote:
> * Mike Frysinger <vapier@gentoo.org> wrote:
>> If the port does not support HAVE_PERF_COUNTERS, then they can't
>> support the perf_counter_open syscall either.  Rather than forcing
>> everyone to add an ignore (or suffer the warning until they get
>> around to implementing support), only whine about the syscall when
>> applicable.
>
> No, this patch is wrong - it's really easy to add support: just hook
> up the syscall. This should happen for every architecture really, so
> the warning is correct and it should not be patched out.
>
> PMU support is not required to get perfcounters support: if an
> architecture hooks up the syscall it will get generic software
> counters and the tools will work as well.
>
> Profiling falls back to a hrtimer-based sampling method - this is a
> much better fallback than oprofile's fall-back to the timer tick.
> This hrtimer based sampling is dynticks/nohz-correct and can go
> beyond HZ if the architecture supports hrtimers.

if there is generic support available, why must every arch select
HAVE_PERF_COUNTERS in their Kconfig ?
-mike
