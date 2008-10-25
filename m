Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYJYWeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYJYWeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 18:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYJYWeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 18:34:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751301AbYJYWeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 18:34:16 -0400
Date: Sat, 25 Oct 2008 15:33:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       walt <w41ter@gmail.com>
Subject: Re: [PULL] module, param and stop_machine patches
In-Reply-To: <200810260924.09479.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0810251529240.3327@nehalem.linux-foundation.org>
References: <200810221005.59874.rusty@rustcorp.com.au> <alpine.LFD.2.00.0810251416130.3327@nehalem.linux-foundation.org> <200810260924.09479.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Oct 2008, Rusty Russell wrote:
> 
> Thanks, Heiko tracked this down; he's probably sleeping now but Hugh and Walt
> reported this fixes it for them and it makes sense.

I'm not seeing any "tracked it down".

Yes, it moves it back to its old place, but doesn't say why the new one 
didn't work.

And it then mixes things up with 'stop_machine_init()' mess. Why does that 
need to run so early?

Is there any reason why the real patch isn't just to make 
'stop_machine_init' a 'core_initcall()' instead of 'early_initcall()'?

IOW, I don't think that patch is anything but a "hey, test if it works 
with this". None of the changes or the problems are explained. Nor do I 
see a sign-off from Heiko on it.

I also don't want to see more BUG_ON()'s there. Make them warnings or 
something.

		Linus
