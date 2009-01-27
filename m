Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZA0Vy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZA0Vy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZA0VyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:54:10 -0500
Received: from genesysrack.ru ([195.178.208.66]:38262 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbZA0VyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:54:09 -0500
Date: Wed, 28 Jan 2009 00:54:07 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Arve Hj?nnev?g <arve@android.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Torvalds <torvalds@linux-foundation.org>,
       Paul Menage <menage@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090127215407.GB12431@ioremap.net>
References: <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com> <20090127093105.GB2646@ioremap.net> <20090127193058.D48B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090127134559.GB18119@ioremap.net> <20090127154053.GQ504@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127154053.GQ504@balbir.in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 09:10:53PM +0530, Balbir Singh (balbir@linux.vnet.ibm.com) wrote:
> > Having some special application which will monitor /dev/mem_notify and
> > kill processes based on its own hueristics is a good idea, but when it
> > fails to do its work (or does not exist) system has to have ability to
> > make a progress and invoke a main oom-killer.
> 
> The last part is what we've discussed in the mini-summit. There should
> be OOM kill notification to user space and if that fails let the kernel
> invoke the OOM killer. The exact interface for notification is not
> interesting, one could use netlink if that works well.

Yes, that's exactly what I would like to see.
Btw, netlink will not be a good idea, since it requires additional (and
quite big) allocation. I believe just reading the char device (or maybe
having a syscall) is enough, but its up to the implementation.

-- 
	Evgeniy Polyakov
