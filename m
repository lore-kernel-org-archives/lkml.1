Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZAVJ0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZAVJ0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZAVJZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:25:49 -0500
Received: from mail.suse.de ([195.135.220.2]:46930 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZAVJZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:25:48 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Date: Thu, 22 Jan 2009 14:53:13 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
References: <200901211638.23101.knikanth@suse.de> <200901221042.30957.knikanth@suse.de> <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0901220036440.28850@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901221453.14860.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009 14:13:38 David Rientjes wrote:
> On Thu, 22 Jan 2009, Nikanth Karthikesan wrote:
> > No, this is not specific to memcg or cpuset cases alone. The same
> > needless kills will take place even without memcg or cpuset when an
> > administrator specifies a light memory consumer to be killed before a
> > heavy memory user. But it is up to the administrator to use it wisely.
>
> You can't specify different behavior for an oom cgroup depending on what
> type of oom it is, which is the problem with this proposal.
>

No. This does not disable any such special selection criteria which is used 
without this controller.

> For example, if your task triggers an oom as the result of its exclusive
> cpuset placement, the oom killer should prefer to kill a task within that
> cpuset to allow for future memory freeing.
>
> So, with your proposal, an administrator can specify the oom priority of
> an entire aggregate of tasks but the behavior may not be desired for a
> cpuset-constrained oom, while it may be perfectly legitimate for a global
> unconstrained oom.
>
> I can specify a higher oom priority for a cpuset because its jobs are less
> critical and I would prefer it gets killed in a system-wide oom, but any
> other cpuset that ooms will needlessly kill these tasks when there is no
> benefit.
>

This patch just chooses the task with highest oom.victim among those tasks 
which would have been chosen without this controller. So all the "kill within 
memcg/cpuset" should work as always! It should just kill a task within the 
memcg with highest oom.victim.

Thanks
Nikanth
