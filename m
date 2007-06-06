Return-Path: <linux-kernel-owner+w=401wt.eu-S936495AbXFFWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936495AbXFFWo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965364AbXFFWny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:43:54 -0400
Received: from ozlabs.org ([203.10.76.45]:60831 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965232AbXFFWnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:43:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18023.14494.889739.567439@cargo.ozlabs.ibm.com>
Date: Thu, 7 Jun 2007 08:43:42 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other woes)
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
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike writes:

> On Wed, Jun 06, 2007 at 12:50:04PM +1000, Benjamin Herrenschmidt wrote:
> > Yeah, synchronous signals should probably never be delivered to another
> > process, even via signalfd. There's no point delivering a SEGV to
> > somebody else :-)
> 
> Sure there is.  UML does exactly that - intercepting child signals
> (including SEGV) with wait.

What Ben was talking about was stealing a synchronous SEGV from a task
without stopping it, and as Ben says that makes no sense.
Intercepting a signal and stopping the task is reasonable, and that is
what ptrace does, and I assume also UML.

Paul.
