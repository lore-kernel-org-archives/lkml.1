Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYBED2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYBED2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 22:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYBED2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 22:28:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbYBED2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 22:28:12 -0500
Date: Mon, 4 Feb 2008 19:27:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
In-Reply-To: <200802050436.31070.maximlevitsky@gmail.com>
Message-ID: <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Feb 2008, Maxim Levitsky wrote:
> 
> The x86 tree was merged several times, but I don't see kgdb included in 
> latest mainline -git.
> 
> So just one question, will it be included or no?

I won't even consider pulling it unless it's offered as a separate tree, 
not mixed up with other things. At that point I can give a look.

That said, I explained to Ingo why I'm not particularly interested in it. 
I don't think that "developer-centric" debugging is really even remotely 
our problem, and that I'm personally a lot more interested in 
infrastructure that helps normal users give better bug-reports. And kgdb 
isn't even _remotely_ it.

So I'd merge a patch that puts oops information (or the whole console 
printout) in the Intel management stuff in a heartbeat. That code is 
likely much grottier than any kgdb thing will ever be (Intel really 
screwed up the interface and made it some insane XML thing), but it's also 
fundamentally more important - if it means that normal users can give oops 
reports after they happened in X (or, these days, probably more commonly 
during suspend/resume) and the machine just died.

kgdb? Not so interesting. We have many more hard problems happening at 
user sites, not in developer hands.

		Linus
