Return-Path: <linux-kernel-owner+w=401wt.eu-S1751052AbXDXOoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbXDXOoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXDXOoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:44:18 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:39219 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbXDXOoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:44:17 -0400
Message-ID: <462E17AF.7090604@namesys.com>
Date: Tue, 24 Apr 2007 18:43:59 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Andi Kleen <andi@firstfloor.org>
CC: Alex Zarochentsev <zam@namesys.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Eric Hopper <hopper@omnifarious.org>, Lex Lyamin <flx@msu.ru>,
       William Heimbigner <icxcnika@mar.tar.cc>,
       Rik van Riel <riel@redhat.com>, Xu CanHao <xucanhao@gmail.com>
Subject: Re: Question about Reiser4
References: <20070423111939.c876c9cc.akpm@linux-foundation.org>
In-Reply-To: <20070423111939.c876c9cc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone.

>Begin forwarded message:
>
>Date: 23 Apr 2007 21:05:13 +0200
>From: Andi Kleen <andi@firstfloor.org>
>To: Andrew Morton <akpm@linux-foundation.org>
>Cc: Eric Hopper <hopper@omnifarious.org>, linux-kernel@vger.kernel.org
>Subject: Re: Question about Reiser4
>
>
>Andrew Morton <akpm@linux-foundation.org> writes:
>  
>
>>To get it unstuck we'd need a general push, get people looking at and testing
>>the code, get the vendors to have a serious think about it, etc.  We could do
>>that - it'd require that the namesys people (and I) start making threatening
>>noises about merging it, I guess.
>>    
>>
>
>My impression was that a lot of negative discussion came out of some of the
>user interface inventions in r4 (like sys_reiser4 and the
>new incompatible EA interface). 
>
>  
>

sys_reiser4 and metas interface were removed (current -mm stuff
doesn't contain them).

>I guess a good strategy to get it going would be to extract just
>a "core reiser4" out of it that is just a file system without
>any new interfaces like this.
>
>  
>

I think that current reiser4 is exactly that "core", which responds solely
to VFS. The popular opinion that plugins make more sense in the VFS
is a great delusion, as plugins are entities related to reiser4 disk 
layouts.
There are many aspects where plugin architecture is useful, I tried to
describe one of them -- backward compatibility that was got with
minimal efforts: http://dev.namesys.com/Version4.X.Y
If this needs more comments, then we will proceed the documentation.

>I would expect that reviewing that would be much smoother
>because people could actually concentrate on the technical details.
>
>-Andi
>
>  
>

Other comments:

1. Why Namesys developers aren't presently asking for inclusion?

Because there are unaddressed items in this todo list:
http://pub.namesys.com/Reiser4/ToDo
The main issues here are xattrs and support for blocksize != pagesize.
I think that adding xattrs will take ~1 month of full-time working.
Not sure about blocksize support. Also, the statement about "main
issues" may be too optimistic. Let's try to estimate..

2. Who will maintain this?

Currently there are two namesys employees working mostly on
enthusiasm. Divide them into 2 file systems, plus many people who
really help with fixing problems.

So we need to estimate how dramatic the situation with reiser4 is
(experts are welcome). In the worst case (no funding for this in the
perspective) I hope to devote ~25% of my working time to this
project. Vladimir might want to add something here, but he is sick
for now. By the way, he has its own opinion what part of current
reiser4 should go to mainline (separating tail's support (which
makes things complicated) as special incremental update available
on our website).

Thanks,
Edward.

