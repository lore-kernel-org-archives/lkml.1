Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZJUAjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZJUAjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 20:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZJUAjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 20:39:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34759 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZJUAjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 20:39:05 -0400
Date: Tue, 20 Oct 2009 09:16:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091020141625.GA3645@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com> <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com> <m1iqeauyvl.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iqeauyvl.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
> The only real argument in favor of doing this in user space is greater
> flexibility.

Yyyyup.

> I can see checkpointing/restoring a single thread process
> without a pid namespace.  Anything more and you are just asking for
> trouble.
> 
> A design that weakens security.

How does it weaken security?  It requires CAP_SYS_ADMIN, and, when
targeted capabilities are added, it will require CAP_SYS_ADMIN to
only those pid namespaces in which we choose a pid.

> Increases maintenance costs.

Does it really?  It re-uses most of the existing code.  More so than
the only existing in-kernel restart code I've seen does.

> All for
> an unreliable result seems like a bad one to me.

I've personally always been on the fence as to whether we rebuild the
process tree in user-space or kernel.  And I'm still on the fence, as
nothing you've said has convinced me otherwise.

> > | The pid assignment code is currently ugly.  I asked that we just pass
> > | in the min max pid pids that already exist into the core pid
> > | assignment function and a constrained min/max that only admits a
> > | single pid when we are allocating a struct pid for restart.  That was
> > | not done and now we have a weird abortion with unnecessary special cases.
> >
> > I did post a version of the patch attemptint to implement that. As
> > pointed out in:
> >
> > 	http://lkml.org/lkml/2009/8/17/445
> >
> > we would need more checks in alloc_pidmap() to cover cases like min or max
> > being invalid or min being greater than max or max being greater than pid_max
> > etc. Those checks also made the code ugly (imo).
> 
> If you need more checks you are doing it wrong.  The code already has min
> and max values, and even a start value.  I was just strongly suggesting
> we generalize where we get the values from, and then we have not special
> cases. 

(I'm not sure whether this argument is a separate one - regarding the
implementation of choosing the pid - from the kernel-vs-userspace one
or not, so will wait for a response to my other email about your API)

thanks,
-serge
