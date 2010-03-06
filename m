Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab0CFAUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 19:20:37 -0500
Received: from tango.0pointer.de ([85.214.72.216]:35962 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab0CFAUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 19:20:36 -0500
Date: Sat, 6 Mar 2010 01:20:09 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>, Kay Sievers <kay.sievers@vrfy.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 	for child processes
Message-ID: <20100306002009.GI28657@tango.0pointer.de>
References: <20100202120457.GA19605@omega>
 <20100304140822.GA458@redhat.com>
 <20100304221434.17567187@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304221434.17567187@magilla.sf.frob.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04.03.10 14:14, Roland McGrath (roland@redhat.com) wrote:

> There are a few different aspects of behavior change to think about.
> 
> 1. Who can get a SIGCHLD and wait result they weren't expecting.
> 2. Who sees some PID for getppid() when they are expecting 1.
> 3. What ps shows.
> 
> When I start thinking through what might be security issues, they are
> almost all #1 questions.  There is a hairy nest of many variations of #1
> questions.  The #2 question is pretty simple, but it also could be an issue
> for security when setuid is involved (or just correctness for any
> application).
> 
> My impression is that #3 is the only actual motivation for this feature.
> So perhaps we should consider an approach that leaves the rest of the
> semantics alone and only affects that.
> 
> Lennart, am I right that this is all you are looking for?  Does it even
> matter to you that this change the PPID that ps groks today?  How about if
> it's just an entirely new kind of assocation that ps et al can learn to
> display, and not even the traditional PPID field changes?

Uh, no. Actually it's the fact that my sub-init gets the SIGCHLD, which
I am looking for. The clean ps tree is just a side-effect.

When the sub-init gets the SIGCHLD for its "grandchildren" then we can
supervise double-forking daemons, and properly handle daemons that die
due to SIGSEGV and suchlike. 

So what I am after is the SIGCHLD for the grandparents, the clean ps
tree is kinda boring.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
