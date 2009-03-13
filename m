Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbZCMPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbZCMPru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZCMPrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:47:40 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:42020 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbZCMPrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:47:39 -0400
Message-ID: <49BA8013.3030103@free.fr>
Date: Fri, 13 Mar 2009 16:47:31 +0100
From: Cedric Le Goater <legoater@free.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, mingo@elte.hu,
       mpm@selenic.com, tglx@linutronix.de, torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
References: <20090211141434.dfa1d079.akpm@linux-foundation.org> <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226155755.GA1456@x200.localdomain> <20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr> <20090312145311.GC12390@us.ibm.com>
In-Reply-To: <20090312145311.GC12390@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> No, what you're suggesting does not suffice.

probably. I'm still trying to understand what you mean below :)

Man, I hate these hierarchicals pid_ns. one level would have been enough, 
just one vpid attribute in 'struct pid*'
 
> Call
> (5591,3,1) the task knows as 5591 in the init_pid_ns, 3 in a child pid
> ns, and 1 in grandchild pid_ns created from there.  Now assume we are
> checkpointing tasks T1=(5592,1), and T2=(5594,3,1).
> 
> We don't care about the first number in the tuples, so they will be
> random numbers after the recreate. 

yes.

> But we do care about the second numbers.  

yes very much and we need a way set these numbers in alloc_pid()

> But specifying CLONE_NEWPID while recreating the process tree
> in userspace does not allow you to specify the 3 in (5594,3,1).

I haven't looked closely at hierarchical pid namespaces but as we're
using a an array of pid indexed but the pidns level, i don't see why 
it shouldn't be possible. you might be right.

anyway, I think that some CLONE_NEW* should be forbidden. Daniel should
send soon a little patch for the ns_cgroup restricting the clone flags
being used in a container.

Cheers,

C.

> Or are you suggesting that you'll do a dummy clone of (5594,2) so that
> the next clone(CLONE_NEWPID) will be expected to be (5594,3,1)?
> 
> -serge

