Return-Path: <linux-kernel-owner+w=401wt.eu-S1762959AbXFRRDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762959AbXFRRDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758278AbXFRRCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:02:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48087 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbXFRRCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:02:54 -0400
Date: Mon, 18 Jun 2007 10:01:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Carlo Wood <carlo@alinoe.com>
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com, lethal@linux-sh.org,
       y-goto@jp.fujitsu.com
Subject: Re: 2.6.22-rc5 regression
In-Reply-To: <20070617214905.GA6207@alinoe.com>
Message-ID: <alpine.LFD.0.98.0706180950130.14121@woody.linux-foundation.org>
References: <20070617182254.GA17595@alinoe.com> <20070617195805.GA6125@alinoe.com>
 <20070617214905.GA6207@alinoe.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 Jun 2007, Carlo Wood wrote:
> 
> If you want my opinion on this: git bisect is broken :p
> I was very surprised that it printed this at this point.

Hmm. Possible. However, I *really* would need the git bisect log to see 
what's up. So far, we have never seen a bug in "git bisect" that wasn't 
either due to the user specifying path-names to limit the testing (and the 
bug not being in that set of path-names), or the user not realizing that 
with non-linear history the "git bisect" is actually a fairly complex op.

That said, "git bisect" _can_ give the "wrong" results in the sense that 
the commit it points to may not be the one you are actually looking for, 
if:

 - the bug is sporadic, and not entirely repeatable, and a kernel you 
   marked as good wasn't really good, your test just didn't happen to 
   catch it that time around.

 - the bug comes and goes, and the commit that "git bisect" pinpoints may 
   well *show* the bug, but may not be the *cause* of the bug (ie there 
   might be two or more independent things that have to come together for 
   the bug to trigger, and as a result there is not a "single" commit that 
   acts as a clear boundary)

But hey, a bug in "git bisect" is certainly _possible_. I just consider it 
fairly unlikely by now. 

> One bisect before, it said there were still 96 revision to check.
> 
> Anyway - here are some facts of the kernels that I tested:

You seem to not actually have used "git bisect" to generate this list.

Quite frankly, the most likely cause for the bad bisection result is that 
you have not used "git bisect" at all to let it pick the bisection points. 
That really doesn't work. If you start giving "git bisect" points to test 
that aren't "within" the space of points you had already told git bisect 
about, you're no longer bisecting, you're giving it random points.

> I'd appreciate any suggestions or questions at this point, as I have no
> idea what to do next to find this problem.

If you do a real "git bisect", and don't just give it random points that 
you want to check (you obviously _do_ need to give it one "good" and one 
"bad" initially, but after that you *have* to pick a point that is within 
the query space), you'll not get any sensible values out of git bisect.

"git bisect" will also give you a log in ".git/BISECT_LOG", which others 
can use to follow your bisection. That might be useful to see.

			Linus

