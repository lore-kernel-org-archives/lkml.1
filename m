Return-Path: <linux-kernel-owner+w=401wt.eu-S1751574AbZH2NLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbZH2NLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 09:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZH2NLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 09:11:31 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:40468 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZH2NLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 09:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0908282345150.18588@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>
	 <1251211483.7538.1162.camel@twins>
	 <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy>
	 <1251212859.7538.1166.camel@twins>
	 <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy>
	 <1251265742.7538.1192.camel@twins>
	 <alpine.LNX.2.00.0908261113450.16876@fgnss.gnfx.tqn.cy>
	 <alpine.LNX.2.00.0908270956420.16876@fgnss.gnfx.tqn.cy>
	 <1251364230.18584.52.camel@twins>
	 <alpine.LNX.2.00.0908282345150.18588@fgnss.gnfx.tqn.cy>
Date: Sat, 29 Aug 2009 09:11:32 -0400
Message-ID: <7e0fb38c0908290611h7dc003a8i9a8a6d996c592352@mail.gmail.com>
Subject: Re: PROBLEM: oops
From: Eric Paris <eparis@parisplace.org>
To: Pawel Golaszewski <blues@gda.pl>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Dhaval Giani <dhaval.giani@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 5:46 PM, Pawel Golaszewski<blues@gda.pl> wrote:
> On Thu, 27 Aug 2009, Peter Zijlstra wrote:
>> > > > # git log --format=oneline v2.6.27.13..v2.6.27.31 kernel/sched*
>> > > > 2b46f3769896dc04e1e49144d282e4655677105a wait: prevent exclusive waiter starvation
>> > > >
>> > > > Nothing changed anywhere near the code that is falling apart..
>> > > I have 2 machines with the same hardware and similar software. On
>> > > one .13 is stable - I will test it on the second one. Should be too.
>> > I've checked it - 2.6.27.13 is stable for me. Conclusion: there is
>> > something wrong between 2.6.27.13 and 2.6.27.31 What can I do about
>> > that? I'm not kernel-hacker...
>> Unless any of the memory debugging options yield a clue the best you can
>> do is a bisection I'm afraid.
>>
>> # git log --format=oneline v2.6.27.13..v2.6.27.31 | wc -l
>> 630
>
> Ok, I checked:
>
> 2.6.27.15 works fine
> 2.6.27.17 crashes (log was sent).
>
> What now?

Have you ever used git, and especially git-bisect?  That's what would
really help to run it down.  Try this operation.

git clone git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
stable-tree
cd stable-tree
git bisect start
git bisect bad v2.6.27.17
git bisect good v2.6.27.15

(a)
[git will do some work and will leave you with a message that says
something like "Bisecting: 675 revisions left to test after this"]
build the kernel tree.
test your build.

if it works go back to the stable-tree directory and enter:
git bisect good

if that kernel fails enter:
git bisect bad

goto (a)

Eventually there will be no more revisions left to bisect, and you
will have been left with the first bad kernel revision in
"refs/bisect/bad".

Let us know what this patch is that broke it for you.

Thanks!
