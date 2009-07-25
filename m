Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbZGYQuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbZGYQuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZGYQuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:50:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbZGYQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:50:09 -0400
Date: Sat, 25 Jul 2009 09:49:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Jones <davej@redhat.com>
cc: Ian Lance Taylor <iant@google.com>, Frans Pop <elendil@planet.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       barryn@pobox.com, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 13012] 2.6.28.9 causes init to segfault on Debian etch;
 2.6.28.8 OK
In-Reply-To: <20090725032343.GA20841@redhat.com>
Message-ID: <alpine.LFD.2.01.0907250944570.3960@localhost.localdomain>
References: <200907100928.07369.elendil@planet.nl> <200907101659.31813.elendil@planet.nl> <alpine.LFD.2.01.0907121058040.3552@localhost.localdomain> <m3k52d1775.fsf@google.com> <20090725032343.GA20841@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Jul 2009, Dave Jones wrote:
> 
> Is it worth fixing these up, with diffs like the below ?

Historically, when we fix up bugs like this, it causes more bugs than it 
fixes.

It needs _really_ careful people, and people who really understand how C 
type rules work. Stuff that looks obvious often is not, and basing a large 
part of the patch on a compiler warning is a _very_ weak reason for 
something that is more than just syntactic.

And the problem is, nobody can judge the patch from the diff. So it gets 
absolutely zero review, until the day when somebody notices that the 
unsigned version is a bug.

I'd suggest that the rule should be:

 - if you can use -U30 and show all uses, so that people can actually look 
   at the patch and see what it _causes_ (ie not just the "we change 'i' 
   to 'unsigned'", but also the "this is where 'i' gets used, and 
   'unsigned' is right"), then we can apply it.

 - none of the patches go through a 'trivial' tree, or come from newbies 
   that think this is a good way to get involved.

Is it worth it at that point? I dunno.

		Linus
