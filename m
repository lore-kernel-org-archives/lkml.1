Return-Path: <linux-kernel-owner+w=401wt.eu-S1764974AbXGPNoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764974AbXGPNoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758177AbXGPNn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:43:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:61835 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759226AbXGPNn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:43:56 -0400
Date: Mon, 16 Jul 2007 15:43:38 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
cc: 7eggert@gmx.de, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <469A5D7C.5010904@gmail.com>
Message-ID: <Pine.LNX.4.58.0707161523500.25779@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8FYWD-2eS-7@gated-at.bofh.it>
 <8GdsH-8dc-13@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
 <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>
 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/86n5uNlMLpLkLEFX5tJYZisTldD0fS+iluDU
 wrbTI9sOXcZLr2k2jsarrBwRuQDEridGNlIT0jVPbJZGokhMgd
 nfrZh0HAwBt8BgthjQUJA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007, Rene Herman wrote:
> On 07/15/2007 07:17 PM, Bodo Eggert wrote:
> > Matt Mackall <mpm@selenic.com> wrote:
> >> On Fri, Jul 13, 2007 at 03:20:54PM +0200, Rene Herman wrote:

> >>> As far as I'm aware, the actual reason for 4K stacks is that after the
> >>> system has been up and running for some time getting "1 physically
> >>> contiguous pages" becomes significantly easier than 2 which wouldn't be
> >>> arbitrary.
> >> 
> >> If there are exactly two free pages in the system, the odds of them
> >> being buddies (ie adjacent AND properly aligned) is quite small. The
> >> available page pool has to grow quite a bit before the availability of
> >> order-1 page pairs approaches 100%.
> > 
> > If there are exactly two free pages in a system, the odds of starting any
> > program are not very good. You'll have to swap, and if you do, you can swap
> > two more pages in order to free enough RAM for the stack.
> 
> A thread's kernel stack is a kernel allocation. If you'd fail to allocate it 
> you'd supposedly _already_ have swapt out everything that could be swapped out.

So we are in a desperate situation, we can almost make no progress, adding 
another task is going to push the system into an unrecoverable situation, 
and we make sure this task can be started.-)

> Moreoveover -- literally two pages free was hardly his point. The point is 
> just that (with a page being the allocation unit) single page allocations 
> are guaranteed to succeed if _any_ memory is free, while two adjacent (yes, 
> and stacksize aligned) pages will be pretty hard to get by once the system 
> has been up and running for some time.

That never happened on my servers, therefore I'd opt for the little extra 
security of having spare 4k on the stack. (I made a patch which would 
printk a message if allocating a stack would ever fail).

I'm not at all opposed to letting the guys with zillions of threads 
benefit from having less unused kernel stack, but unless it's secure for
all users, it should not be default=y.

-- 
A beggar walked up to a well-dressed woman shopping on Rodeo
Drive and said, "I haven't eaten anything for days."
She looked at him and said, "God, I wish I had your willpower."
