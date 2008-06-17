Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbYFQVay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbYFQVay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYFQVar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:30:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58122 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYFQVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:30:46 -0400
Message-ID: <48582D04.1000107@firstfloor.org>
Date: Tue, 17 Jun 2008 23:30:44 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386, bisected,
 reproducable)
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <485829A1.4020705@firstfloor.org> <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 17 Jun 2008, Andi Kleen wrote:
>> If that fixes anything:
>> - The caller is broken because it shouldn't pass a faulting source to copy_to_user()
>> - And you broken copy_from_user error reporting which shares the same code
> 
> Andi, I'm sorry I cc'd you. You are the author of that crap, but the bug 
> seems to be that you never even understood what copy_from_user() is 
> supposed to do.
> 
> The whole *and*only* reason for copy_to/from_user() existing AT ALL is 
> exactly the fact that the source or destination access can fault. 

yes, but only one of them (destination for copy_to_user and source for
copy_from_user)

Or are you're describing copy_in_user()?

> I don't really see why you continually start arguing about things that are 
> OBVIOUSLY BUGGY, as if they weren't buggy. Once somebody has debugged a 
> buggy routine, you shouldn't argue against it. 
> 
> So here's a hint: next time I claim some code of yours is buggy, either 
> just acknowledge the bug, or stay silent. You'll look smarter that way.

Ok if I'm really wrong on this (but frankly I don't see the mistake, sorry)
for my person edification: what's a legitimate case for copy_to_user()
where the source can fault?

-Andi


