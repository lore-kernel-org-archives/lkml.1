Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZA0Lkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZA0Lkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZA0LkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:40:22 -0500
Received: from mail.suse.de ([195.135.220.2]:56854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbZA0LkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:40:22 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Date: Tue, 27 Jan 2009 17:07:47 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <200901211638.23101.knikanth@suse.de> <200901271638.21720.knikanth@suse.de> <alpine.DEB.2.00.0901270316040.25608@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0901270316040.25608@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271707.48770.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009 16:51:26 David Rientjes wrote:
> On Tue, 27 Jan 2009, Nikanth Karthikesan wrote:
> > > I don't understand what you're arguing for here.  Are you suggesting
> > > that we should not prefer tasks that intersect the set of allowable
> > > nodes? That makes no sense if the goal is to allow for future memory
> > > freeing.
> >
> > No. Actually I am just wondering, will it be possible to check whether a
> > particular task has memory allocated or mmaped from this node to avoid
> > killing an innocent task.
>
> That's certainly idealistic, but cannot be done in an inexpensive way that
> would scale with the large systems that clients of cpusets typically use.

If we kill only the tasks for which cpuset_mems_allowed_intersects() is true 
on the first pass and even then if we do not get out of oom, we could go over 
again with this expensive check. Using this scheme, could kill more no of 
tasks than required, if a task with lots of memory has moved to a different 
cpuset. But it should be rare and not that severe compared to killing a 
totally innocent task like the current scheme does?!

Thanks
Nikanth
