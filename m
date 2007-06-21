Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbXFUSCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbXFUSCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbXFUSC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:02:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54348 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755044AbXFUSCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:02:24 -0400
Date: Thu, 21 Jun 2007 11:01:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <20070621082509.GA88@tv-sign.ru>
Message-ID: <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
References: <1182125303.3794.8.camel@entropy>
 <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
 <1182127391.26853.207.camel@localhost.localdomain>
 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
 <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain>
 <20070619140646.GB27343@tv-sign.ru> <1182295473.26853.386.camel@localhost.localdomain>
 <20070620111415.GA91@tv-sign.ru> <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
 <20070621082509.GA88@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Oleg Nesterov wrote:
> 
> Yes, force_sig() unblocks and un-ignores the signal. However, unlike group-wide
> signals, thread-specific signals do not convert themselves to SIGKILL on delivery.
> The target thread should dequeue SIGSEGV and then it calls do_group_exit().

No it couldn't.

Why? Because the target thread is the one that *caused* the SIGSEGV in the 
first place. It's not going to dequeue *anything*. It's either going to 
take the SIGSEGV, or it's going to get another SIGSEGV and now it's no 
longer masked/handled and it's going to die.

		Linus
