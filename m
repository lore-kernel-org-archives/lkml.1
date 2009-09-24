Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZIXXVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZIXXVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbZIXXVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:21:37 -0400
Received: from smtp201.iad.emailsrvr.com ([207.97.245.201]:45970 "EHLO
	smtp201.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZIXXVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:21:37 -0400
Message-ID: <4ABBFE77.30402@librato.com>
Date: Thu, 24 Sep 2009 19:19:19 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
References: <20090924165548.GA16586@us.ibm.com> <20090924201517.GA24786@us.ibm.com> <4ABBED72.9080901@librato.com> <200909250021.03535.arnd@arndb.de>
In-Reply-To: <200909250021.03535.arnd@arndb.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnd Bergmann wrote:
> On Friday 25 September 2009, Oren Laadan wrote:
>> In this form, you place a constraints on where userspace may
>> place the {parent,child}_tid variable, and require that this
>> particular clone_struct remain valid memory in the parent until
>> the child terminates.  This may break existing programs that
>> use this (threads libraries ?)
> 
> No existing program uses sys_clone2, and the kernel function
> may well differ from the user space calling conventions, which
> are not bound by the six-argument limitation.
> 
> So a clone2 library call could set up the structure with the
> arguments to the real syscall, call into the kernel and
> copy the output data back into the pointers it was given by
> the user.

That may work well for parent_tid, however child_tid is also
kept on the task_struct and written to when the child exits,
and there is no explicit user-space wrapper on that.

Also, I may be mistaken, but I thought that the idea of these
was that the kernel writes them to user space, so other threads
may see them quickly, _before_ the parent returns to userspace;
otherwise, the parent (at the library) could himself copy the
return value.

Oren.

