Return-Path: <linux-kernel-owner+w=401wt.eu-S1755589AbZA0PlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbZA0PlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZA0PlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:41:01 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58662 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbZA0PlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:41:00 -0500
Date: Tue, 27 Jan 2009 21:10:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Arve Hj?nnev?g <arve@android.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Torvalds <torvalds@linux-foundation.org>,
       Paul Menage <menage@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090127154053.GQ504@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com> <20090127093105.GB2646@ioremap.net> <20090127193058.D48B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090127134559.GB18119@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090127134559.GB18119@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Evgeniy Polyakov <zbr@ioremap.net> [2009-01-27 16:45:59]:

> Hi.
> 
> On Tue, Jan 27, 2009 at 07:40:58PM +0900, KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > I'd like to respect your requiremnt. but I also would like to know
> > why you like deterministic hierarchy oom than notification.
> > 
> > I think one of problem is, current patch description is a bit poor
> > and don't describe from administrator view.
> 
> Notification of the memory state is by no means a great idea.
> Any process which cares about the system state can register and make
> some decisions based on the memory state. But if it fails to update to
> the current situation, the main oom-killer has to enter the scene and
> make a progress on the system behaviour.
> 
> As I wrote multiple times there may be a quite trivial situation, when
> process will not be able to make progress (it will not be able to free
> some data even if its memory notification callback is invoked in some
> cases), so we just can not rely on that. After all there may be no
> processes with given notifications registered, so we should be able to
> tune main oom-killer, which is another story compared to the
> /dev/mem_notify discussion.
> 
> Having some special application which will monitor /dev/mem_notify and
> kill processes based on its own hueristics is a good idea, but when it
> fails to do its work (or does not exist) system has to have ability to
> make a progress and invoke a main oom-killer.
>

The last part is what we've discussed in the mini-summit. There should
be OOM kill notification to user space and if that fails let the kernel
invoke the OOM killer. The exact interface for notification is not
interesting, one could use netlink if that works well.

-- 
	Balbir
