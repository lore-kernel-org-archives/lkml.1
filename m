Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZKBMf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZKBMf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZKBMfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:35:55 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:39475 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZKBMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:35:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ZzZ7QZ9L6PTLmibGF7Zih6hZdmVxYyIeqjNgg5zTIijo9FH33/AkH8xwKxG2MLVcJs
         1o2EzmzlJ6ygxJV6gyYadKgBcRVXPvrx/8uUE9COwjfgjHMhGL4k+iRhSnBtAidMsDMy
         Yku0p04OXST8dT5Tin+Sz+DTbqgmoHOYEbjUs=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0911020237440.13146@chino.kir.corp.google.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com>
	 <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com>
	 <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com>
	 <2f11576a0911010529t688ed152qbb72c87c85869c45@mail.gmail.com>
	 <alpine.DEB.2.00.0911020237440.13146@chino.kir.corp.google.com>
Date: Mon, 2 Nov 2009 21:35:35 +0900
X-Google-Sender-Auth: 6a0506c3b9dc5106
Message-ID: <2f11576a0911020435n103538d0p9d2afed4d39b4726@mail.gmail.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>, vedran.furac@gmail.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hi David,
>>
>> I'm very interesting your pointing out. thanks good testing.
>> So, I'd like to clarify your point a bit.
>>
>> following are badness list on my desktop environment (x86_64 6GB mem).
>> it show Xorg have pretty small badness score. Do you know why such
>> different happen?
>
> I don't know specifically what's different on your machine than Vedran's,
> my data is simply a collection of the /proc/sys/vm/oom_dump_tasks output
> from Vedran's oom log.
>
> I guess we could add a call to badness() for the oom_dump_tasks tasklist
> dump to get a clearer picture so we know the score for each thread group
> leader.  Anything else would be speculation at this point, though.
>
>> score    pid        comm
>> ==============================
>> 56382   3241    run-mozilla.sh
>> 23345   3289    run-mozilla.sh
>> 21461   3050    gnome-do
>> 20079   2867    gnome-session
>> 14016   3258    firefox
>> 9212    3306    firefox
>> 8468    3115    gnome-do
>> 6902    3325    emacs
>> 6783    3212    tomboy
>> 4865    2968    python
>> 4861    2948    nautilus
>> 4221    1       init
>> (snip about 100line)
>> 548     2590    Xorg
>>
>
> Are these scores with your rss patch or without?  If it's without the
> patch, this is understandable since Xorg didn't appear highly in Vedran's
> log either.

Oh, I'm sorry. I mesured with rss patch.
Then, I haven't understand what makes Xorg bad score.

Hmm...
Vedran,  Can you please post following command result?

# cat /proc/`pidof Xorg`/smaps


I hope to undestand the issue clearly before modify any code.
