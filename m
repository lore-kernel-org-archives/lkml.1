Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZHMNdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZHMNdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 09:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZHMNdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 09:33:31 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:51879 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZHMNda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:33:30 -0400
Date: Thu, 13 Aug 2009 08:32:56 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC][v4][PATCH 0/7] clone_with_pids() system call
Message-ID: <20090813133256.GA30731@us.ibm.com>
References: <20090807061103.GA19343@us.ibm.com> <m1vdks5qc8.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdks5qc8.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
> 
> > === NEW CLONE() SYSTEM CALL:
> >
> > To support application checkpoint/restart, a task must have the same pid it
> > had when it was checkpointed.  When containers are nested, the tasks within
> > the containers exist in multiple pid namespaces and hence have multiple pids
> > to specify during restart.
> >
> > This patchset implements a new system call, clone_with_pids() that lets a
> > process specify the pids of the child process.
> >
> > Patches 1 through 5 are helpers and we believe they are needed for application
> > restart, regardless of the kernel implementation of application restart.
> 
> I'm not very impressed.
> 
> - static int alloc_pidmap(struct pid_namespace *pid_ns)
> + static int alloc_pidmap(struct pid_namespace *pid_ns, int pid_max, int last_pid)

Regardless of Suka's patch, note that I did send you a patch back on march 21
to make pid_max a pidns property.  I suspect that's still something we
want. 

-serge
