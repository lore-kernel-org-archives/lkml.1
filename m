Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbZFLPaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbZFLPaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbZFLP3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:29:46 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:45786 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbZFLP3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BsLIC4ezp7F3/XpQhBu61TDJkbo+PS1PXdkx1IDh1/OnhMpXoSACqGpP2AK2ZAz+3b
         rCleHiUU2sxf2eqie1z4N4ENiTdMa7hLUkbgurZZcnfd/PL+GyHDXJnNpQ3PAZ767Nhv
         mprAVmMcTK3ZMfkxrH3jEAn0rPRmFflM71AYo=
MIME-Version: 1.0
In-Reply-To: <20090612152134.GA23483@elte.hu>
References: <1244806169-12232-1-git-send-email-vapier@gentoo.org> 
	<20090612120507.GH16044@elte.hu> <8bd0f97a0906120816w26d91530nf1e1967470beb99c@mail.gmail.com> 
	<20090612152134.GA23483@elte.hu>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 12 Jun 2009 11:29:27 -0400
Message-ID: <8bd0f97a0906120829p628751e9gb557f6a14e98fae2@mail.gmail.com>
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

On Fri, Jun 12, 2009 at 11:21, Ingo Molnar wrote:
> * Mike Frysinger <vapier.adi@gmail.com> wrote:
>> the perf counter code explicitly requires:
>> ...
>>  - support for atomic64 types (unless i missed something, x86 is the
>> only 32bit system that supports these)
>
> A wrapper suffices - should probably be librarized into lib/.

wonder if we can trick Arnd into doing that ...

>>  - some perf stubs (like set_perf_counter_pending() -- prototype
>> really should be in common perf_counters headers rather than forcing
>> the arch to copy & paste the exact same line)
>
> Agreed.

can i assume you'll take care of that ?

>> not that any of this is documented ...
>
> Patches are welcome :-)

i cant find anything in Documentation/ covering perf counters.  did i
miss some file ?

also, i was going just by a quick compile test.  dont know what else
is actually required since there's no chance of me trying to get this
to work on Blackfin anytime soon ...

> You are right that the requirements are not necessarily trivial for
> every arch - so i guess our original patch is correct.

there is also some ptrace type piece missing for the Blackfin arch,
but that looks like something that i should just implement as everyone
else is doing it.
-mike
