Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXJZM6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXJZM6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbXJZM6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:58:13 -0400
Received: from cpc1-cmbg8-0-0-cust558.cmbg.cable.ntl.com ([82.6.106.47]:38241
	"EHLO zebedee.littlepinkcloud.COM" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753880AbXJZM6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:58:11 -0400
X-Greylist: delayed 3500 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 08:58:04 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18209.54926.290448.957962@zebedee.pink>
Date: Fri, 26 Oct 2007 12:59:10 +0100
From: Andrew Haley <aph@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: davids@webmaster.com, "Torvalds, Linus" <torvalds@linux-foundation.org>,
       "Kleen, Andi" <ak@suse.de>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <200710260922.54428.nickpiggin@yahoo.com.au>
References: <MDEHLPKNGKAHNMBLJOLKMEEDHMAC.davids@webmaster.com>
	<200710260922.54428.nickpiggin@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 22.0.93.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
