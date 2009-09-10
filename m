Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZIJVX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZIJVX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZIJVXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:23:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50027 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZIJVXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:23:54 -0400
Date: Thu, 10 Sep 2009 14:28:37 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v6][PATCH 8/9]: Define clone_with_pids() syscall
Message-ID: <20090910212837.GA31459@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com> <20090910061301.GG25883@us.ibm.com> <200909100931.25585.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909100931.25585.arnd@arndb.de>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann [arnd@arndb.de] wrote:
| 
| I wonder if we can avoid spreading copies of this function across
| all architectures.
| 
| Would it be possible to define it like this?

Since this is a variant of clone() and clone is listed as a PTREGSCALL(),
I pass in the pt_regs.

arch/x86/kernel/entry_32.S lists clone() under this comment:

/*
 * System calls that need a pt_regs pointer.
 */

Is there a guideline on what system calls use/need pt_regs ?

Thanks,

Suakdev

| 
| asmlinkage long
| clone_with_pids(int flags, unsigned long child_stack_base, int __user *parent_tid_ptr,
|                        int __user *child_tid_ptr, struct pid_set __user *pid_setp)
| {
| 	if (!child_stack_base) {
| 		struct pt_regs *regs;
| 
| 		regs = task_pt_regs(current);
| 		child_stack_base = user_stack_pointer(regs);
| 	}
| 
| 	return do_fork_with_pids(clone_flags, child_stack_base, 0,
| 		parent_tid_ptr, child_tid_ptr, pid_setp);
| }
