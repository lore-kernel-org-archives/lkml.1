Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092Ab0A2XDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0A2XDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940Ab0A2XDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:03:42 -0500
Received: from www.tglx.de ([62.245.132.106]:60739 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab0A2XDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:03:41 -0500
Date: Sat, 30 Jan 2010 00:03:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 06/10] affs: Convert semaphores to mutexes
In-Reply-To: <20100129223627.GB18752@infradead.org>
Message-ID: <alpine.LFD.2.00.1001300002370.5926@localhost.localdomain>
References: <20100129203549.526478432@linutronix.de> <20100129203613.591137914@linutronix.de> <20100129223627.GB18752@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010, Christoph Hellwig wrote:

> On Fri, Jan 29, 2010 at 08:38:55PM -0000, Thomas Gleixner wrote:
> > These semaphores are plain mutexes. Convert them to struct mutex.
> 
> Looks good.
> 
> > Map affs_[un]lock_dir() to affs_[un]lock_ext() instead of the "#define
> > i_hash_lock i_ext_lock" magic.
> 
> I'm not sure which of the remapping tricks is the worth one..
> 
> Btw, if we don't want lockdep to complain we'll need annotations on
> affs_lock_dir as it's taken both on parent and child.

Can we postpone this to the point where an actual affs user runs with
lockdep enabled ?

Thanks,

	tglx

