Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYJHJSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYJHJSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 05:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYJHJSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 05:18:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:33468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbYJHJSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 05:18:21 -0400
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
	arch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       Nick Piggin <nickpiggin@yahoo.com.au>, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
In-Reply-To: <48EC7003.4040108@cosmosbay.com>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2>
	 <20081007105056.16d9e785.akpm@linux-foundation.org>
	 <1223405963.26330.83.camel@lappy.programming.kicks-ass.net>
	 <200810081335.44576.nickpiggin@yahoo.com.au>
	 <6.0.0.20.2.20081008132532.056cc400@172.19.0.2>
	 <1223448711.1378.16.camel@lappy.programming.kicks-ass.net>
	 <48EC7003.4040108@cosmosbay.com>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 11:17:22 +0200
Message-Id: <1223457442.1378.42.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 10:32 +0200, Eric Dumazet wrote:

> About dup() syscall, it wont help, since old and new descriptor points to
> the same "struct file", definitly sharing file position, since first Unixes.
> 
> To quote the fine manual :
> 
>        After successful return of dup or dup2, the old and new descriptors may
>        be used interchangeably. They share locks, file position  pointers  and
>        flags;  for example, if the file position is modified by using lseek on
>        one of the descriptors, the position is also changed for the other.

Ah, ok. I'll try to remember for next time I write a multi-threaded user
app (which given the size of my kernel todo list won't be any time soon
I guess ;-)

> pread()/pwrite() are used my multi-threaded applications that want to share
> a single "struct file".

Yeah, pread/pwrite is good.

>  Or they must use some form of synchronization around
> regular read()/write()/lseek() calls.
> 
> There is no generic f_pos race, only buggy applications.

Agreed.


