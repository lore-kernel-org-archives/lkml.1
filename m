Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZIXUP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZIXUP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbZIXUPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:15:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36479 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbZIXUPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:15:55 -0400
Date: Thu, 24 Sep 2009 13:15:17 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oren Laadan <orenl@librato.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
Message-ID: <20090924201517.GA24786@us.ibm.com>
References: <20090924165548.GA16586@us.ibm.com> <4ABBAFE5.2000704@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABBAFE5.2000704@librato.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan [orenl@librato.com] wrote:
| 
| 
| Sukadev Bhattiprolu wrote:
| > Based on these requirements and constraints, we explored a couple of system
| > call interfaces (in earlier versions of this patchset) and currently define
| > the system call as:
| > 
| > 	struct clone_struct {
| > 		u64 flags;
| > 		u64 child_stack;
| > 		u32 nr_pids;
| > 		u32 parent_tid;
| > 		u32 child_tid;
| 
| So @parent_tid and @child_tid are pointers to userspace memory and
| require 'u64' (and it won't hurt to make @reserved1 a 'u64' as well).

No, as Arnd pointed out, we already pass in a pointer to 'struct clone_struct'
and the kernel can use that pointer to copy the parent and child tids.

| 
| > 		u32 reserved1;
| > 		u64 reserved2;
| > 	};
| > 
| 
| Also, for forward/backward compatibility, explicitly state in the
| documentation, and enforce in the kernel, that flags which are not
| defined must not be set, and that reserved{1,2} must remain 0.

Good idea. Will do.

Thanks,

Sukadev
