Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbXFSMKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbXFSMKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757149AbXFSMKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:10:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:36361 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110AbXFSMKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:10:06 -0400
Subject: Re: Fix signalfd interaction with thread-private signals
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070619091452.GA94@tv-sign.ru>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
	 <1182064500.2798.6.camel@entropy>
	 <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
	 <1182108399.3794.4.camel@entropy>
	 <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
	 <1182125303.3794.8.camel@entropy>
	 <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
	 <1182127391.26853.207.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
	 <20070619091452.GA94@tv-sign.ru>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 22:09:48 +1000
Message-Id: <1182254988.26853.334.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 13:14 +0400, Oleg Nesterov wrote:

> The commited "Fix signalfd interaction with thread-private signals"
> (commit caec4e8dc85e0644ec24aeb36285e1ba02da58cc) doesn't implement
> this.

Indeed, if you want what Davide described, you need to also change
signalfd side. The patch I did merely prevents another thread from
dequeuing somebody else private signals. As it stands, signalfd will
still try it... and only get the shared ones. It will not however get
the private signals of the caller if it is different from the context
associated with the signalfd.

Ben.


