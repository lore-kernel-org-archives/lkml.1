Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZIXWGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZIXWGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZIXWGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:06:53 -0400
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:34554 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZIXWGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:06:52 -0400
Message-ID: <4ABBED72.9080901@librato.com>
Date: Thu, 24 Sep 2009 18:06:42 -0400
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
References: <20090924165548.GA16586@us.ibm.com> <4ABBAFE5.2000704@librato.com> <20090924201517.GA24786@us.ibm.com>
In-Reply-To: <20090924201517.GA24786@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sukadev Bhattiprolu wrote:
> Oren Laadan [orenl@librato.com] wrote:
> | 
> | 
> | Sukadev Bhattiprolu wrote:
> | > Based on these requirements and constraints, we explored a couple of system
> | > call interfaces (in earlier versions of this patchset) and currently define
> | > the system call as:
> | > 
> | > 	struct clone_struct {
> | > 		u64 flags;
> | > 		u64 child_stack;
> | > 		u32 nr_pids;
> | > 		u32 parent_tid;
> | > 		u32 child_tid;
> | 
> | So @parent_tid and @child_tid are pointers to userspace memory and
> | require 'u64' (and it won't hurt to make @reserved1 a 'u64' as well).
> 
> No, as Arnd pointed out, we already pass in a pointer to 'struct clone_struct'
> and the kernel can use that pointer to copy the parent and child tids.

In this form, you place a constraints on where userspace may
place the {parent,child}_tid variable, and require that this
particular clone_struct remain valid memory in the parent until
the child terminates.  This may break existing programs that
use this (threads libraries ?)

Oren.

> 
> | 
> | > 		u32 reserved1;
> | > 		u64 reserved2;
> | > 	};
> | > 
> | 
> | Also, for forward/backward compatibility, explicitly state in the
> | documentation, and enforce in the kernel, that flags which are not
> | defined must not be set, and that reserved{1,2} must remain 0.
> 
> Good idea. Will do.
> 
> Thanks,
> 
> Sukadev
