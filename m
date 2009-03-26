Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbZCZAcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbZCZAcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZCZAcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:32:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54142 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbZCZAcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:32:41 -0400
Message-ID: <49CACC4A.2080600@redhat.com>
Date: Wed, 25 Mar 2009 20:28:58 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <49CA9AD2.1080402@redhat.com> <alpine.LFD.2.00.0903251600310.3032@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903251600310.3032@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 25 Mar 2009, Ric Wheeler wrote:
>   
>> One concern with doing this above the file system is that you are not in the
>> context of a transaction so you have no clean promises about what is on disk
>> and persistent when. Flushing the cache is primitive at best, but the way
>> barriers work today is designed to give the transactions some pretty critical
>> ordering semantics for journalling file systems at least.
>>
>> I don't see how you could use this approach to make a really robust, failure
>> proof storage system, but it might appear to work most of the time for most
>> people :-)
>>     
>
> You just do a write barrier after doing all the filesystem writing, and 
> you return with the guarantee that all the writes the filesystem did are 
> actually on disk.
>
>   
In this case, you have not gained anything  - same number of barrier 
operations/cache flushes and looser semantics for the transactions?
> No gray areas. No questions. No "might appear to work". 
>
> Sure, there might be other writes that got flushed _too_, but nobody 
> cares. If you have a crash later on, that's always true - you don't get 
> crashes at nice well-defined points.
>
> 			Linus
>   
This is pretty much how write barriers work today - you carry down other 
transactions (even for other partitions on the same disk) with you...

ric

