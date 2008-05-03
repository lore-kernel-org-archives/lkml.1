Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYECHOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYECHOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 03:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYECHN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 03:13:58 -0400
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:59408 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbYECHN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 03:13:57 -0400
From: Frans Pop <elendil@planet.nl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Horrendous Audio Stutter - current git
Date: Sat, 3 May 2008 09:13:53 +0200
User-Agent: KMail/1.9.9
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com> <82e4877d0805020521t696cc4fbu6ffd182f84ae1a2e@mail.gmail.com> <1209731822.25271.4.camel@marge.simson.net>
In-Reply-To: <1209731822.25271.4.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805030913.55124.elendil@planet.nl>
X-OriginalArrivalTime: 03 May 2008 07:13:55.0702 (UTC) FILETIME=[3FC2D960:01C8ACED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Mike Galbraith wrote:
> On Fri, 2008-05-02 at 08:21 -0400, Parag Warudkar wrote:
> > On Fri, May 2, 2008 at 8:09 AM, Mike Galbraith <efault@gmx.de> wrote:
> > >  Hm.  I've stumbled across a regression that may be related.  Can you
> > >  please try the attached with group scheduling enabled in current
> > > git?
> >
> > In file included from kernel/sched.c:1902:
> > kernel/sched_fair.c: In function 'print_cfs_rq_tasks':
> > kernel/sched_fair.c:1602: error: implicit declaration of function
> > 'calc_delta_weight'
> > kernel/sched_fair.c:1603: warning: format '%lu' expects type 'long
> > unsigned int', but argument 5 has type 'int'
> > make[1]: *** [kernel/sched.o] Error 1
> > make: *** [kernel] Error 2
> >
> > 'calc_delta_weight' or a replacement not found easily to fix it up!
>
> Oops, I have an unrelated patch in my tree which you also need.

Based on Mike's mails I have quickly tried reverting the following two 
commits to see if that would fix the GROUP_SCHED related regression, but I 
still get a merge error with the second one in sched_fair.c:
$ git revert 7ba2e74ab5
$ git revert 8f1bc385cf

I don't feel comfortable solving the conflict myself as I'd have absolutely 
no idea what I'd be doing and it all seems to require a lot of precision.

As other suggested patches don't seem ready for testing yet, I'll just wait 
for further instructions :-)

Cheers,
FJP
