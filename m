Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbYGQXVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbYGQXVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760768AbYGQXVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:21:08 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:44237 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760307AbYGQXVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:21:06 -0400
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2008 19:21:06 EDT
Message-ID: <487FD2BA.4040607@cs.columbia.edu>
Date: Thu, 17 Jul 2008 19:16:10 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Kirill Korotaev <dev@parallels.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation
 with a specified id)
References: <20080418054459.891481000@bull.net> <20080422193612.GA15835@martell.zuzino.mipt.ru> <1208890580.17117.14.camel@nimitz.home.sr71.net> <20080422210130.GA15937@martell.zuzino.mipt.ru> <1208904967.17117.51.camel@nimitz.home.sr71.net> <480ED9D5.1010906@parallels.com> <480FE037.2010302@cs.columbia.edu> <m1y74a7b4w.fsf@frodo.ebiederm.org> <1215709949.9398.15.camel@nimitz> <20080710173246.GA1857@us.ibm.com>
In-Reply-To: <20080710173246.GA1857@us.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
>> On Wed, 2008-07-09 at 18:58 -0700, Eric W. Biederman wrote:
>>> In the worst case today we can restore a checkpoint by replaying all of
>>> the user space actions that took us to get there.  That is a tedious
>>> and slow approach.
>> Yes, tedious and slow, *and* minimally invasive in the kernel.  Once we
>> have a tedious and slow process, we'll have some really good points when
>> we try to push the next set of patches to make it less slow and tedious.
>> We'll be able to describe an _actual_ set of problems to our fellow
>> kernel hackers.
>>
>> So, the checkpoint-as-a-corefile idea sounds good to me, but it
>> definitely leaves a lot of questions about exactly how we'll need to do
>> the restore.
> 
> Talking with Dave over irc, I kind of liked the idea of creating a new
> fs/binfmt_cr.c that executes a checkpoint-as-a-coredump file.
> 
> One thing I do not like about the checkpoint-as-coredump is that it begs
> us to dump all memory out into the file.  Our plan/hope was to save
> ourselves from writing out most memory by:
> 
> 	1. associating a separate swapfile with each container
> 	2. doing a swapfile snapshot at each checkpoint
> 	3. dumping the pte entries (/proc/self/)
> 
> If we do checkpoint-as-a-coredump, then we need userspace to coordinate
> a kernel-generated coredump with a user-generated (?) swapfile snapshot.
> But I guess we figure that out later.

I'm not sure how this approach integrates with (a) live migration (and
the iterative process of sending over memory modified since previous
iteration), and (b) incremental checkpoint (where except for the first
snapshot, additional snapshots only save what changed since the previous
one).

Oren.

> 
> -serge
