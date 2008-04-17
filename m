Return-Path: <linux-kernel-owner+w=401wt.eu-S934854AbYDQROM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbYDQROM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934459AbYDQRNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:13:43 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37192 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934424AbYDQRNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:13:43 -0400
Date: Thu, 17 Apr 2008 20:19:36 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Message-ID: <20080417161936.GB4482@tv-sign.ru>
References: <48036677.3010807@linux.vnet.ibm.com> <20080414170709.736819b6.akpm@linux-foundation.org> <20080415171359.GA352@tv-sign.ru> <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com> <20080415195950.GA113@tv-sign.ru> <4806C633.3000302@linux.vnet.ibm.com> <20080417113000.GB103@tv-sign.ru> <6599ad830804170934i6df9fe42kd979492babe03be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830804170934i6df9fe42kd979492babe03be@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Paul Menage wrote:
>
> On Thu, Apr 17, 2008 at 4:30 AM, Oleg Nesterov <oleg@tv-sign.ru> wrote:
> >  >
> >  > I had this loop earlier (inspired from zap_threads()), is this loop more
> >  > efficient than what we have?
> >
> >  All sub-threads have the same ->mm. Once we see that c->mm != mm, we don't
> >  need to waste CPU iterating over the all other threads in the thread group.
> 
> Technically they don't have to have the same mm, right? You can use
> CLONE_THREAD without CLONE_VM when creating a new subthread.

No, no, this is not possible/allowed.

Please look at copy_process, CLONE_THREAD requires CLONE_SIGHAND,
CLONE_SIGHAND needs CLONE_VM.

> >  chance you have the "for dummies" explanation what mm->owner is?
> >  I mean, I can't understand how it is possible that 2 CLONE_VM tasks
> >  are not equal wrt "ownering".
> 
> The idea is to be able to get from an mm to a task, where that task is
> representative of the tasks using the mm. Uses include:

Thanks! but...

Let's suppose 2 task belongs to different cgroups, but share ->mm,

> - swap cgroup - when swapping from an mm, find a task whose swap
> cgroup we can charge the swap page to

now we will charge the somewhat "random" cgroup. The one to which
the result of the last "find the next suitable owner" belongs.

This looks a bit strange to me... but OK, as I said, I don't know
what cgroup is, please ignore me ;)

Oleg.

