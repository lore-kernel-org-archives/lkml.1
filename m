Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbZEJLpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbZEJLpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 07:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZEJLpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 07:45:24 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:47508 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZEJLpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 07:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gcWmIhP3CjEO81sp2pyA0aIH4tbytL7o/bHiPsObck43VoiS2dJ5SGfwRD+byGRuGl
         mIfFUFsAU/UWwpBdI6H/E8nQZuaOD6pyCCwItRhI49T0pfPgvlxq59BSAMvEpiE8IIXp
         YDBjt35E5+68fjb2IDYf2mltJARbagCXlG0rc=
MIME-Version: 1.0
In-Reply-To: <20090510112149.GA8633@localhost>
References: <20090507151039.GA2413@cmpxchg.org>
	 <20090508081608.GA25117@localhost>
	 <20090508125859.210a2a25.akpm@linux-foundation.org>
	 <20090508230045.5346bd32@lxorguk.ukuu.org.uk>
	 <2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>
	 <20090510092053.GA7651@localhost>
	 <2f11576a0905100229m2c5e6a67md555191dc8c374ae@mail.gmail.com>
	 <20090510100335.GC7651@localhost>
	 <2f11576a0905100315j2c810e96mc29b84647dc565c2@mail.gmail.com>
	 <20090510112149.GA8633@localhost>
Date: Sun, 10 May 2009 20:39:12 +0900
X-Google-Sender-Auth: c81013be17f414b4
Message-ID: <2f11576a0905100439u38c8bccak355ec23953950d6@mail.gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class 
	citizen
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > So if that's what they want, let them have it to their heart's content.
>> >
>> > You know it's normal for many users/apps to care only about the result.
>> > When they want something but cannot get it from the smarter version of
>> > PROT_EXEC heuristics, they will go on to devise more complicated tricks.
>> >
>> > In the end both sides loose.
>> >
>> > If the abused case is important enough, then let's introduce a feature
>> > to explicitly prioritize the pages. But let's leave the PROT_EXEC case
>> > simple.
>>
>> No.
>> explicit priotize mechanism don't solve problem anyway. application
>> developer don't know end-user environment.
>> they can't mark proper page priority.
>
> So it's simply wrong for an application to prioritize itself and is
> not fair gaming and hence should be blamed. I doubt any application
> aimed for a wide audience will do this insane hack.

There already are.
some application don't interest strict PROT_ setting.

They always use mmap(PROT_READ | PROT_WRITE | PROT_EXEC) for anycase.
Please google it. you can find various example.


> But specific
> targeted applications are more likely to do all tricks which fits
> their needs&environment, and likely they are doing so for good reasons
> and are aware of the consequences.
