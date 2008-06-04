Return-Path: <linux-kernel-owner+w=401wt.eu-S1758248AbYFDH7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbYFDH7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYFDH7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:59:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbYFDH7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:59:39 -0400
Date: Wed, 4 Jun 2008 00:57:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, ebiederm@xmission.com, mingo@elte.hu,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] coredump: zap_threads() must skip kernel threads
Message-Id: <20080604005743.29aed3a5.akpm@linux-foundation.org>
In-Reply-To: <20080603214959.0208826FC96@magilla.localdomain>
References: <20080601153045.GA8244@tv-sign.ru>
	<20080603141548.15d60a32.akpm@linux-foundation.org>
	<20080603214959.0208826FC96@magilla.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Jun 2008 14:49:58 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> > This is a bugfix, yes?
> > 
> > How does it get triggered?
> 
> Yes, I think it fixes a bug.  The trigger would be an aio request doing
> some work (inside aio_kick_handler) simultaneous with some thread in the
> requester's mm doing a core dump (inside zap_threads).
> 
> > Do you think the bug is sufficiently serious to fix it in 2.6.26?  In
> > 2.6.25.x?  If so, it would be better if this patch were not dependent
> > upon the preceding ones, which do not appear to be 2.6.26 or -stable
> > material.
> 
> It has probably never been seen for real, but might be possible to produce
> with an exploit that works hard to hit the race.  I'm not sure off hand
> what all the bad effects would be, mainly those of SIGKILL'ing the
> workqueue thread (keventd I guess).  The core-dumping threads will be stuck
> in uninterruptible waits and never be killable.
> 
> Oleg's cleanups make the fix much nicer because there is an easy persistent
> flag to check without races.  Probably the most isolated fix for this is
> something like the bit below (wholly untested).  This is hairy enough that
> I think Oleg's 1/3 + 2/3 would be preferable even for -stable.

OK, thanks.

I'll tentatively queue these three for 2.6.26 and will leave 2.6.25.x
alone.  The bug seems sufficiently obscure?

(This required a bit of massaging of
coredump-zap_threads-must-skip-kernel-threads.patch in fs/exec.c due, I
assume, to dependencies on other things which we have queued for
2.6.27).


