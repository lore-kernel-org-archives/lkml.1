Return-Path: <linux-kernel-owner+w=401wt.eu-S1030778AbXDMVgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030778AbXDMVgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 17:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030817AbXDMVgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 17:36:14 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:38066
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030812AbXDMVgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 17:36:13 -0400
Date: Fri, 13 Apr 2007 14:35:48 -0700
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413213548.GA15279@gnuppy.monkey.org>
References: <20070413202100.GA9957@elte.hu> <20070413202745.GA17993@gnuppy.monkey.org> <20070413205545.GA18032@elte.hu> <20070413212110.GU2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413212110.GU2986@holomorphy.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 02:21:10PM -0700, William Lee Irwin III wrote:
> On Fri, Apr 13, 2007 at 10:55:45PM +0200, Ingo Molnar wrote:
> > Yeah. Note that there are some subtle but crutial differences between 
> > PlugSched (which Con used, and which i opposed in the past) and this 
> > approach.
> > PlugSched cuts the interfaces at a high level in a monolithic way and 
> > introduces kernel/scheduler.c that uses one pluggable scheduler 
> > (represented via the 'scheduler' global template) at a time.
> 
> What I originally did did so for a good reason, which was that it was
> intended to support far more radical reorganizations, for instance,
> things that changed the per-cpu runqueue affairs for gang scheduling.
> I wrote a top-level driver that did support scheduling classes in a
> similar fashion, though it didn't survive others maintaining the patches.

Also, gang scheduling is needed to solve virtualization issues regarding
spinlocks in a guest image. You could potentally be spinning on a thread
that isn't currently running which, needless to say, is very bad.

bill

