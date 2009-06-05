Return-Path: <linux-kernel-owner+w=401wt.eu-S1756256AbZFEO4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbZFEO4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbZFEO4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:56:07 -0400
Received: from tango.0pointer.de ([85.214.72.216]:51315 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZFEO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:56:05 -0400
Date: Fri, 5 Jun 2009 16:55:41 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
Subject: Re: [PATCH] scheduler: introduce SCHED_RESET_ON_FORK scheduling
	policy flag, Second try
Message-ID: <20090605145541.GB19690@tango.0pointer.de>
References: <20090529083840.GA15516@omega> <20090605115410.GA16008@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605115410.GA16008@elte.hu>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05.06.09 13:54, Ingo Molnar (mingo@elte.hu) wrote:

> 
> 
> * Lennart Poettering <mzxreary@0pointer.de> wrote:
> 
> > Why expose this via sched_setscheduler() and not other syscalls 
> > such as prctl() or sched_setparam()?
> > 
> > prctl() does not take a pid parameter. Due to that it would be 
> > impossible to modify this flag for other processes than the 
> > current one.
> > 
> > The struct passed to sched_setparam() can unfortunately not be 
> > extended without breaking compatibility, since sched_setparam() 
> > lacks a size parameter.
> 
> Well, it could be extended, if we wanted to. Right now 
> sched_priority has a valid value of 0 to 100. We could introduce a 
> new value '-1' to mean: 'extended struct sched_param'.
> 
> A new getparam syscall could then be introduced - only used by new 
> user-space.

The man page of sched_getparam() is pretty explicit in that the
sched_priority field of the struct must lie between
sched_get_priority_min() and sched_get_priority_max(). If you'd
overload sched_priority like this you might end up breaking applications
that rely on this, for example RT watchdogs that go through /proc and
query the scheduling parameters of all threads.

Any further comments on the patch? Could this be merged? Any changes
necessary?

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
