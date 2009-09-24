Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbZIXRoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbZIXRoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZIXRoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:44:08 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:46279 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZIXRoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:44:07 -0400
Message-ID: <4ABBAFE5.2000704@librato.com>
Date: Thu, 24 Sep 2009 13:44:05 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
References: <20090924165548.GA16586@us.ibm.com>
In-Reply-To: <20090924165548.GA16586@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sukadev Bhattiprolu wrote:
> === NEW CLONE() SYSTEM CALL:
> 
> To support application checkpoint/restart, a task must have the same pid it
> had when it was checkpointed.  When containers are nested, the tasks within
> the containers exist in multiple pid namespaces and hence have multiple pids
> to specify during restart.
> 
> This patchset implements a new system call, clone2() that lets a process
> specify the pids of the child process.
> 
> Patches 1 through 6 are helper patches, needed for choosing a pid for the
> child process.
> 
> Patch 8 defines a prototype of the new system call. Patch 9 adds some
> documentation on the new system call, some/all of which will eventually
> go into a man page.
> 

[...]

> 
> Based on these requirements and constraints, we explored a couple of system
> call interfaces (in earlier versions of this patchset) and currently define
> the system call as:
> 
> 	struct clone_struct {
> 		u64 flags;
> 		u64 child_stack;
> 		u32 nr_pids;
> 		u32 parent_tid;
> 		u32 child_tid;

So @parent_tid and @child_tid are pointers to userspace memory and
require 'u64' (and it won't hurt to make @reserved1 a 'u64' as well).

> 		u32 reserved1;
> 		u64 reserved2;
> 	};
> 

Also, for forward/backward compatibility, explicitly state in the
documentation, and enforce in the kernel, that flags which are not
defined must not be set, and that reserved{1,2} must remain 0.

> 	sys_clone2(struct clone_struct __user *cs, pid_t __user *pids)
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Otherwise, looks great.

Oren.

