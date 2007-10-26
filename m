Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbXJZO2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbXJZO2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXJZO2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:28:36 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:35038 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbXJZO2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:28:35 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 10:28:35 EDT
Message-Id: <200710261413.l9QEDEQn025585@littlepinkcloud.COM>
X-Sieve: CMU Sieve 2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: <200710260922.54428.nickpiggin@yahoo.com.au>
References: <MDEHLPKNGKAHNMBLJOLKMEEDHMAC.davids@webmaster.com>
	<200710260922.54428.nickpiggin@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 22.0.93.1
From: Andrew Haley <aph@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: davids@webmaster.com, "Torvalds, Linus" <torvalds@linux-foundation.org>,
       "Kleen, Andi" <ak@suse.de>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 12:59:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ I had to resend this message.  Sorry if you received two copies. ]

Nick Piggin writes:
 > Can you retain cc list, please?
 > 
 > On Friday 26 October 2007 07:42, David Schwartz wrote:

 > > 	I asked a collection of knowledgeable people I know about the
 > > issue. The consensus is that the optimization is not permitted in
 > > POSIX code but that it is permitted in pure C code. The basic
 > > argument goes like this:
 > >
 > > 	To make POSIX-compliant code even possible, surely
 > > optimizations that add writes to variables must be
 > > prohibited. That is -- if POSIX prohibits writing to a variable
 > > in certain cases only the programmer can detect, then a
 > > POSIX-compliant compiler cannot write to a variable except where
 > > explicitly told to do so. Any optimization that *adds* a write to
 > > a variable that would not otherwise occur *must* be prohibited.

I don't think that POSIX is quite as explicit as that.  See
http://www.hpl.hp.com/techreports/2004/HPL-2004-209.pdf

 > > 	Otherwise, it is literally impossible to comply with the POSIX
 > > requirement that concurrent modifications and reads to shared
 > > variables take place while holding a mutex.
 > 
 > Now all you have to do is tell this to the gcc developers ;)

We're listening, really.  It's unacceptable that gcc should break
code.

However, fixing it is hard.  The best plan is probably to implement
(part of) the proposed standard memory model, and that requires
careful consideration.  We could in theory simply disable this
particular optimization, but that probably isn't a good idea on its
own because other optimizations might well break other code in a
similar way.  We need to have a very close look at the thread-safe
memory model in order to determine where we do things that might
break.

An official standard containing this is still at least two years out.

Andrew.

-- 
Red Hat UK Ltd, Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, UK
Registered in England and Wales No. 3798903
