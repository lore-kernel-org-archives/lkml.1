Return-Path: <linux-kernel-owner+w=401wt.eu-S1758327AbYFQVZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327AbYFQVZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYFQVZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:25:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605AbYFQVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:25:03 -0400
Date: Tue, 17 Jun 2008 14:24:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <485829A1.4020705@firstfloor.org>
Message-ID: <alpine.LFD.1.10.0806171421100.2907@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org> <485829A1.4020705@firstfloor.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Andi Kleen wrote:
> 
> If that fixes anything:
> - The caller is broken because it shouldn't pass a faulting source to copy_to_user()
> - And you broken copy_from_user error reporting which shares the same code

Andi, I'm sorry I cc'd you. You are the author of that crap, but the bug 
seems to be that you never even understood what copy_from_user() is 
supposed to do.

The whole *and*only* reason for copy_to/from_user() existing AT ALL is 
exactly the fact that the source or destination access can fault. 

I don't really see why you continually start arguing about things that are 
OBVIOUSLY BUGGY, as if they weren't buggy. Once somebody has debugged a 
buggy routine, you shouldn't argue against it. 

So here's a hint: next time I claim some code of yours is buggy, either 
just acknowledge the bug, or stay silent. You'll look smarter that way.

			Linus
