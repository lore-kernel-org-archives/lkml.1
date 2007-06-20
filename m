Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbXFTRi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbXFTRi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXFTRiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:38:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42647 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbXFTRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:38:19 -0400
Date: Wed, 20 Jun 2007 10:38:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <20070620111415.GA91@tv-sign.ru>
Message-ID: <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
References: <1182108399.3794.4.camel@entropy>
 <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
 <1182125303.3794.8.camel@entropy> <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
 <1182127391.26853.207.camel@localhost.localdomain>
 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
 <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain>
 <20070619140646.GB27343@tv-sign.ru> <1182295473.26853.386.camel@localhost.localdomain>
 <20070620111415.GA91@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jun 2007, Oleg Nesterov wrote:
> 
> Also, suppose that some thread does
> 
> 	for (;;)
> 		signal(SIGSEGV, SIG_IGN);
> 
> Now we have the same situation. do_sigaction() can steal SIGSEGV from
> another thread.

Actually, that shouldn't be possible.

See "force_sig_info()". It does not allow blocking or ignoring forced 
signals. We will reset such a signal handler to SIG_DFL, and unlock it.

So if you get a SIGSEGV while SIGSEGV's are blocked or ignored, the kernel 
*will* kill you. No questions asked.

		Linus
