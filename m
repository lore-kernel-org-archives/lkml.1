Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbZGaKtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbZGaKtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZGaKtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:49:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36809 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZGaKtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:49:06 -0400
Message-ID: <7f54310137837631f2526d4e335287fc.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907282125260.554@chino.kir.corp.google.com>
    <20090730180029.c4edcc09.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.2.00.0907300219580.13674@chino.kir.corp.google.com>
    <20090730190216.5aae685a.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.2.00.0907301157100.9652@chino.kir.corp.google.com>
    <20090731093305.50bcc58d.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.2.00.0907310231370.25447@chino.kir.corp.google.com>
Date: Fri, 31 Jul 2009 19:49:02 +0900 (JST)
Subject: Re: [patch -mm v2] mm: introduce oom_adj_child
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "David Rientjes" <rientjes@google.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Rik van Riel" <riel@redhat.com>, "Paul Menage" <menage@google.com>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Fri, 31 Jul 2009, KAMEZAWA Hiroyuki wrote:
>
>> > > Simply, reset_oom_adj_at_new_mm_context or some.
>> > >
>> >
>> > I think it's preferred to keep the name relatively short which is an
>> > unfortuante requirement in this case.  I also prefer to start the name
>> > with "oom_adj" so it appears alongside /proc/pid/oom_adj when listed
>> > alphabetically.
>> >
>> But misleading name is bad.
>>
>
> Can you help think of any names that start with oom_adj_* and are
> relatively short?  I'd happily ack it.
>
There have been traditional name "effective" as uid and euid.

 then,  per thread oom_adj as oom_adj
        per proc   oom_adj as effective_oom_adj

is an natural way as Unix, I think.



>> Why don't you think select_bad_process()-> oom_kill_task()
>> implementation is bad ?
>
> It livelocks if a thread is chosen and passed to oom_kill_task() while
> another per-thread oom_adj value is OOM_DISABLE for a thread sharing the
> same memory.
>
I say "why don't modify buggy selection logic?"

Why we have to scan all threads ?
As fs/proc/readdir does, you can scan only "process group leader".

per-thread scan itself is buggy because now we have per-process
effective-oom-adj.


>> IMHO, it's bad manner to fix an os-implementation problem by adding
>> _new_ user
>> interface which is hard to understand.
>>
>
> How else do you propose the oom killer use oom_adj values on a per-thread
> basis without considering other threads sharing the same memory?
As I wrote.
   per-process(signal struct) or per-thread oom_adj and add
   mm->effecitve_oom_adj

task scanning isn't necessary to do per-thread scan and you can scan
only process-group-leader. What's bad ?
If oom_score is problem, plz fix it to show effective_oom_score.

If you can wait until the end of August, plz wait. I'll do some.

Thanks,
-Kame

