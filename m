Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYDDOLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYDDOLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbYDDOLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:11:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50578 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbYDDOLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:11:08 -0400
Date: Fri, 4 Apr 2008 09:11:06 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: matthltc@us.ibm.com,
       Linux Containers <containers@lists.linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Devel] [RFC PATCH 0/4] Container Freezer: Reuse Suspend
	Freezer
Message-ID: <20080404141106.GA9977@sergelap.austin.ibm.com>
References: <20080403210316.397506379@us.ibm.com> <6599ad830804031649p6bbc60f3s59fb7c25a7260505@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830804031649p6bbc60f3s59fb7c25a7260505@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Thu, Apr 3, 2008 at 2:03 PM,  <matthltc@us.ibm.com> wrote:
> >
> >    * "freezer.kill"
> >
> >      writing <n> will send signal number <n> to all tasks
> >
> 
> My first thought (not having looked at the code yet) is that sending a
> signal doesn't really have anything to do with freezing, so it
> shouldn't be in the same subsystem. Maybe a separate subsystem called
> "signal"?
> 
> And more than that, it's not something that requires any particular
> per-process state, so there's no reason that the subsystem that
> provides the "kill" functionality shouldn't be able to be mounted in
> multiple hierarchies.
> 
> How about if I added support for stateless subsystems, that could
> potentially be mounted in multiple hierarchies at once? They wouldn't
> need an entry in the css set, since they have no state.
> 
> >  * Usage :
> >
> >    # mkdir /containers/freezer
> >    # mount -t container -ofreezer freezer  /containers/freezer
> >    # mkdir /containers/freezer/0
> >    # echo $some_pid > /containers/freezer/0/tasks
> >
> >  to get status of the freezer subsystem :
> >
> >    # cat /containers/freezer/0/freezer.freeze
> >    RUNNING
> >
> >  to freeze all tasks in the container :
> >
> >    # echo 1 > /containers/freezer/0/freezer.freeze
> >    # cat /containers/freezer/0/freezer.freeze
> >    FREEZING
> >    # cat /containers/freezer/0/freezer.freeze
> >    FROZEN
> 
> Could we separate this out into two files? One called "freeze" that's
> a 0/1 for whether we're intending to freeze the subsystem, and one
> called "frozen" that indicates whether it is frozen? And maybe a
> "state" file to report the RUNNING/FREEZING/FROZEN distinction in a
> human-readable way?

One thing Oren had mentioned for checkpoint/restart was having more
states - i.e. restoring, checkpointing...  So then (assuming we used
this subsys for that) we'd have more than the two files.  Which is
probably fine, just wanted to point that out.

-serge
