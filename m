Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYAYLgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYAYLgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 06:36:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYAYLfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 06:35:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbYAYLfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 06:35:51 -0500
Date: Fri, 25 Jan 2008 12:35:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24
Message-ID: <20080125113536.GD20026@elte.hu>
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <alpine.LFD.1.00.0801241529440.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4799A773.2030702@cateee.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Giacomo A. Catenazzi <cate@cateee.net> wrote:

> Linus Torvalds wrote:
>>
>> On Thu, 24 Jan 2008, Linus Torvalds wrote:
>>> The release is out there (both git trees and as tarballs/patches), and 
>>> for the next week many kernel developers will be at (or flying into/out 
>>> of) LCA in Melbourne, so let's hope it's a good one.
>>
>> Since I already had two kernel developers asking about the merge window 
>> and whether people (including me) traveling will impact it, the plan right 
>> now is to keep the impact pretty minimal. So yes, it will probably extend 
>> the window from the regular two weeks, but *hopefully* not by more than a 
>> few days.
>
> As a tester, I'm not so happy.
> The last few merge windows were a nightmare for us (the tester).
> It remember me the 2.1.x times, but with few differences:
> - more changes, so bugs are unnoticed/ignored in the first weeks or
> - or people are pushing more patches possible, so they delay
>   bug corrections to later times (after merge windows).

i think this heavily varies per subsystem.

v2.6.24-rc was pretty bad due to the sglist design bug that crept in and 
that kept most of the IO hackers busy for a few weeks, while testsystems 
kept crashing and no progress was made on _other_ bugs. v2.6.24 early 
rc's were also marred by half-cooked networking patches messing up 
bisectability. I've seen a number of testers give up on that alone. 
There was an unusually high flux of networking fixes throughout v2.6.24, 
up to the very last day before the release.

Since it's Friday already, i put the blame for that on all the 
subsystems that do not develop on lkml! :-)

It is _very_ hard for us to judge the stability and sanity of a 
subsystem (and the risk factor of upcoming features!) if it's not 
developed on lkml. Observing the bugs alone helps in getting a picture, 
but it does not help the testers of early -rc's: it is a few 
weeks/months after the fact and hence too late. We need to be able to 
observe the development activities, but that's hard with all these 
detached development lists. (Not only hard, it is in fact impossible, 
given the sheer number of mailing list addresses in MAINTAINERS. I know, 
i tried it.)

so -rc stability is usually a function of the feature/fix ratio of a 
given subsystem's changes for a kernel, and those are very hard to 
predict if they are not done on lkml. Getting good -mm coverage for the 
subsystem git trees helps quite a bit as Andrew does a heroic job 
herding all the cats, but still there's way too much 'surprise factor' 
in the git merges and all the hidden development that is not directly 
visible on lkml. The 'surprise factor' is not even come mainly from 
combining all the trees together (that is relatively easy), it is in the 
cumulative risk factor that is hard to get right due to development not 
always being done on lkml.

Case point from arch/x86: everyone who follows lkml could have predicted 
it from the PAT development discussions that PAT is simply not ready 
yet. We deferred it to v2.6.26, but had we tried to cram it into v2.6.25 
and had it broken boxes left and right, we'd rightfully be confronted 
with all the existing lkml track record that suggested bad PAT related 
problems and predicted the outcome. For subsystems that do not develop 
on lkml, no such lkml track record exists and the danger of introducing 
bad patches and ruining early -rc's increases.

	Ingo
