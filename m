Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXFVXBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXFVXBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760637AbXFVXBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:01:05 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4201 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760605AbXFVXBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:01:01 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 22 Jun 2007 16:00:53 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706221554420.3880@alien.or.mcafeemobile.com>
References: <20070620111415.GA91@tv-sign.ru> 
 <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org> 
 <20070621082509.GA88@tv-sign.ru>  <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
  <20070621182340.GA92@tv-sign.ru>  <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
  <20070621185856.GA153@tv-sign.ru>  <1182468604.24740.22.camel@localhost.localdomain>
  <20070622084034.GA134@tv-sign.ru>  <1182512473.24740.54.camel@localhost.localdomain>
  <20070622160405.GA189@tv-sign.ru> <1182551618.24740.79.camel@localhost.localdomain>
 <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Linus Torvalds wrote:

> Quite frankly, it strikes me that if we want to do this, then we shouldn't 
> save the _process_ information at all, we should save the "sighand" 
> instead.
> 
> So either we save the process info, or we save the sighand, but saving the 
> "group_leader" seems totally bogus. Especially as the group leader can 
> change (by execve()).
> 
> One thing that strikes me as I look at that function is that the whole 
> signalfd thing doesn't seem to do any reference counting. Ie it looks 
> totally buggy wrt passing the resulting fd off to somebody else, and then 
> exiting in the original process.
> 
> What did I miss?

We intercept the sighand going out of business, and we do not access it 
anymore after that (by the mean of signalfd_lock() returning zero).
I'd be OK with Oleg patch, although I really prefer signalfd being more 
flexible (that is, with sync signals disabled in signalfd, and with Ben's 
patch reverted). Unless clear point of breakage are shown with such 
approach.



- Davide


