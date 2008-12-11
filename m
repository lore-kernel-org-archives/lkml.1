Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbYLKGdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbYLKGdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 01:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYLKGdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 01:33:12 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:47760 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYLKGdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 01:33:11 -0500
Date: Thu, 11 Dec 2008 12:03:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [RFC][PATCH 2/3] CGroups: Use hierarchy_mutex in memory
	controller
Message-ID: <20081211063307.GL3008@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Paul Menage <menage@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20081210233654.563182000@menage.corp.google.com> <20081210234432.236302000@menage.corp.google.com> <20081211094938.85b00cf3.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830812101652o25bc33f3r2a710e0879f9b196@mail.gmail.com> <20081211100501.bf538f0c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081211100501.bf538f0c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-12-11 10:05:01]:

> On Wed, 10 Dec 2008 16:52:57 -0800
> Paul Menage <menage@google.com> wrote:
> 
> > On Wed, Dec 10, 2008 at 4:49 PM, KAMEZAWA Hiroyuki
> > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > >
> > >        an operation like rmdir() in somewhere.
> > >                hierarchy_lock for A (acquired)
> > >                hierarchy_lock for B (waiting)
> > >
> > >        in subsys A.
> > >                mmap_sem (acquired)
> > >                hierarchy_lock for A (waiting)
> > >        in subsys B.
> > >                hierarchy_lock for B (aquired)
> > >                mmap_sem             (waiting)
> > >
> > 
> > That's a valid deadlock - you'd need to require the mmap_sem nests
> > either inside all hierarchy_mutexes or else outside all of them.
> > 
> This was a found dead lock between memcg and cpuset.
> 
> another one was 
> 
> 	an operation like rmdir() in somewhere.
> 		hierarchy_lock for memcg (acquired)
> 		hierarchy_lock for B (waiting)
> 
> 	in subsys B.
> 		hierarchy_lock for B (aquired)

But then the hierarchy_locks acquired will be different right?

> 		have to do some memory reclaim -> hierarchy_lock for memcg (waiting)
> 
> I have no objections to hierarchy_lock itself but calling context to memcg is very
> complicated and simple replace of these locks will be just a small help.

Could you please explain the race better?

-- 
	Balbir
