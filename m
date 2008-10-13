Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbYJMPqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbYJMPqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbYJMPqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:46:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449AbYJMPqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:46:06 -0400
Date: Mon, 13 Oct 2008 08:44:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Karel Zak <kzak@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
 "hwclock" program
In-Reply-To: <20081013152633.GA6523@elte.hu>
Message-ID: <alpine.LFD.2.00.0810130841440.3288@nehalem.linux-foundation.org>
References: <20081004174433.14a5e093@infradead.org> <20081004215225.2444d54b.akpm@linux-foundation.org> <20081005081145.30ba921b@infradead.org> <20081005102742.de8353b4.akpm@linux-foundation.org> <20081005103826.6771540a@infradead.org> <20081012200004.GI10429@nb.net.home>
 <alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org> <20081013152633.GA6523@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Oct 2008, Ingo Molnar wrote:
> 
> do you agree with the changelog and can i add your Signed-off-by ?

Sure. One thing I'd still like to see is that crazy "again" vs "survive" 
mess for x86-64 vs x86-32. I think the patch as posted will cause a new 
warning on x86-32 due to "unused label 'again'" or similar.

It's totally insane that we have two different versions of the oom 
handling for x86. I don't know why we do that, it's probably historical, 
and I _suspect_ that the 32-bit one has gotten a lot more testing.

And not just because there have been more of the 32-bit kernels around, 
but also because low-memory situations are probably more common on 32-bit 
setups. But I dunno. 

So I would suggest you just pick the x86-32 version of that oom handling 
thing too. Unless you know some deep reason why the 64-bit one would be 
superior.

		Linus
