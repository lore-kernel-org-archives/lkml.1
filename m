Return-Path: <linux-kernel-owner+w=401wt.eu-S935514AbZJOUj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935514AbZJOUj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 16:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935494AbZJOUj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 16:39:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11253 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935478AbZJOUjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 16:39:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=bDQYyuagShzak1Tlc5fz+ZKAhZvBWfb25ZqTmwUxow8F6lKHhrmvxxllKwM+sefPa
	YKnK+GauI3l0IRPZEkTmA==
Date: Thu, 15 Oct 2009 13:38:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frans Pop <elendil@planet.nl>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic
In-Reply-To: <200910151613.10334.elendil@planet.nl>
Message-ID: <alpine.DEB.1.00.0910151324481.17578@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <200910150143.18755.elendil@planet.nl> <alpine.DEB.1.00.0910150029450.10850@chino.kir.corp.google.com> <200910151613.10334.elendil@planet.nl>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Frans Pop wrote:

> > And that's why I suggested, in addition to my patch, that we allow "make
> > LOCALVERSION=" to override the `+' suffix for kernels compiled without
> > CONFIG_LOCALVERSION_AUTO.  In your examples, they would pass
> > LOCALVERSION=-2-amd64 or LOCALVERSION=-43.fc11.i586, respectively, to
> > make.
> 
> Who says they are using LOCALVERSION to add the suffix?
> 

You would prefer that CONFIG_LOCALVERSION overrides the `+' when 
CONFIG_LOCALVERSION_AUTO is disabled?

> The thing is that you are assuming people do things in a certain way and 
> your patches will break existing naming schemes for anybody who happens to 
> do things slightly differently. My proposal offered full backwards 
> compatibility for people who know what they are doing.
> 

Your proposal doesn't work because the context (the state of an 
environment variable at build, in your case) isn't known to interpret the 
version string.

The point is that you should be able to look at a kernel version without 
asking for enviornment variables or configs and know what kernel is 
running.  That's not always going to be valid, someone can make additional 
changes outside of a git respository and use it, but the net impact is 
that versions have become much more descriptive from a large majority of 
the general population that posts to linux-kernel, git users, and it's 
going to save a lot of time.

> > No, it actually makes things much worse because now instead of forcing
> > the user to post his .config to determine the setting of
> > CONFIG_LOCALVERSION_AUTO to intepret the version string, it forces them
> > to recall what their KBUILD_NO_LOCALVERSION_EXTRA environment variable
> > happened to be at the time of build.
> 
> As I've already said, I think that build variable is sufficiently obscure 
> that I expect it will only be used by people who know what they are doing.
> 

Do you really expect people to email bug reports and say "btw, I compiled 
with KBUILD_NO_LOCALVERSION_EXTRA because I thought it looked prettier, 
this is actually Linus' git at a3ccf63"?

> And I can only repeat that even with your patch you will never get 100% 
> coverage. People who really don't want the "+" will simply patch it out. 
> Why not give them a clean way to avoid it?
> 

Sigh, this is becoming ridiculous.  If you're doing development and have 
revisions beyond a tagged release, then why would you want the version to 
still be "v2.6.32-rc4" without giving it a descriptive name of your own?  
Why wouldn't you use LOCALVERSION=-slub_merge, for example, to describe 
what the kernel was?  The scenario you're describing is where everyone has 
100 different v2.6.32-rc4 kernels sitting around because they've disabled 
CONFIG_LOCALVERSION_AUTO and aren't able to tell the difference between 
them.  That's just a poor work environment.

 [ I can understand if you frequently do build and boot testing, but even 
   then you can get rid of that `+' very easily by giving it a descriptive 
   LOCALVERSION= name if `+' causes you so much grief. ]
