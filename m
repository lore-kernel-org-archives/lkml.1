Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbYJWQoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbYJWQoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbYJWQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:44:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101AbYJWQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:44:07 -0400
Date: Thu, 23 Oct 2008 09:43:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] core fixes
In-Reply-To: <20081021144753.GA553@elte.hu>
Message-ID: <alpine.LFD.2.00.0810230939080.3287@nehalem.linux-foundation.org>
References: <20081021144753.GA553@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Oct 2008, Ingo Molnar wrote:
> 
> this is because the merge-base of this tree is 2e532d68a2, while your 
> tree that merges this is fresher.
> 
> I did not want to merge to your latest, to not create an unnecessary 
> merge commit. But i could not find a way either how to generate a proper 
> shortlog either.

Just do

	# update the remote branches
	git fetch linus
	# get the log difference
	git shortlog linus..

because "git log" and friends don't care about the merge base, they only 
care about the actual commit _set_difference_. So "linus.." is shorthand 
for "linus..HEAD", which in turn means "Which commits are in HEAD but not 
in 'linus".

Doing a _diff_ is different, and when you do "git diff linus.." doesn't 
mean a set difference, it means an "endpoint difference", and there you 
need to find the merge base in order to get a sane answer. Of course, then 
the diff won't necessarily be what I see, since common commits will 
disappear. But even there, you can do

	git diff linus...

where the triple dots mean "symmetric set difference" for a log-based (ie 
"set operation") operation, but means "difference from common merge base" 
for an endpoint operation (ie "git diff").

		Linus
