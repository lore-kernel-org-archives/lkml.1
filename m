Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZGZDzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZGZDzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 23:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZGZDzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 23:55:50 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:58805 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbZGZDzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 23:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FpHpsmJ7E5KjQVIrko17Kp/fYWFlwZduzo/SmDTvqUB/O66C5sQ8WG8QbyPn60es/y
         1bgHxU4Ytc6RigmDlMwvPdjHYiJT9YV2M+p4jdM8J06QiomOaYo9ImWc3ZVjo8PBssIu
         liFxG9arzaB7zfAl7evE/FpoJ30lhjC2ufsQk=
MIME-Version: 1.0
In-Reply-To: <20090724072826.4c35bc2a@infradead.org>
References: <454c71700907240357l61f5c4fajaca73db0fba7db8@mail.gmail.com>
	 <20090724072826.4c35bc2a@infradead.org>
Date: Sun, 26 Jul 2009 11:55:45 +0800
Message-ID: <454c71700907252055i51f14efdk942f95601fdae878@mail.gmail.com>
Subject: Re: report a bug about sched_rt
From: sen wang <wangsen.linux@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/24 Arjan van de Ven <arjan@infradead.org>
>
> On Fri, 24 Jul 2009 18:57:35 +0800
> sen wang <wangsen.linux@gmail.com> wrote:
>
> > I find something is wrong about sched_rt.
> >
> >  when I am debugging my system with rt_bandwidth_enabled, there is a
> > running realtime FIFO task in the sched_rt running queue and
> >  the fair running queue is empty.  I found the idle task will be
> > scheduled up when the running task still lie in the  sched_rt running
> > queue!
> >
> > this will happen when rt runqueue passed it's rt_bandwidth_enabled
> > runtime,then the scheduler choose the idle task instead of realtime
> > FIFO task.
> >
> > the reason lie in: when scheduler try to pick up a realtime FIFO task,
> > it will check if rt_throttled is enabled,
> > if so, it'll return and try fair queue but it is empty, then it come
> > to the sched_idle class.
> >
> > I don't think it reasonable, we should give the realtime FIFO task the
> > chance, even when rt runqueue passed it's runtime.
> > because it is cpu's free time.
>
>
> sounds like a good power limiting feature...
>
>

what I want to say is:
If we give cpu to rt task at that situation,the normal fair task still
have chance to get cpu in the left 50ms.(say the throttle is 950
ms).because in the left 50ms,throttle  is still enabled, every
tick,the rt schedule will check the normal fair task.if find some
one,rt will yield cpu to
the new coming noraml fair task.

for realtime system there is stll normal fair task, so the bandwidth
is useful,we cann't just
turn it off simply.

I think the usespace schedule policy is not feasible. because when and
who and where to implemnt it?glibc,uclibc,android bionic.?  can you
make sure they will implent the compatible policy?  kernel is the best
place to do it.

and since linux is used for so many fields,why not provide different
feature for different system.by adding a new kenrel config item,say
CONFIG_REAL_TIME_SYSTEM, we can give cpu to rt task when throttle is
on,by disable CONFIG_REAL_TIME_SYSTEM,everything is keep untouched for
server and desktop.

i don't know if the viewpoint will offsend somebody, sorry first  :)


> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
