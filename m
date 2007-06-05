Return-Path: <linux-kernel-owner+w=401wt.eu-S932643AbXFEU6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643AbXFEU6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 16:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765485AbXFEU6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 16:58:10 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:36525 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765558AbXFEU6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 16:58:08 -0400
Message-ID: <4665CE28.5000801@cosmosbay.com>
Date: Tue, 05 Jun 2007 22:57:12 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
References: <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com> <20070603230859.5000424d.akpm@linux-foundation.org> <20070604080537.GA22898@elte.hu> <20070604080941.GA23537@elte.hu> <20070604013449.ea3acca8.akpm@linux-foundation.org> <20070604122857.1399e3fc.dada1@cosmosbay.com> <Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com> <20070604152540.985c186a.dada1@cosmosbay.com> <20070604141235.GA24352@elte.hu> <20070604162721.500211c9.dada1@cosmosbay.com> <20070605203720.GA5519@elte.hu>
In-Reply-To: <20070605203720.GA5519@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 05 Jun 2007 22:57:18 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>>> For example, the recent futex.c changes you did in commit 34f01cc1 
>>> are, and unfortunately there's no better word i can find: plain 
>>> disgusting. You apparently have plopped the 'fshared' code into the 
>>> existing logic via conditionals and have blown up the complexity of 
>>> the functions for no good reason - instead of neatly separating them 
>>> out. You have added _33_ (thirty-three!) new 'if' branches to 
>>> futex.c! The feature you introduced is nice and useful, but for 
>>> heaven's sake please work on cleanliness of your code some more and 
>>> undo that colossal damage ... preferably before working on other 
>>> areas of the kernel.
>> This code took the normal path for inclusion and discussion. If you 
>> find it so horrible, you should complained before. Fact is that you 
>> Acked it :)
> 
> yes, of course, i still think it's a good and nice patch, all things 
> considered =B-)
> 
>> If you wanted to make a joke, I find it quite misplaced.
> 
> no, i just wanted to make a demonstration that one can be pretty nasty 
> in on-lkml replies while being technically correct :-) I think you went 
> a bit overboard in your replies to Davide. Lets move this back into 
> constructive channels, ok? :)

No problem Ingo. I am sorry you and Davide took my remarks so badly.
I tried to be constructive.

You know this stuff got my interest, since I even tested your file 
open-many-fd benchmark :)

I have some machines around with 1.000.000 file descriptors opened by one 
process. I even had to change NR_OPEN (1024*1024 was too small for me :) )

