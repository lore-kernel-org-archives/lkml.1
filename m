Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZHJPHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZHJPHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 11:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZHJPHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 11:07:32 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35132 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZHJPHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 11:07:31 -0400
Date: Mon, 10 Aug 2009 10:07:12 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com
Subject: Re: [RFC][v4][PATCH 7/7]: Define clone_with_pids syscall
Message-ID: <20090810150712.GA20358@us.ibm.com>
References: <20090807061103.GA19343@us.ibm.com> <20090807061517.GG20672@us.ibm.com> <20090810145425.GA1378@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810145425.GA1378@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Machek (pavel@ucw.cz):
> > Unlike clone(), clone_with_pids() needs CAP_SYS_ADMIN, at least for now, to
> > prevent unprivileged processes from misusing this interface.
> > 
> > Call clone_with_pids as follows:
> > 
> > 	pid_t pids[] = { 0, 77, 99 };
> > 	struct pid_set pid_set;
> > 
> > 	pid_set.num_pids = sizeof(pids) / sizeof(int);
> > 	pid_set.pids = &pids;
> > 
> > 	syscall(__NR_clone_with_pids, flags, stack, NULL, NULL, NULL, &pid_set);
> > 
> > If a target-pid is 0, the kernel continues to assign a pid for the process in
> > that namespace. In the above example, pids[0] is 0, meaning the kernel will
> > assign next available pid to the process in init_pid_ns. But kernel will assign
> > pid 77 in the child pid namespace 1 and pid 99 in pid namespace 2. If either
> > 77 or 99 are taken, the system call fails with -EBUSY.
> > 
> > If 'pid_set.num_pids' exceeds the current nesting level of pid namespaces,
> > the system call fails with -EINVAL.
> 
> Does it make sense to set the pid in anything but innermost container?

Yup, we might be restarting an app using a nested pid namespace, in which
case restart would specify pids for 2 (or more) of the innermost containers.

thanks,
-serge
