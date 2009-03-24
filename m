Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbZCXTol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbZCXTol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760589AbZCXTo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:44:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52094 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757101AbZCXTo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:44:26 -0400
Message-ID: <49C9372F.3070504@redhat.com>
Date: Tue, 24 Mar 2009 15:40:31 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 24 Mar 2009, Theodore Tso wrote:
>   
>> With ext2 after a system crash you need to run fsck.  With ext4, fsck
>> isn't an issue,
>>     
>
> Bah. A corrupt filesystem is a corrupt filesystem. Whether you have to 
> fsck it or not should be a secondary concern.
>
> I personally find silent corruption to be _worse_ than the non-silent one. 
> At least if there's some program that says "oops, your inode so-and-so 
> seems to be scrogged" that's better than just silently having bad data in 
> it.
>
> Of course, never having bad data _nor_ needing fsck is clearly optimal. 
> data=ordered gets pretty close (and data=journal is unacceptable for 
> performance reasons).
>
> But I really don't understand filesystem people who think that "fsck" is 
> the important part, regardless of whether the data is valid or not. That's 
> just stupid and _obviously_ bogus.
>
> 			Linus
>   
It is always interesting to try to explain to users that just because 
fsck ran cleanly does not mean anything that they care about is actually 
safely on disk. The speed that fsck can run at is important when you are 
trying to recover data from a really hosed file system, but that is 
thankfully relatively rare for most people.

Having been involved in many calls with customers after crashes, what 
they really want to know is pretty routine - do you have all of the data 
I wrote? can you prove that it is the same data that I wrote? if not, 
what data is missing and needs to be restored?

We can get help answer those questions with checksums or digital hashes 
to validate the actual user data of files (open question is when to 
compute it, where to store, would the SCSI T10 DIF/DIX stuff be 
sufficient), putting in place some background scrubbers to detect 
corruptions (which can happen even without an IO error), etc.

Being able to pin point what was impacted is actually enormously useful 
- for example, being able to map a bad sector back into some meaningful 
object like a user file, meta-data (translation, run fsck) or so on. 

Ric



