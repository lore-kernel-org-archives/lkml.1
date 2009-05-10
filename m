Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZEJMkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZEJMkP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 08:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZEJMj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 08:39:59 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:38596 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbZEJMj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 08:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rLdmMRtZsSXkKx61EtS3cXnGAumumfHYSaBOce940Lixh8Gu20H/gorV5Imq1Dx4bX
         TNpvju1Y9yJRpZHQ+k6XWB5icjkrfqIoBv+Ecg+WNfP063N62IIrPKUiQgir3jzgxgix
         x+8oYg47lbL+ev6IKIOlCqz6ZKhY5a622nsl4=
MIME-Version: 1.0
In-Reply-To: <1241957948.9562.2.camel@laptop>
References: <20090508081608.GA25117@localhost>
	 <2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>
	 <20090510092053.GA7651@localhost>
	 <2f11576a0905100229m2c5e6a67md555191dc8c374ae@mail.gmail.com>
	 <20090510100335.GC7651@localhost>
	 <2f11576a0905100315j2c810e96mc29b84647dc565c2@mail.gmail.com>
	 <20090510112149.GA8633@localhost>
	 <2f11576a0905100439u38c8bccak355ec23953950d6@mail.gmail.com>
	 <20090510114454.GA8891@localhost> <1241957948.9562.2.camel@laptop>
Date: Sun, 10 May 2009 21:39:58 +0900
X-Google-Sender-Auth: 86c00fecb75a3977
Message-ID: <2f11576a0905100539l1512170oc64f7aee2864e8d5@mail.gmail.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class 
	citizen
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
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

>> > They always use mmap(PROT_READ | PROT_WRITE | PROT_EXEC) for anycase.
>> > Please google it. you can find various example.
>>
>> How widely is PROT_EXEC abused? Would you share some of your google results?
>
> That's a security bug right there and should be fixed regardless of our
> heuristics.

Yes, should be. but it's not security issue. it doesn't make any security hole.
Plus, this claim doesn't help to solve end-user problems.

I think the basic concept of the patch is right.
  - executable mapping is important for good latency
  - executable file is relatively small

The last problem is, The patch assume executable mappings is rare, but
it isn't guranteed.
How do we separate truth executable mapping and mis-used PROT_EXEC usage?
