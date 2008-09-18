Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbYIRNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbYIRNvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 09:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYIRNvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 09:51:03 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53520 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753193AbYIRNvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:51:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=NNrwLaV0Jfoi6QWx0MI8poksYsa6Qa6Gsu1yKwhJNgTd0AhnhUIAW/NRbX4qOB/HP
	Tg05YQNgOZKSh+Guk8h5Q==
Subject: Re: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080918102353.GD20967@elte.hu>
References: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
	 <20080914150651.GK12522@elte.hu> <20080914150923.GB26984@elte.hu>
	 <1221502142.19012.35.camel@bobble.smo.corp.google.com>
	 <20080916084143.GC17287@elte.hu>
	 <1221678187.13420.17.camel@bobble.smo.corp.google.com>
	 <20080918102353.GD20967@elte.hu>
Content-Type: text/plain
Organization: Google, Inc.
Date: Thu, 18 Sep 2008 06:50:01 -0700
Message-Id: <1221745801.5411.3.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-18 at 12:23 +0200, Ingo Molnar wrote:
> i'd not worry about those 160 bytes - getting this stuff to work fine is 
> far more important. Details around threading seem to be one of the 
> slowest converging technological details of Linux.

Okay, the next patch will have this simplification.

> a silly question:
> 
> > +#else /* CONFIG_SMP */
> > +
> > +/*
> > + * Allocate the thread_group_cputime structure appropriately for UP kernels
> > + * and fill in the current values of the fields.  Called from copy_signal()
> > + * via thread_group_cputime_clone_thread() when adding a second or subsequent
> > + * thread to a thread group.  Assumes interrupts are enabled when called.
> > + */
> > +int thread_group_cputime_alloc(struct task_struct *tsk)
> > +{
> 
> why is there _any_ assymetry needed between UP and SMP? These days we 
> just write straight code for SMP, and UP is just a single-CPU 
> special-case of it. _Sometimes_ if it's really worth it we do some UP 
> special cases but it's the exception, not the rule.

As far as I know, I still need to handle the SMP per_cpu allocate/free
differently from the UP kmalloc.  I'll check again, though; if that's no
longer the case, I'll fix it.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

