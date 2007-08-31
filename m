Return-Path: <linux-kernel-owner+w=401wt.eu-S932657AbXHaFjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657AbXHaFjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 01:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXHaFi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 01:38:57 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:32987 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbXHaFi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 01:38:56 -0400
X-Sasl-enc: 35mJTe78Km9LjsGcvH5V003Fh3h0WFveb1pnntsq3piQ 1188538732
Date: Fri, 31 Aug 2007 13:38:46 +0800 (WST)
From: Ian Kent <raven@themaw.net>
To: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Frank van Maarseveen <frankvm@frankvm.com>,
       Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, Ion Badulescu <ionut@badula.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: recent nfs change causes autofs regression
In-Reply-To: <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708311317260.8223@raven.themaw.net>
References: <000701c7eb49$cff701c0$6fe50540$@com>  <1188513433.6626.24.camel@heimdal.trondhjem.org>
  <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org>
 <1188535485.6626.85.camel@heimdal.trondhjem.org>
 <alpine.LFD.0.999.0708302157470.25853@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Linus Torvalds wrote:
> 
> 
> On Fri, 31 Aug 2007, Trond Myklebust wrote:
> > 
> > It did not. The previous behaviour was to always silently override the
> > user mount options.
> 
> ..so it still worked for any sane setup, at least.
> 
> You broke that. Hua gave good reasons for why he cannot use the current 
> kernel. It's a regression.
> 
> In other words, the new behaviour is *worse* than the behaviour you 
> consider to be the incorrect one.
> 

This all came about due to complains about not being able to mount the 
same server file system with different options, most commonly ro vs. rw 
which I think was due to the shared super block changes some time ago. 
And, to some extent, I have to plead guilty for not complaining enough 
about this default in the beginning, which is basically unacceptable for 
sure.

We have seen breakage in Fedora with the introduction of the patches and 
this is typical of it. It also breaks amd and admins have no way of 
altering this that I'm aware of (help us here Ion).

I understand Tronds concerns but the fact remains that other Unixs allow 
this behaviour but don't assert cache coherancy and many sysadmin don't 
realize this. So the broken behavior is expected to work and we can't 
simply stop allowing it unless we want to attend a public hanging with us 
as the paticipants.

There is no question that the new behavior is worse and this change is 
unacceptable as a solution to the original problem.

I really think that reversing the default, as has been suggested, 
documenting the risk in the mount.nfs man page and perhaps issuing a 
warning from the kernel is a better way to handle this. At least we will 
be doing more to raise public awareness of the issue than others.

Ian
