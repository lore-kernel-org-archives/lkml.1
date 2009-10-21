Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZJUS0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZJUS0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbZJUS0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:26:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39892 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbZJUS0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:26:09 -0400
Date: Wed, 21 Oct 2009 11:27:15 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Message-ID: <20091021182714.GA12955@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045556.GJ28435@us.ibm.com> <20091019213636.GB1482@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019213636.GB1482@ucw.cz>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek [pavel@ucw.cz] wrote:
| Hi!
| 
| > This gives a brief overview of the clone3() system call.  We should
| 
| Thanks!
| 
| > eventually describe more details in existing clone(2) man page or in
| > a new man page.
| 
| M. Kerrisk (see MAINTAINERS) maintains man pages...

Ok. I copied linux-api and M. Kerrisk is looking at this patchset.

| 
| > Changelog[v8]:
| > 	- clone2() is already in use in IA64. Rename syscall to clone3()
| ...
| > Index: linux-2.6/Documentation/clone2
| > ===================================================================
| > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
| > +++ linux-2.6/Documentation/clone2	2009-10-12 19:54:38.000000000 -0700
| 
| clone3?

Ah, yes, will fix.

| 
| > +struct clone_struct {
| > +	u64 flags;
| > +	u64 child_stack;
| 
| u64 seems wrong  on 32 bit platforms. ulong?
| 
| > +	u32 nr_pids;
| 
| So nr_pids is either 1 or 2?

No. With pid namespaces, which can be nested to arbitrary levels, each
process has several pid numbers - one in its own namespace and one in
each ancestor pid namespaces.

nr_pids specifies the number of pids the user cares about. IOW, if you
checkpoint a process that is 3 levels below the init-pid-ns, and you
care about the pids for those three levels, you would pass in an
array of 4 pid_ts and nr_pids would be 4.

| 
| > +	u32 reserved1;
| > +	u64 parent_tid;
| > +	u64 child_tid;
| > +	u64 reserved2;
| > +};
| > +
| 
| 
| > +	See CLONE_NEWPID section of clone(2) man page for details about pid
| > +	namespaces.
| > +
| > +	The order pids in @pids corresponds to the nesting order of pid-
| > +	namespaces, with @pids[0] corresponding to the init_pid_ns.
| 
| Ok, so I'm confused.

Hope the above note on pid-namespaces helps, if not let me know.

| 
| > +	If a pid in the @pids list is 0, the kernel will assign the next
| > +	available pid in the pid namespace, for the process.
| > +
| > +	If a pid in the @pids list is non-zero, the kernel tries to assign
| > +	the specified pid in that namespace.  If that pid is already in use
| > +	by another process, the system call fails with -EBUSY.
| ...
| > +	On failure, clone3() returns -1 and sets 'errno' to one of following
| > +	values (the child process is not created).
| 
| Inconsistent with above. Syscalls really return -ERRCODE, errno is
| glibc magic.

Ok.  Will make it consistent to say that it returns one of the error codes.
