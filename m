Return-Path: <linux-kernel-owner+w=401wt.eu-S1765177AbXKPDxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765177AbXKPDxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbXKPDw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:52:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804AbXKPDwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:52:55 -0500
Date: Thu, 15 Nov 2007 19:52:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: Re: x86: disable preemption in delay_tsc()
Message-Id: <20071115195234.2dc8406d.akpm@linux-foundation.org>
In-Reply-To: <20071115194116.12c7a0f6@laptopd505.fenrus.org>
References: <200711150400.lAF40lIr020160@hera.kernel.org>
	<20071115194116.12c7a0f6@laptopd505.fenrus.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 19:41:16 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

> On Thu, 15 Nov 2007 04:00:47 GMT
> Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
> > Gitweb:
> > http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=35d5d08a085c56f153458c3f5d8ce24123617faf
> > Commit:     35d5d08a085c56f153458c3f5d8ce24123617faf Parent:
> > 7eea436433b7b18045f272562e256976f593f7c0 Author:     Andrew Morton
> > <akpm@linux-foundation.org> AuthorDate: Wed Nov 14 17:00:41 2007 -0800
> > Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> > CommitDate: Wed Nov 14 18:45:44 2007 -0800
> > 
> >     x86: disable preemption in delay_tsc()
> >     
> >     Marin Mitov points out that delay_tsc() can misbehave if it is
> > preempted and rescheduled on a different CPU which has a skewed TSC.
> > Fix it by disabling preemption.
> >  
> 
> this worries me.. this appears to effectively disable preemption during
> udelay() and mdelay() loops... which are very obvious latency inducers.
> 
> Now you can argue that if you're preemptible you should have used
> msleep() and co, and I'll totally buy that. 
> 
> 
> Maybe we should just check if we're still on the same cpu or something,
> or have a cheap way to pin a process to a cpu.... but both are longer
> term solutions.
> 

Yes, we can do better.

But this bug can cause very rare failures in probably a large number of
device drivers on a minorty of machines.  Ugly.  So I felt it best to
plug it fast while people think about more sophisticated fixes.

