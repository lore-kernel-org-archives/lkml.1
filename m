Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZJPTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZJPTWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZJPTWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:22:19 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:39355 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZJPTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:22:18 -0400
Message-ID: <4AD8C7E4.9000903@free.fr>
Date: Fri, 16 Oct 2009 21:22:12 +0200
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, Louis.Rilling@kerlabs.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <20091013044925.GA28181@us.ibm.com>
In-Reply-To: <20091013044925.GA28181@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
> Subject: [RFC][v8][PATCH 0/10] Implement clone3() system call
>
> To support application checkpoint/restart, a task must have the same pid it
> had when it was checkpointed.  When containers are nested, the tasks within
> the containers exist in multiple pid namespaces and hence have multiple pids
> to specify during restart.
>
> This patchset implements a new system call, clone3() that lets a process
> specify the pids of the child process.
>
> Patches 1 through 7 are helper patches, needed for choosing a pid for the
> child process.
>
> PATCH 9 defines a prototype of the new system call. PATCH 10 adds some
> documentation on the new system call, some/all of which will eventually
> go into a man page.
>   

Sorry for jumping so late in the discussion and for having maybe my
remarks pointless...

If this syscall is only for checkpoint / restart, why this shouldn't be
used with a future generic sys_restart syscall ?
Otherwise, shouldn't be more convenient to have something usable for
everyone, let's say:

cloneat(pid_t pid, pid_t desiredpid, ...);

Where 'desiredpid' is a hint of for the kernel for the pid to be
allocated (zero means the kernel will choose one for us) and the newly
allocated task is the son of 'pid'.
That looks more consistent with the "<syscall>at" family, 'openat',
'faccessat', 'readlinkat', etc ... and usable for something else than
the checkpoint / restart.

Thanks
  -- Daniel

