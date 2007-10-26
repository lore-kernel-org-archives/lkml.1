Return-Path: <linux-kernel-owner+w=401wt.eu-S1761635AbXJZSir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761635AbXJZSir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764506AbXJZSiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:38:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43374 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763933AbXJZSiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:38:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] proc: Fix proc_kill_inodes to kill dentries on all proc superblocks
References: <m1y7dp22d4.fsf@ebiederm.dsl.xmission.com>
	<alpine.LFD.0.999.0710261105440.30120@woody.linux-foundation.org>
Date: Fri, 26 Oct 2007 12:36:53 -0600
In-Reply-To: <alpine.LFD.0.999.0710261105440.30120@woody.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 26 Oct 2007 11:06:52 -0700 (PDT)")
Message-ID: <m1d4v12056.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, 26 Oct 2007, Eric W. Biederman wrote:
>> 
>> It appears we overlooked support for removing generic proc files
>> when we added support for multiple proc super blocks.  Handle
>> that now.
>
> There seems to be more users of "proc_mnt" out there. proc_flush_task, 
> anyone?

Yes.  I've seen those and I do have some patches in my queue
to address those.  Technically none of those causes us to
do the wrong thing in the presence of multiple proc superblocks,
by the usage of proc_mnt.  It still looks worth it to see
if we can kill all of the users of proc_mnt.

proc_flush_task is technically ok in it's usage of proc_mnt.
It is just using it as what appears to be an unnecessary optimization.
However the added complexity is currently hiding another bug.
We call proc_flush_task_mnt with the wrong arguments.
Further I haven't convinced myself the call to pid_ns_release_proc
does not have some strange race in there, although there is
nothing obviously wrong there.

Eric
