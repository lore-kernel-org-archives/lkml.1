Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZA0LLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZA0LLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZA0LK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:10:56 -0500
Received: from ns1.suse.de ([195.135.220.2]:55919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbZA0LK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:10:56 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Date: Tue, 27 Jan 2009 16:38:21 +0530
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
References: <200901211638.23101.knikanth@suse.de> <200901271550.16902.knikanth@suse.de> <alpine.DEB.2.00.0901270244380.23757@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0901270244380.23757@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901271638.21720.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009 16:23:00 David Rientjes wrote:
> On Tue, 27 Jan 2009, Nikanth Karthikesan wrote:
> > > As previously stated, I think the heuristic to penalize tasks for not
> > > having an intersection with the set of allowable nodes of the oom
> > > triggering task could be made slightly more severe.  That's irrelevant
> > > to your patch, though.
> >
> > But the heuristic makes it non-deterministic, unlike memcg case. And this
> > mandates special handling for cpuset constrained OOM conditions in this
> > patch.
>
> Dividing a badness score by 8 if a task's set of allowable nodes do not
> insect with the oom triggering task's set does not make an otherwise
> deterministic algorithm non-deterministic.
>
> I don't understand what you're arguing for here.  Are you suggesting that
> we should not prefer tasks that intersect the set of allowable nodes?
> That makes no sense if the goal is to allow for future memory freeing.
>

No. Actually I am just wondering, will it be possible to check whether a 
particular task has memory allocated or mmaped from this node to avoid killing 
an innocent task. I compared with memcg, to say that memcg never kills a task 
not related to the memcg constrained oom. Sorry if I was unclear, earlier. If 
we do this, oom-controller will not require special handling for cpuset 
constrained ooms.

Thanks
Nikanth
