Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbZE3NlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbZE3NlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZE3Nk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:40:57 -0400
Received: from lutt.itea.ntnu.no ([129.241.18.234]:47974 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZE3Nk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:40:56 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 May 2009 09:40:56 EDT
Date: Sat, 30 May 2009 15:34:41 +0200
From: Henrik Austad <henrik@austad.us>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: finarfin@dreamos.org, linux-kernel@vger.kernel.org
Subject: Re: SCHED_EDF infos
Message-ID: <20090530133441.GA11337@alecto.austad.us>
References: <164c92d827cbee86ba2c5621716309e6@localhost> <200904300939.31754.henrik@austad.us> <49b7c2350905071935kbd2aa22v9d39cf41c537c24b@mail.gmail.com> <20090508091052.GA10429@januz.myftp.org> <49b7c2350905300438n6195de93la53bee3a309f71d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49b7c2350905300438n6195de93la53bee3a309f71d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 08:38:29PM +0900, GeunSik Lim wrote:
> On Fri, May 8, 2009 at 6:10 PM, Henrik Austad <henrik@austad.us> wrote:
> >> [..]
> >> I think so.
> >> How can we approach  EDF implementation like Pfair as a generic solution
> >> for Multicore in Linux?
> >
> > I am working on an implementation now, and I hope to be able to release a
> > prototype by the end of next week. I think we can continue the discussion
> > then based on that.
> Hi Henrik,

Hi!

btw, that 'end of next week'.. *sigh*

> Can you share EDF that you implemented with P-fair for Multicore environments?
> Especially, I wonder How do you keep posix compatibility with EDF scheduler.

Well, what exactly do you mean by posix compatibility? What I'm doing, is adding 
another scheduling class on top of sched_rt so that sched_pfair will be polled 
before any other class. I was not aware that POSIX had an EDF standard?

> For example,
> sched_setscheduler(2), sched_getscheduler(2),
> sched_get_priority_max(2), sched_get_priority_min(2),
> sched_getaffinity(2), sched_setaffinity(2),
> sched_getparam(2), sched_setparam(2),
> setpriority(2), getpriority(2),
> sched_yield(2), sched_rr_get_interval(2)

I introduce 3 new syscalls for modifying the tasks. 

 sched_pfair_update()
 - change an existing task into a pfair task, set attributes, calculate subjob 
   values etc

 sched_pfair_release()
 - release the task, i.e. enable it to run on a CPU.

 sched_pfair_reweigh()
 - change the attributes of the task. In a lot of ways, this is very similar to 
   pfair_update, but it introduces some problems when trying to reweigh a task 
   that is running, or if the new values lead to over-utilization of the system.

At the moment, this is only for my own convenice, but I have tried to modify as 
little of the existing code as possible to avoid merge conflicts etc. So, none 
of the existing syscalls have been modified in any way.

I'm a bit unsure as to what your question actually is, perhaps you could 
elaborate a bit about what you're concered about?

henrik
