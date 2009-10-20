Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbZJTAve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbZJTAve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZJTAvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:51:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:59488 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbZJTAvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:51:32 -0400
Date: Mon, 19 Oct 2009 17:51:25 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Oren Laadan <orenl@librato.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091020005125.GG27627@count0.beaverton.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADCDE7F.4090501@librato.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 05:47:43PM -0400, Oren Laadan wrote:
> 
> 
> Daniel Lezcano wrote:
> > Sukadev Bhattiprolu wrote:
> >> Daniel Lezcano [daniel.lezcano@free.fr] wrote:
> >>   
> >>> Sukadev Bhattiprolu wrote:
> >>>     
> >>>> Subject: [RFC][v8][PATCH 0/10] Implement clone3() system call
> >>>>

<snip>

> > Another point. It's another way to extend the exhausted clone  flags as 
> > the cloneat can be called as a compatibility way, with cloneat(getpid(), 
> > 0, ... )
> 
> Which is what the proposed new clone_....() does.

Just to be clear -- Suka's proposing to extend the clone flags. However I
don't believe reusing the "pid" parameters as Daniel seemed to suggest
was ever part of Suka's proposed changes.

<snip>

> > I don't really see a difference between sys_restart(pid_t pid , int fd, 
> > long flags) where pid_t is the topmost in the hierarchy, fd is a file 
> > descriptor to a structure "pid_t * + struct clone_args *" and flags is 
> > "PROCTREE".

I think the difference has to do with keeping the code maintainable.

Clone creates the process so it's already involved in allocating and
assigning pids to the new task. Switching pids at sys_restart() would 
add another point in the code where pids are allocated and assigned.
This suggests we may have to worry about introducing new obscure races
for anyone who's working on the pid allocator to be careful of. At
least when all the code is "localized" to the clone paths we can be
reasonably certain of proper maintenance.

<snip>

> I really really really hope we can settle down on *a* name,
> *any* name, and move forward. Amen.

clone3() seemed to be the leading contender from what I've read so far.
Does anyone still object to clone3() after reading the whole thread?

Cheers,
	-Matt Helsley
