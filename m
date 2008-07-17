Return-Path: <linux-kernel-owner+w=401wt.eu-S932530AbYGQU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbYGQU33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933092AbYGQU26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:28:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33564 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933071AbYGQU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:28:57 -0400
Date: Thu, 17 Jul 2008 13:28:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Ray Lee <ray-lk@madrabbit.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, torvalds@linuxfoundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <alpine.LFD.1.10.0807171304220.2959@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807171323320.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org>  <200807170011.12184.rjw@sisk.pl>  <200807161633.01375.jbarnes@virtuousgeek.org>  <487EEAEB.4050009@firstfloor.org>  <alpine.LFD.1.10.0807170807040.2959@woody.linux-foundation.org> 
 <alpine.LFD.1.10.0807170835320.2959@woody.linux-foundation.org>  <487F71E8.9050705@firstfloor.org> <2c0942db0807171211s39e2653fwdc50f92d9c3020d2@mail.gmail.com> <487FA24B.9060803@firstfloor.org> <alpine.LFD.1.10.0807171259010.2959@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807171304220.2959@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Jul 2008, Linus Torvalds wrote:
> 
> But even then, any testing you did in your private tree is now suspect, 
> because that testing was done with the old history that you threw away.  
> So even if you delete all the old histories and never show them, they kind 
> of do exist conceptually - they existed in the sense that you tested them, 
> and you've just hidden the fact that what you release is different from 
> what you tested.

One final note on this: the above is obviously not a problem for simple 
code that only really does one thing, and in particular for code that you 
wrote yourself. Moving your own commits around to make them make more 
sense - or splitting them up etc - is often a _good_ thing, even if it 
obviously does change history.

So using rebase to clean up and simplify and/or fix up stupid ordering 
issues is good, and "git rebase -i" is actually really good for this 
thing.

No, the problems start happening when you do it on a larger scale, or (and 
this is very common in the kernel), your rebase _moves_ the commits over 
big distances because you update to the top of my development tree. In 
that case, while your patches themselves may not have changed, the base 
that you based them on may have changed really subtly - it still compiles, 
it still "works", but maybe it doesn't work as well as it used to. And 
that's why the old testing you did is basically almost worthless.

So rebasing can be good or bad. It's a matter of degree. Rebasing private 
and small things is generally good. Rebasing bigger things can cause 
problems. And the further away you rebase something, the more problems it 
will generally cause. 

		Linus
