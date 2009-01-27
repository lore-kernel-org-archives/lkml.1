Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZA0Nk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZA0Nk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZA0Nks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:40:48 -0500
Received: from kandzendo.ru ([195.178.208.66]:34897 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZA0Nks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:40:48 -0500
Date: Tue, 27 Jan 2009 16:40:38 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090127134038.GA18119@ioremap.net>
References: <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262325320.13157@chino.kir.corp.google.com> <20090127164238.D479.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com> <20090127093105.GB2646@ioremap.net> <alpine.DEB.2.00.0901270134360.20070@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901270134360.20070@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David.

On Tue, Jan 27, 2009 at 01:37:55AM -0800, David Rientjes (rientjes@google.com) wrote:
> > /dev/mem_notify is a great idea, but please do not limit existing
> > oom-killer in its ability to do the job and do not rely on application's
> > ability to send a SIGKILL which will not kill tasks in unkillable state
> > contrary to oom-killer.
> > 
> 
> You're missing the point, /dev/mem_notify would notify userspace of lowmem 
> situations and allow it to respond appropriately in any number of ways 
> before an oom condition exists.

Yes, I know.

> When the system (or cpuset, memory controller, etc) is oom, userspace can 
> choose to defer to the oom killer so that it may kill a task that would 
> most likely lead to future memory freeing with access to memory reserves.
> 
> There is no additional oom killer limitation imposed here, nor can the oom 
> killer kill a task hung in D state any better than userspace.

Well, oom-killer can, since it drops unkillable state from the process
mask, that may be not enough though, but it tries more than userspace.

My main point was to haev a way to monitor memory usage and that any
process could tune own behaviour according to that information. Which is
not realated to the system oom-killer at all. Thus /dev/mem_notify is
interested first (and only the first) as a memory usage notification
interface and not a way to invoke any kind of 'soft' oom-killer.
Application can do whatever it wants of course including killing itself
or the neighbours, but this should not be forced as a usage policy.

-- 
	Evgeniy Polyakov
