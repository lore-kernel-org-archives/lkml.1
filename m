Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYARIam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYARIam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYARIaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:30:35 -0500
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:43842 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbYARIae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:30:34 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Giacomo Catenazzi <cate@cateee.net>
Subject: Re: Why is the kfree() argument const?
Date: Fri, 18 Jan 2008 00:30:29 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clameter@sgi.com, penberg@cs.helsinki.fi
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org> <47905A95.4030500@cateee.net>
In-Reply-To: <47905A95.4030500@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801180030.30801.vlobanov@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008 11:51:49 pm Giacomo Catenazzi wrote:
> Linus Torvalds wrote:
> > No, I'm saying that "const" has absolutely *zero* meaning on writes to an
> > object through _other_ pointers (or direct access) to the object.
>
> Hints: "restrict" is the C99 keyword for such requirement (or better
> "const restrict")

The restrict keyword controls aliasing, to be exact. And I'm skeptical that 
inserting const there would do anything at all.

> BTW I think C use non const free as a BIG warning about not to be
> to "smart" on optimization.

I must ask what relationship you think the const keyword has to compiler 
optimizations. I know of none, and I've yet to see that keyword cause any 
difference in the resulting assembly. It forces you to make your code clean 
and well-structured, but that's about it.

Of course, it would be an interesting experiment to potentially redefine the 
const keyword to have stronger semantics, such as having the compiler assume 
that a function taking a const pointer argument will not modify the memory 
the pointer points to, and thus saving itself a memory load in the caller 
after the function executes, as long as the data is not global. I imagine 
that this would lead to some simple and measurable optimizations, all the 
while (this is where I get into hand-waving territory) breaking a minimum 
amount of code in current existence.

But that is emphatically not how C is currently defined, and you're basically 
inventing an entirely new language... C2009 perhaps? :-)

-- Vadim Lobanov
