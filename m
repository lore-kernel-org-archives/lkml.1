Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZKBPon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZKBPon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbZKBPon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:44:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38539 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZKBPom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:44:42 -0500
Message-ID: <7d6cb1fd385affaf02d3e1f4b648a3ce.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <28c262360911020704r45d7f4fmd347d270622fe2c5@mail.gmail.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
    <28c262360911020704r45d7f4fmd347d270622fe2c5@mail.gmail.com>
Date: Tue, 3 Nov 2009 00:44:44 +0900 (JST)
Subject: Re: [RFC][-mm][PATCH 0/6] oom-killer: total renewal
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Minchan Kim" <minchan.kim@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, rientjes@google.com,
       vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:
> Hi, Kame.
>
> I looked over the patch series.
> It's rather big change of OOM.
yes, bigger than I expected.

> I see you and David want to make OOM fresh from scratch.
> But, It makes for testers to test harder.
>
I see. Maybe I have to separate this to 2 or 3 stages.

> I like your idea of fork-bomb detector.
> Don't we use it without big change of as-is OOM heuristic?
>
yes, this is big change. And I'll cut out usable part ;)
Maybe I'll drop most of changes in patch 6's heuristics part.
(but selection of baseline for LOWMEM is not so bad.)

What I want in early stage is
  - fix for mempolicy. (we need to pass nodemask)
  - swap counting (regardless of oom)
  - low_rss counting (if admited...)
  - fork-bomb detector

Let me think how to make patch set small and easy to test.

> Anyway,I need time to dive the code and test it.
> Maybe weekend.
>
> Thanks for great effort. :)
>
Thank you for review.

Regards,
-Kame

> On Mon, Nov 2, 2009 at 4:22 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> Hi, as discussed in "Memory overcommit" threads, I started rewrite.
>>
>> This is just for showing "I started" (not just chating or sleeping ;)
>>
>> All implemtations are not fixed yet. So feel free to do any comments.
>> This set is for minimum change set, I think. Some more rich functions
>> can be implemented based on this.
>>
>> All patches are against "mm-of-the-moment snapshot 2009-11-01-10-01"
>>
>> Patches are organized as
>>
>> (1) pass oom-killer more information, classification and fix mempolicy
>> case.
>> (2) counting swap usage
>> (3) counting lowmem usage
>> (4) fork bomb detector/killer
>> (5) check expansion of total_vm
>> (6) rewrite __badness().
>>
>> passed small tests on x86-64 boxes.
>>
>> Thanks,
>> -Kame
>>
>>
>
>
>
> --
> Kind regards,
> Minchan Kim
>


