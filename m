Return-Path: <linux-kernel-owner+w=401wt.eu-S966046AbXFGDWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966046AbXFGDWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 23:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935765AbXFGDWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 23:22:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:59676 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935757AbXFGDWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 23:22:13 -0400
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs,
	losing TIF_SIGPENDING and other woes)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20070606125259.GA5491@c2.user-mode-linux.org>
References: <Pine.LNX.4.64.0706041935230.30836@alien.or.mcafeemobile.com>
	 <1181013756.31677.123.camel@localhost.localdomain>
	 <1181023787.2785.14.camel@entropy>
	 <1181028453.31677.127.camel@localhost.localdomain>
	 <1181087462.2788.8.camel@entropy>
	 <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com>
	 <1181088936.2788.10.camel@entropy>
	 <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com>
	 <1181091523.2788.28.camel@entropy>
	 <1181098204.31677.158.camel@localhost.localdomain>
	 <20070606125259.GA5491@c2.user-mode-linux.org>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 13:21:57 +1000
Message-Id: <1181186517.14818.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 08:52 -0400, Jeff Dike wrote:
> On Wed, Jun 06, 2007 at 12:50:04PM +1000, Benjamin Herrenschmidt wrote:
> > Yeah, synchronous signals should probably never be delivered to another
> > process, even via signalfd. There's no point delivering a SEGV to
> > somebody else :-)
> 
> Sure there is.  UML does exactly that - intercepting child signals
> (including SEGV) with wait.

UML is definitely what I call a special case :-) Now the question is how
do you get them ? Are you via some code path I haven't figured out
calling dequeue_signal() from another context ?

Ben.


