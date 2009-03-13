Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZCMQzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZCMQzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZCMQzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:55:00 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:53983 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbZCMQy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:54:59 -0400
Message-ID: <49BA8FA5.5030003@free.fr>
Date: Fri, 13 Mar 2009 17:53:57 +0100
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
References: <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226155755.GA1456@x200.localdomain> <20090310215305.GA2078@x200.localdomain> <49B775B4.1040800@free.fr> <20090312145311.GC12390@us.ibm.com> <49BA8013.3030103@free.fr> <20090313163531.GA10685@us.ibm.com>
In-Reply-To: <20090313163531.GA10685@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Cedric Le Goater (legoater@free.fr):
>>> No, what you're suggesting does not suffice.
>> probably. I'm still trying to understand what you mean below :)
>>
>> Man, I hate these hierarchicals pid_ns. one level would have been enough, 
>> just one vpid attribute in 'struct pid*'
> 
> Well I don't mind - temporarily - saying that nested pid namespaces
> are not checkpointable.  It's just that if we're going to need a new
> syscall anyway, then why not go ahead and address the whole problem?
> It's not hugely more complicated, and seems worth it.

yes. agree. there's a thread going on that topic. i'm following it.

[ ... ] 

>> anyway, I think that some CLONE_NEW* should be forbidden. Daniel should
>> send soon a little patch for the ns_cgroup restricting the clone flags
>> being used in a container.
> 
> Uh, that feels a bit over the top.  We want to make this
> uncheckpointable (if it remains so), not prevent the whole action.
> After all I may be running a container which I don't plan on ever
> checkpointing, and inside that container running a job which i do
> want to migrate.

ok. i've been scanning the emails a bit fast. that would be fine 
and useful.

> So depending on if we're doing the Dave or the rest-of-the-world
> way :), we either clear_bit(pidns->may_checkpoint) on the parent
> pid_ns when a child is created, or we walk every task being
> checkpointed and make sure they each are in the same pid_ns.  
> Doesn't that suffice?

yes. this 'may_checkpoint' is a container level info so I wonder 
where you store it. in a cgroup_checkpoint ? sorry for jumping in 
and may be restarting some old topics of discussion.

C.
