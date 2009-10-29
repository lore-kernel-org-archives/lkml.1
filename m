Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZJ2UFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZJ2UFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 16:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZJ2UFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 16:05:40 -0400
Received: from vena.lwn.net ([206.168.112.25]:53751 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbZJ2UFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 16:05:39 -0400
Date: Thu, 29 Oct 2009 14:05:42 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Rodrick <daniel.rodrick@gmail.com>
Cc: Linux Newbie <linux-newbie@vger.kernel.org>,
       Kernel Newbies <kernelnewbies@nl.linux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Questions about linux scheduler
Message-ID: <20091029140542.21970ff2@bike.lwn.net>
In-Reply-To: <292693080910290808x69f25f6fgc49cb646c1c00466@mail.gmail.com>
References: <292693080910290808x69f25f6fgc49cb646c1c00466@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Daniel,

I'm not a scheduler expert by any stretch, but I can try to play one on
the net...

> I'm following the Robert Love's book and am trying to understand the
> Linux O(1) scheduler. 

Note that the O(1) scheduler is no more; it was replaced by the
completely fair scheduler in 2.6.23.  For the purposes of your
questions things haven't changed a lot, but it's completely different
internally.

> So here is my understanding. The kernel allows
> the applications to specify two types of priorities
> 
> * Realtime Priorities: Range from 0 to 99
> * Non-realtime priorities: Also called "nice" values range from -20 to +19.

You're really talking about different scheduling classes.  There are
two realtime classes (FIFO and RR), both of which trump the interactive
class (SCHED_OTHER).

> * A total of 140 priorities (100 RT + 40 non-RT) - these priorities
> are static - do not change over time.

Sort of, but realtime priorities are really an entirely different scale.

> * A lower priority process will run only if there are no runnable
> processes in priority above it - this automatically means that all RT
> processes get to run before non-RT processes.

That is true for the realtime classes.  SCHED_OTHER will give
lower-priority processes a bit of time even in the presence of runnable
high-priority processes.

>  * tasks on the same priority level are scheduled round robin

SCHED_RR does that, SCHED_FIFO does not.  SCHED_OTHER is
fairness-based, which has RR-like characteristics but is not quite the
same.

Hope that helps,

jon

Jonathan Corbet / LWN.net / corbet@lwn.net
