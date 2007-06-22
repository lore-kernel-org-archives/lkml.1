Return-Path: <linux-kernel-owner+w=401wt.eu-S1759823AbXFVXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823AbXFVXQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXFVXQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:16:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:40962 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbXFVXQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:16:43 -0400
Subject: Re: Fix signalfd interaction with thread-private signals
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org>
References: <20070620111415.GA91@tv-sign.ru>
	 <alpine.LFD.0.98.0706201035030.3593@woody.linux-foundation.org>
	 <20070621082509.GA88@tv-sign.ru>
	 <alpine.LFD.0.98.0706211100200.3593@woody.linux-foundation.org>
	 <20070621182340.GA92@tv-sign.ru>
	 <alpine.LFD.0.98.0706211133350.3593@woody.linux-foundation.org>
	 <20070621185856.GA153@tv-sign.ru>
	 <1182468604.24740.22.camel@localhost.localdomain>
	 <20070622084034.GA134@tv-sign.ru>
	 <1182512473.24740.54.camel@localhost.localdomain>
	 <20070622160405.GA189@tv-sign.ru>
	 <1182551618.24740.79.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706221540430.3593@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 23 Jun 2007 09:16:30 +1000
Message-Id: <1182554190.24740.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 15:47 -0700, Linus Torvalds wrote:
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

Probably nothing... doesn't look good. What are the lifetime rules of a
struct sighand tho ?

Ben.


