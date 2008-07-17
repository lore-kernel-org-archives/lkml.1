Return-Path: <linux-kernel-owner+w=401wt.eu-S1759948AbYGQQXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759948AbYGQQXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYGQQXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:23:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50647 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbYGQQXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:23:07 -0400
Message-ID: <487F71E8.9050705@firstfloor.org>
Date: Thu, 17 Jul 2008 18:23:04 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       torvalds@linuxfoundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
References: <20080716214516.GA10777@basil.nowhere.org> <200807170011.12184.rjw@sisk.pl> <200807161633.01375.jbarnes@virtuousgeek.org> <487EEAEB.4050009@firstfloor.org> <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org> <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 17 Jul 2008, Linus Torvalds wrote:
>> That's the whole point of topic branches. They allow you to separate out 
>> work to different areas, so that people who are interested in (say) the 
>> PCI-impacting ones can merge with one part, without having to wait for the 
>> other parts to stabilize.
> 
> Btw, you don't really have to have a lot of them.
> 
> When it comes to ACPI in particular, I would really prefer to see at least 
> the ACPICA stuff in a separate topic branch. It comes in from a different 
> source, it's maintained separately, and when it causes problems(*) it ends 
> up usually being handled differently too.

Ok I can do that one separately.

I think my main problem was that it seemed so painful to change old
commits and I ended up accumulating ugly reverts and incremental changes,
but perhaps I just need to do better frontend scripts to make
that easier.

> So one reason I reacted strongly to the ACPI change was definitely just 
> that ACPI used to be one of the really nicely done subsystems (not just 
> from a git standpoint, but the whole git flow was part of it). There were 
> some issues very early on in git usage, but I gave a shout-out to Len at 
> the last kernel summit for a reason.

Well, at least for this summer the ACPI tree will have some Andi flavor.

> And in that sense it's definitely unfair to require quite _that_ level of 
> separation. I'm really not expecting it. 
> 
> But I *really* hate pulling from somebody, and seeing commit dates that 
> are from five minutes ago, and based on something that I had just pushed 
> out (which was essentially the case for this round of ACPI changes).
> 
> That literally shows that the code was hardly tested _at_all_ in that 
> exact configuration. It may have gotten testing based on some earlier 
> kernel version, but then it very clearly got rebased (or just quilt 
> imported) on top of a totally new kernel base, and was not tested in that 
> version very much if at all.

Hmm, perhaps I'm thick, but for me the only difference seems to be
that the submitter does the merge that you would do (and safes
himself a yelling at if it doesn't build or crashes at boot or similar...).

In both  cases there's a "untested in that configuration" end configuration
in the end, but there's nothing much that can be done against it,
can't it?

> 
> So even if you end up using quilt, I'd suggest you do so on a specific 
> base, rather than on some random "kernel-of-the-moment-in-the-middle- 
> of-the-merge-window". 

That is what I usually do. I use the last -git* snapshot. I just updated
the git tree shortly before I generate the merge tree just to make
sure it still builds in your current tree.

Given it won't be tested much in that newer configuration then (I actually
test booted it on a few systems at least[1]), but that would be the same on your
side, wouldn't it?

-Andi

[1] which was quite painful this time because I ran into several problems
outside ACPI. e.g. DMAR oopsed and the x86 defconfigs were totally broken
and some other issues.
