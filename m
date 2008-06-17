Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbYFQVQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbYFQVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbYFQVQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:16:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33355 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbYFQVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:16:18 -0400
Message-ID: <485829A1.4020705@firstfloor.org>
Date: Tue, 17 Jun 2008 23:16:17 +0200
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
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org> <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 17 Jun 2008, Linus Torvalds wrote:
>> I don't think that code is reasonably salvageable. Damn. 
> 
> Hmm. Something like this *may* salvage it.
> 
> Untested, so far (I'll reboot and test soon enough), but even if it fixes 
> things, it's not really very good. 

If that fixes anything:
- The caller is broken because it shouldn't pass a faulting source to copy_to_user()
- And you broken copy_from_user error reporting which shares the same code

-Andi


