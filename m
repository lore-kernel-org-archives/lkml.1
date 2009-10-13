Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbZJMX1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbZJMX1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758025AbZJMX1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:27:00 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45323 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbZJMX07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:26:59 -0400
Date: Tue, 13 Oct 2009 16:27:36 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091013232736.GA24392@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013205015.1ED524F7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013205015.1ED524F7@magilla.sf.frob.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath [roland@redhat.com] wrote:
| Some userland debugging things and so forth like to look at the clone_flags
| argument, so that is kept simpler for them if it stays in a register
| (i.e. its own argument) rather than a user pointer fetch for that argument.
| Any problem with:
| 
| 	sys_clone3(unsigned long clone_flags,
| 		   struct clone_struct __user *cs, pid_t __user *pids)
| 
| ?

My only concern is the support of 64-bit clone flags on 32-bit architectures.
We would need an additional register/parameter, clone_flags_high ?  Also,
hopefully we won't need more than 64 flags, but if we do, the plan AFACIT,
was that we could use one of the reserved fields.

| 
| That also has the side benefit that instead of non-ia64 users forever
| asking, "Why is it clone3 when there is no clone2?" you can instead pretend
| that it follows the "clone3 because it takes three arguments" convention. ;-)
| 
| Btw, IMHO "struct foo_struct" is one of the lamest naming conventions ever.
| How about "struct clone_args"?

Sure :-) In earlier version of patches I had mixed up clone_struct and
clone_arg in comments/descriptions and cleaned up in this version. 
| 
| Also, if you were to replace:
| 
| 		u64 child_stack;
| 
| with:
| 
| 		u64 child_stack_base;
| 		u64 child_stack_size;
| 
| and use in sys_clone3 (for most arch's):
| 
| 	child_stack_ptr = kcs.child_stack_base + kcs.child_stack_size;
| 
| then the same clone3 interface would cover ia64 as well.

Ok

| 
| 
| Thanks,
| Roland
