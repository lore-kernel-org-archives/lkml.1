Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZKGCZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZKGCZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 21:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbZKGCZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 21:25:21 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60075 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZKGCZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 21:25:20 -0500
Date: Fri, 6 Nov 2009 18:26:12 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: arnd@arndb.de, Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [v11][PATCH 9/9] Document clone_with_pids() syscall
Message-ID: <20091107022612.GA18039@suka>
References: <20091105053053.GA11289@us.ibm.com> <20091105054204.GI16142@us.ibm.com> <20091106183936.GA32531@us.ibm.com> <20091106201814.GA26614@count0.beaverton.ibm.com> <20091106214529.GB26614@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106214529.GB26614@count0.beaverton.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley [matthltc@us.ibm.com] wrote:
| > If userspace passes an array with n pids and there are k namespace levels
| > then clone_with_pids() makes sure that the kernel sees a pid array like:
| > 
| > index	  0     ... k - (n + 1)        ...          k - 1
| > 	+-----------------------+-------------------------+
| > pid_t	| 0 ..................0 | <copied from userspace> |
| > 	+-----------------------+-------------------------+
| 
| (diagram assumes n != k. If n == k then pids[0] is the pid desired
| in the initial namespace..)

True.

Also I was not sure if we should prevent choosing pids in ancestor containers.
since a process is not even supposed to know of ancestor namespaces. Is there
a need for choosing pids in those namespaces.

| 
| > 
| > So even though the order is different from choosepid() the calling
| > task still doesn't need to know its pidns level. Of course, just
| > like choosepid(), n <= k or userspace will get EINVAL.
| 
| Forgot to mention that I prefer the way choosepid orders the pids.
| It's not inspired by the way that the kernel implements pid namespaces
| and has more to do with the way userspace sees things (IMHO).

Hmm, In general we C/R a descendant container. So the way userspace
sees it at that point is "what are the pids of this process in my current
and in any descendant namespaces". IOW, the pid of container from which
we checkpoint seems more interesting first - right ?  If so, the pids[]
are better ordered from older namespace to younger namespace ?

| I don't know if it makes more sense to change clone_with_pids() or have
| [e]glibc wrappers swap the array contents.
| 
| Cheers,
| 	-Matt Helsley
| _______________________________________________
| Containers mailing list
| Containers@lists.linux-foundation.org
| https://lists.linux-foundation.org/mailman/listinfo/containers
