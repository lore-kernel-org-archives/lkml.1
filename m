Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbXETTOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbXETTOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbXETTOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:14:31 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:46371 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451AbXETTOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:14:30 -0400
Message-ID: <46509DE8.3060308@cosmosbay.com>
Date: Sun, 20 May 2007 21:13:44 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: first little problem with private futexes
References: <465095E5.4050508@redhat.com> <46509924.8020904@cosmosbay.com> <a36005b50705201201y724ac400u5581df86c62d9de2@mail.gmail.com>
In-Reply-To: <a36005b50705201201y724ac400u5581df86c62d9de2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 20 May 2007 21:13:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper a écrit :
> On 5/20/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
>> > 1.  do nothing, always use the shared futexes.  Not very attractive IMO
>>
>> Why do you find this non attractive ?
>>
>> How is it performance critical ?
> 
> You should know better than any other that the problem is not that the
> problem itself is the only one affected.  If threads terminate all
> other programs and threads are affected since the global locks for the
> shared futexes are needed.  That's the case I'm concerned about.  It's
> not really about a single app creating many many threads over and over
> again.  It's about many apps which do use threads (and that number
> will have to rise) starts and stop threads at a reasonable rate.  It's
> just one more unnecessary point of contact between concurrently
> running apps.

Well, current private futex code still use global locks (one common hash table 
were all waited futexes are queued, private or shared)

'Only' mmap_sem and inode/mm refcounter inc/dec are avoided.

My proposal of having separate namespace was hold, in order to get the 
'private futexes' accepted in kernel.

So for the moment, I am not sure glibc should try to optimize CLEARTID operation.


