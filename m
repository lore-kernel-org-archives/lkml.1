Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbXHER76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbXHER76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXHER7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:59:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43924 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbXHER7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:59:49 -0400
Message-ID: <46B60FFC.2000909@garzik.org>
Date: Sun, 05 Aug 2007 13:59:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Claudio Martins <ctpm@ist.utl.pt>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl> <46B4E161.9080100@garzik.org> <20070804224706.617500a0@the-village.bc.nu> <200708050051.40758.ctpm@ist.utl.pt> <20070805014926.400d0608@the-village.bc.nu> <20070805144645.GA28263@thunk.org> <20070805175547.GC3244@elte.hu>
In-Reply-To: <20070805175547.GC3244@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Theodore Tso <tytso@mit.edu> wrote:
> 
>> If you are always reading from the same small set of files (i.e., a 
>> database workload), then those inodes only get updated every 5 seconds 
>> (the traditional/default metadata update sync time, as well as the 
>> default ext3 journal update time), it's no big deal.  Or if you are 
>> running a mail server, most of the time the mail queue files are 
>> getting updated anyway as you process them, and usually the mail is 
>> delivered before 5 seconds is up anyway.
>>
>> So earlier, when Ingo characterized it as, "whenever you read from a 
>> file, even one in memory cache.... do a write!", it's probably a bit 
>> unfair.  Traditional Unix systems simply had very different workload 
>> characteristics than many modern dekstop systems today.
> 
> yeah, i didnt mean to say that it is _always_ a big issue, but "only a 
> small number of files are read" is a very, very small minority of even 
> the database server world.

OTOH, consider a popular Linux task, web serving.  atime results in a 
lot of unnecessary disk traffic.

	Jeff



