Return-Path: <linux-kernel-owner+w=401wt.eu-S1765424AbYEATGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765424AbYEATGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765328AbYEATG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:06:29 -0400
Received: from mail.lang.hm ([64.81.33.126]:45562 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763768AbYEATG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:06:28 -0400
Date: Thu, 1 May 2008 12:07:53 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Willy Tarreau <w@1wt.eu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080501185032.GA30883@1wt.eu>
Message-ID: <alpine.DEB.1.10.0805011155520.9847@asgard>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
 <20080501185032.GA30883@1wt.eu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008, Willy Tarreau wrote:

> I also proposed to group merges by reduced overlapping areas, and to
> shorten the merge window and make it (at least) twice as often. Rafael
> also proposed to merge core first, then archs, which is a refined variation
> on the same principle. I'm not sure I've seen your opinion on this.

the problem with trying to make the cycle twice as fast is that it takes 
time to hunt down the hard bugs, even when you have some idea where they 
are.

go back through the last few kernels and look at the bugs that were fixed 
in the last couple of -rc releases (and in final), would they have really 
been fixed faster if other changes hadn't taken place?

I suspect that they would not have, and if I'm right the result of merging 
half as much wouldn't be twice as many releases, but rather approximatly 
the same release schedule with more piling up for the next release.

even individual git trees that do get a fair bit of testing (like 
networking for example) run into odd and hard to debug problems when 
exposed to a wider set of hardware and loads. having the networking 
changes go in every 4 months (with 4 months worth of changes) instead of 
every 2 months (with 2 months worth of changes) will just mean that there 
will be more problems in this area, and since they will be more 
concentrated in that area it will be harder to fix them all fast as the 
same group of people are needed for all of them.

if several maintainers think that you are correct that doing a merge with 
far fewer changes will be a lot faster, they can test this in the real 
world by skipping one release. just send Linus a 'no changes this time' 
instead of a pull request. If you are right the stable release will happen 
significantly faster and they can say 'I told you so' and in the next 
release have a fair chance of convincing other maintainers to skip a 
release.

it does worry me a bit that the release cycle seems to be slipping 
slightly each release, but I don't see a good way to fix this.

David Lang
