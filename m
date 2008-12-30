Return-Path: <linux-kernel-owner+w=401wt.eu-S1751557AbYL3Hpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbYL3Hpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYL3Hph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:45:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbYL3Hph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:45:37 -0500
Date: Mon, 29 Dec 2008 23:44:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] kmemleak: Add the base support
Message-Id: <20081229234447.41c3c1b1.akpm@linux-foundation.org>
In-Reply-To: <20081230073807.GA2455@elte.hu>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	<20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com>
	<20081229162314.1cc7a549.akpm@linux-foundation.org>
	<20081230073807.GA2455@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 08:38:07 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +/*
> > > + * Stop the automatic memory scanning thread. This function must be called
> > > + * with the kmemleak_mutex held.
> > > + */
> > > +void stop_scan_thread(void)
> > > +{
> > > +	if (scan_thread) {
> > > +		kthread_stop(scan_thread);
> > > +		scan_thread = NULL;
> > > +	}
> > > +}
> > 
> > so... why do we need a kernel thread?
> > 
> > We could have (for the sake of argument) a sys_kmemleak_scan() which 
> > does a single scan then returns.  Or something like that.  That way, 
> > userspace directly gets to set the scanning frequency, thread priority, 
> > etc.
> 
> thread priority of a kernel thread can be set anyway. Kernel threads tend 
> to be better for such simple things because we can control all aspects, 
> start them automatically so that test setups catch it (without needing any 
> userspace component), etc.
> 

yeah yeah, userspace is too hard for kernel programmers, so we put our
applications, English-only pretty-printers etc into the kernel.  It's a
broken record.
