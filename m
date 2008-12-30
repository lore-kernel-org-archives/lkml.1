Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYL3H7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYL3H7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYL3H7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:59:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbYL3H7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:59:42 -0500
Date: Mon, 29 Dec 2008 23:59:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] kmemleak: Add the base support
Message-Id: <20081229235922.4f5d9846.akpm@linux-foundation.org>
In-Reply-To: <20081230075202.GB5482@elte.hu>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	<20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com>
	<20081229162314.1cc7a549.akpm@linux-foundation.org>
	<20081230073807.GA2455@elte.hu>
	<20081229234447.41c3c1b1.akpm@linux-foundation.org>
	<20081230075202.GB5482@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 08:52:02 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 30 Dec 2008 08:38:07 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > > +/*
> > > > > + * Stop the automatic memory scanning thread. This function must be called
> > > > > + * with the kmemleak_mutex held.
> > > > > + */
> > > > > +void stop_scan_thread(void)
> > > > > +{
> > > > > +	if (scan_thread) {
> > > > > +		kthread_stop(scan_thread);
> > > > > +		scan_thread = NULL;
> > > > > +	}
> > > > > +}
> > > > 
> > > > so... why do we need a kernel thread?
> > > > 
> > > > We could have (for the sake of argument) a sys_kmemleak_scan() which 
> > > > does a single scan then returns.  Or something like that.  That way, 
> > > > userspace directly gets to set the scanning frequency, thread priority, 
> > > > etc.
> > > 
> > > thread priority of a kernel thread can be set anyway. Kernel threads tend 
> > > to be better for such simple things because we can control all aspects, 
> > > start them automatically so that test setups catch it (without needing any 
> > > userspace component), etc.
> > > 
> > 
> > yeah yeah, userspace is too hard for kernel programmers, so we put our 
> > applications, English-only pretty-printers etc into the kernel.  It's a 
> > broken record.
> 
> above a certain threshold i think we need to start thinking about merging 
> klibc, and moving some key system applications into the kernel source 
> proper (those which closely depend on the kernel version anyway and need 
> to be updated together).
> 

Sure, but I don't think we'd need klibc for this.  We already ship
quite a lot of ad-hoc userspace in Documentation/, and Sam's recently
(and hopefully temporarily) lost patch which moves all that stuff into
./tests/ (should have been ./userspace/tests/) seemed to work OK.

