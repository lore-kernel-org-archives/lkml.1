Return-Path: <linux-kernel-owner+w=401wt.eu-S965819AbXEKSF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965819AbXEKSF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbXEKSFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:05:50 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759813AbXEKSFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:05:49 -0400
Date: Fri, 11 May 2007 11:05:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] scalable rw_mutex
Message-Id: <20070511110522.ed459635.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705111006470.32716@schroedinger.engr.sgi.com>
References: <20070511131541.992688403@chello.nl>
	<20070511132321.895740140@chello.nl>
	<20070511093108.495feb70.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705111006470.32716@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 10:07:17 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 11 May 2007, Andrew Morton wrote:
> 
> > yipes.  percpu_counter_sum() is expensive.
> 
> Capable of triggering NMI watchdog on 4096+ processors?

Well.  That would be a millisecond per cpu which sounds improbable.  And
we'd need to be calling it under local_irq_save() which we presently don't.
And nobody has reported any problems against the existing callsites.

But it's no speed demon, that's for sure.
