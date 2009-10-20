Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbZJUAjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbZJUAjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 20:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZJUAjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 20:39:06 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44675 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbZJUAjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 20:39:04 -0400
Date: Tue, 20 Oct 2009 09:09:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, randy.dunlap@oracle.com, arnd@arndb.de,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091020140917.GA2145@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com> <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdiad9jd.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Matt Helsley <matthltc@us.ibm.com> writes:
> 
> > On Mon, Oct 19, 2009 at 05:47:43PM -0400, Oren Laadan wrote:
> >> 
> >> 
> >> Daniel Lezcano wrote:
> >> > Sukadev Bhattiprolu wrote:
> >> >> Daniel Lezcano [daniel.lezcano@free.fr] wrote:
> >> >>   
> >> >>> Sukadev Bhattiprolu wrote:
> >> >>>     
> >> >>>> Subject: [RFC][v8][PATCH 0/10] Implement clone3() system call
> >> >>>>
> >
> > <snip>
> >
> >> > Another point. It's another way to extend the exhausted clone  flags as 
> >> > the cloneat can be called as a compatibility way, with cloneat(getpid(), 
> >> > 0, ... )
> >> 
> >> Which is what the proposed new clone_....() does.
> >
> > Just to be clear -- Suka's proposing to extend the clone flags. However I
> > don't believe reusing the "pid" parameters as Daniel seemed to suggest
> > was ever part of Suka's proposed changes.
> >
> > <snip>
> >
> >> > I don't really see a difference between sys_restart(pid_t pid , int fd, 
> >> > long flags) where pid_t is the topmost in the hierarchy, fd is a file 
> >> > descriptor to a structure "pid_t * + struct clone_args *" and flags is 
> >> > "PROCTREE".
> >
> > I think the difference has to do with keeping the code maintainable.
> >
> > Clone creates the process so it's already involved in allocating and
> > assigning pids to the new task. Switching pids at sys_restart() would 
> > add another point in the code where pids are allocated and assigned.
> > This suggests we may have to worry about introducing new obscure races
> > for anyone who's working on the pid allocator to be careful of. At
> > least when all the code is "localized" to the clone paths we can be
> > reasonably certain of proper maintenance.
> >
> > <snip>
> >
> >> I really really really hope we can settle down on *a* name,
> >> *any* name, and move forward. Amen.
> >
> > clone3() seemed to be the leading contender from what I've read so far.
> > Does anyone still object to clone3() after reading the whole thread?
> 
> I object to what clone3() is.  The name is not particularly interesting.
> 
> The sanity checks for assigning pids are missing and there is a todo
> about it.  I am not comfortable with assigning pids to a new process
> in a pid namespace with other processes user space processes executing
> in it.
> 
> How we handle a clone extension depends critically on if we want to
> create a processes for restart in user space or kernel space.
> 
> Could some one give me or point me at a strong case for creating the
> processes for restart in user space?
> 
> The pid assignment code is currently ugly.  I asked that we just pass
> in the min max pid pids that already exist into the core pid
> assignment function and a constrained min/max that only admits a
> single pid when we are allocating a struct pid for restart.  That was
> not done and now we have a weird abortion with unnecessary special cases.

I asked you (I believe twice) to clarify how on earth you meant for
that to be done for hierarchical pid namespaces (a task being restored
which needs two of it's 4 pids specified), and you did not reply.

Did you mean for it to be done through procfiles?  If so, does the
task have to keep multiple /proc mounts around, one for each
pidns hierarchy in which it needs to specify a pid?  Or did you have
another idea in mind?  A single procfile into which multiple pids can
be specified in a list?  A completely different interface?

Or do you mean for this to be done only from the kernel?

thanks,
-serge
