Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYJOPGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYJOPGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYJOPGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:06:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbYJOPGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:06:43 -0400
Date: Wed, 15 Oct 2008 08:06:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: GIT head no longer boots on x86-64
In-Reply-To: <20081015115153.GA16413@elte.hu>
Message-ID: <alpine.LFD.2.00.0810150758310.3288@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810130752020.3288@nehalem.linux-foundation.org> <1223910693-28693-1-git-send-email-jirislaby@gmail.com> <20081013164717.7a21084a@lxorguk.ukuu.org.uk> <20081015115153.GA16413@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Ingo Molnar wrote:
> 
> Queued the fix below up in tip/x86/urgent for a merge to Linus later 
> today. Thanks!

Please don't send this crap to me.

Guys, _look_ at the patch for one second. And then tell me it isn't crap. 

The question is: "Is this a vmalloc'ed area?". That's the name of the 
function. AND YOU JUST BROKE IT!

Fix the damn caller instead. Don't make x86-64-specific changes to a 
generic function that breaks the whole meaning of the function. I don't 
understand what the hell is wrong with you people - we don't fix bugs by 
introducing idiocies, we fix them by fixing the code.

EVEN YOUR COMMIT MESSAGE should have made this obvious.

The code in question already does

	VIRTUAL_BUG_ON(!is_vmalloc_addr(vmalloc_addr) &&
                       !is_module_address(addr));

and look at that thing and ask yourself: where was the bug again.

And dammit, if you say it was in "is_vmalloc_addr()", I can only shake my 
head.

Please guys. Use some taste. 

		Linus
