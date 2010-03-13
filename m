Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab0CMW72 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 17:59:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab0CMW70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 17:59:26 -0500
Date: Sat, 13 Mar 2010 14:57:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in
 commit a2db6842873c8e5a70652f278d469128cb52db70
In-Reply-To: <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz>
Message-ID: <alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org>
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net> <alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org> <alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Mar 2010, Jiri Kosina wrote:
> 
> Well, the special initialization shouldn't be needed for all the 68 cases 
> as far as I can see. It's needed only for dynamically allocated sysfs 
> attributes, the static ones are fine.

So does anybody have a 'grep' for it?

Because we sure as hell don't want to find them one by one, especially 
since this thing only shows up in a fairly rare configuration (most people 
do _not_ enable lockdep).

So that commit really _is_ broken. I'm seriously going to just revert it 
if the plan of action is nothing better than "wait for people to report 
yet another missed conversion". This is _not_ how we convert users.

			Linus
