Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZA0NqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZA0NqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZA0NqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:46:06 -0500
Received: from corega.com.ru ([195.178.208.66]:51426 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZA0NqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:46:04 -0500
Date: Tue, 27 Jan 2009 16:45:59 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       balbir@linux.vnet.ibm.com, Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090127134559.GB18119@ioremap.net>
References: <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com> <20090127093105.GB2646@ioremap.net> <20090127193058.D48B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127193058.D48B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, Jan 27, 2009 at 07:40:58PM +0900, KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> I'd like to respect your requiremnt. but I also would like to know
> why you like deterministic hierarchy oom than notification.
> 
> I think one of problem is, current patch description is a bit poor
> and don't describe from administrator view.

Notification of the memory state is by no means a great idea.
Any process which cares about the system state can register and make
some decisions based on the memory state. But if it fails to update to
the current situation, the main oom-killer has to enter the scene and
make a progress on the system behaviour.

As I wrote multiple times there may be a quite trivial situation, when
process will not be able to make progress (it will not be able to free
some data even if its memory notification callback is invoked in some
cases), so we just can not rely on that. After all there may be no
processes with given notifications registered, so we should be able to
tune main oom-killer, which is another story compared to the
/dev/mem_notify discussion.

Having some special application which will monitor /dev/mem_notify and
kill processes based on its own hueristics is a good idea, but when it
fails to do its work (or does not exist) system has to have ability to
make a progress and invoke a main oom-killer.

-- 
	Evgeniy Polyakov
