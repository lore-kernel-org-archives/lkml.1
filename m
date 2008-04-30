Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbYD3VnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbYD3VnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759834AbYD3VnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:43:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:45249 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYD3VnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=shaTbMy0TijKd8ufTZN4SMTbGDkm+5NyxC90LmXslKgK7XohKoG/uHV6sAJjtUkkGAf8PFsCzgqfP6SSCwXUMDxEn7h8bDJff9flrtIhOnVCB88FKMooIjrduGca2lrvVyCtzttW5R1QXtmsMSjrsPFrc5w+NVCN7+OSFvtjIi8=
Message-ID: <4818E7E3.7080705@gmail.com>
Date: Thu, 01 May 2008 01:42:59 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, rjw@sisk.pl,
       davem@davemloft.net, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	<200804302136.58005.rjw@sisk.pl>	<20080430131537.1f7a0914.akpm@linux-foundation.org>	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org>
In-Reply-To: <20080430135405.ddc42075.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton пишет:
> On Wed, 30 Apr 2008 13:31:08 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>
>> On Wed, 30 Apr 2008, Andrew Morton wrote:
>>> <jumps up and down>
>>>
>>> There should be nothing in 2.6.x-rc1 which wasn't in 2.6.x-mm1!
>> The problem I see with both -mm and linux-next is that they tend to be 
>> better at finding the "physical conflict" kind of issues (ie the merge 
>> itself fails) than the "code looks ok but doesn't actually work" kind of 
>> issue.
>>
>> Why?
>>
>> The tester base is simply too small.
>>
>> Now, if *that* could be improved, that would be wonderful, but I'm not 
>> seeing it as very likely.
>>
>> I think we have fairly good penetration these days with the regular -git 
>> tree, but I think that one is quite frankly a *lot* less scary than -mm or 
>> -next are, and there it has been an absolutely huge boon to get the kernel 
>> into the Fedora test-builds etc (and I _think_ Ubuntu and SuSE also 
>> started something like that).
>>
>> So I'm very pessimistic about getting a lot of test coverage before -rc1.
>>
>> Maybe too pessimistic, who knows?
>>
> 
> Well.  We'll see.
> 
> linux-next is more than another-tree-to-test.  It is (or will be) a change
> in our processes and culture.  For a start, subsystem maintainers can no
> longer whack away at their own tree as if the rest of use don't exist. 
> They now have to be more mindful of merge issues.
> 
> Secondly, linux-next is more accessible than -mm: more releases, more
> stable, better tested by he-who-releases it, available via git:// etc.

Andrew, the latter thing is a very good point. For me personally, the fact
that -mm is not available via git is the major obstacle for trying your
tree more frequently than just a few times per year. How difficult it
would be to switch to git for you? I guess there are good reasons for still
using the source code management system from the last century; please
correct me if I'm wrong, but I believe that using a modern SCM system could
make life easier for you and your testers, no?

> 
> I get the impression that we're seeing very little non-Stephen testing of
> linux-next at this stage.  I hope we can ramp that up a bit, initially by
> having core developers doing at least some basic sanity testing.
> 

For busy (or lazy) people like myself, the big problem with linux-next are
the frequent merge breakages, when pulling the tree stops with "you are in
the middle of a merge conflict". Perhaps, there is a better way to resolve
this without just removing the whole repo and cloning it once again - this
is what I'm doing, please flame me for stupidity or ignorance if I simply
am not aware of some git feature that could be useful in such cases.

Finally, while the list is at it, I'd like to make another technical comment.
My development zoo is a pretty fast 4-way Xeon server, where I keep a handful
of trees, a few cross-toolchains, Qemu, etc. The network setup in our
organization is such that I can use git only over http from that server. This
cannot be changed, it's the company policy. In view of that, it's a pity that
quite a few tree owners don't make sure that http access to their trees works
(I added Ingo to the Cc: list in the hope that this will be corrected soon for
the x86 tree, which I am using quite extensively), and I have to use a much
slower machine (a two and a half year old laptop) for these trees. Please see
this:

<<<<<<<

[dmitri.vorobiev@amber ~]$ git clone http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
Initialized empty Git repository in /home/dmitri.vorobiev/linux-2.6-x86/.git/
Getting alternates list for http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
Also look at http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
Getting pack list for http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
Getting index for pack ded7039bef9c148e5bb991a1b61da1d67c0ad3c2
Getting pack list for http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/torvalds/linux-2.6.git/
error: Unable to find 08acd4f8af42affd8cbed81cc1b69fa12ddb213f under http://www.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
Cannot obtain needed object 08acd4f8af42affd8cbed81cc1b69fa12ddb213f
[dmitri.vorobiev@amber ~]$ 

<<<<<<<

Thanks,
Dmitri

