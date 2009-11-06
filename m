Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbZKFBFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbZKFBFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbZKFBFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:05:54 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:41941 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056AbZKFBFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:05:53 -0500
Date: Thu, 5 Nov 2009 17:05:52 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, Liu Aleaxander <aleaxander@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: Fixes the un-paired cgroup lock problem
Message-ID: <20091106010552.GA5267@count0.beaverton.ibm.com>
References: <b741c2440911031740m52f8c11dt6e57b549cc6ce465@mail.gmail.com>
 <4AF10CEE.5020807@cn.fujitsu.com>
 <4AF18F06.50807@tmr.com>
 <4AF28695.7070806@cn.fujitsu.com>
 <4AF36A53.3080005@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF36A53.3080005@tmr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 07:14:11PM -0500, Bill Davidsen wrote:
> Li Zefan wrote:
> > Bill Davidsen wrote:
> >   
> >> Li Zefan wrote:
> >>     
> >>> Liu Aleaxander wrote:
> >>>       
> >>>> From: Liu Aleaxander <Aleaxander@gmail.com>
> >>>> Date: Wed, 4 Nov 2009 09:27:06 +0800
> >>>> Subject: [PATCH] Fixes the un-paired cgroup lock problem
> >>>>
> >>>> In cgroup_lock_live_group, it locks the cgroup by mutex_lock, while
> >>>> in the
> >>>> cgroup_tasks_write, it unlock it by cgroup_unlock. Even though they are
> >>>> equal, but I do think we should make it pair.
> >>>>
> >>>> BTW, should we replace others with cgroup_lock and cgroup_unlock?
> >>>> Since we already have a wrapper one and it's meaningful.
> >>>>
> >>>>         
> >>> Before I read the email body, I thought there is a bug where
> >>> there is a lock without unlock or vise versa.
> >>>
> >>> I agree the case here can be called "unpaired", but I'm not
> >>> convinced this patch is needed. The code is not buggy or
> >>> confusing. So the patch neither fixes a bug nor make the code
> >>> more readable.
> >>>
> >>>       
> >> I would say it fixes a bug, the one that would be introduced when the
> >> two methods are no longer compatible and essentially two names for the
> >> same thing. And while you may know the code so well that you knew
> >> without looking that this was (currently) okay, there will be lots of
> >> eyes on this code over the years, I think most people would find use of
> >> cgroup_lock to lock the cgroup a LOT more readable.
> >>
> >> While you can't go back in time to murder your grandfather, it creates
> >> no paradox to fix a bug before someone writes it.
> >>
> >>     
> >
> > cgroup_lock() is not necessarily more readable than mutex_lock(&cgroup_mutex),
> > at least the former doesn't tell you the lock is a spin_lock or a mutex.
> >
> >   
> That's the point, cgroup_lock() is an abstraction, you want to lock the 
> cgroup, you call the macro, the macro handles the details, and if 
> thinking (or the most common cache configurations) change, the code 
> still works.

Except it doesn't really "lock the cgroup" as you've been saying -- else
it would take the cgroup to lock as a parameter. Instead it locks
"all cgroups". Clearly there's room for misunderstanding even with
cgroup_lock().

	-Matt Helsley

