Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbXKBPi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbXKBPi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXKBPiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:38:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbXKBPiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:38:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18219.17505.443550.620503@zebedee.pink>
Date: Fri, 2 Nov 2007 15:38:09 +0000
From: Andrew Haley <aph@redhat.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Cc: "David Schwartz" <davids@webmaster.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Tomash Brechko" <tomash.brechko@gmail.com>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <e2e108260711020829p5994f79bp48ca35a1ce84ff03@mail.gmail.com>
References: <18210.2314.57767.962503@zebedee.pink>
	<MDEHLPKNGKAHNMBLJOLKCELIHMAC.davids@webmaster.com>
	<18215.1394.294830.944162@zebedee.pink>
	<e2e108260711020829p5994f79bp48ca35a1ce84ff03@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 22.0.93.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche writes:
 > On 10/30/07, Andrew Haley <aph@redhat.com> wrote:
 > > David Schwartz writes:
 > > >
 > > > Can we get some kind of consensus that 'optimizations' that add
 > > > writes to any object that the programmer might have taken the
 > > > address of are invalid on any platform that supports memory
 > > > protection?
 > >
 > > That's what the proposed standard language says, kinda-sorta.  There's
 > > an informal description at
 > > http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2338.html.
 > 
 > There is other important information in the cited text. A.o. it is
 > explained that register promotion of potentially shared variables
 > can introduce data races. Or: register promotion can introduce bugs
 > in multithreaded software when compiled with optimization
 > enabled. Are there any register promotion transformations
 > implemented in gcc that can introduce data races in multithreaded
 > software ?

I expect so.  We're going to have to audit this whole enormous code
base to find them all and take them out.

Note that some of these optimizations have been around since gcc 3.4.

 > This is very important information both for kernel developers and
 > for developers of multithreaded userspace applications.

 > Another conclusion from the cited text is that in contrast with
 > what was stated before on the gcc mailing list, it is not required
 > to declare thread-shared variables volatile if that thread-shared
 > data is consistently protected by calls to locking functions.

Well, let's be clear: ISO 9899:1999 doesn't say so, but the proposed
standard language does.

Andrew.

-- 
Red Hat UK Ltd, Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, UK
Registered in England and Wales No. 3798903
