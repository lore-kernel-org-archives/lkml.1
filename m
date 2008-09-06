Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYIFQbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYIFQbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYIFQbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:31:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60775 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYIFQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:31:32 -0400
Subject: Re: nice and hyperthreading on atom
From: Peter Zijlstra <peterz@infradead.org>
To: Phil Endecott <phil_wueww_endecott@chezphil.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
References: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
Content-Type: text/plain
Date: Sat, 06 Sep 2008 18:31:28 +0200
Message-Id: <1220718688.8687.19.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-09-06 at 16:43 +0100, Phil Endecott wrote:
> Dear Experts,
> 
> I have an ASUS Eee with an Atom processor, which has hyperthreading 
> enabled.  If I have two processes, one nice and the other normal, they 
> each get 50% of the CPU time.  Of course this is what you'd expect if 
> the scheduler didn't understand that the two virtual processors are not 
> really independent.  I'd like to fix it.
> 
> Google finds patches posted by Con Kolivas a looong time ago to address 
> this.  Can anyone tell me what has happened in the meantime?  Maybe 
> this feature is now in the kernel, but there's something I have to do 
> to enable it (e.g. choose the right scheduler).  Or maybe it never made 
> it in, for some reason.

Assuming the hardware makes each 'virtual' cpu get a similar share of
the hardware resources, there is nothing the operating system can do.

The OS just sees two cpus, and its impossible to schedule two tasks of
different weight on two cpus so that execution time is fair and work is
conserved - this is called an infeasible weight distribution.

So unless the Atom has some interface to influence how the resources are
distributed between the execution contexts (for which Linux currently
lacks any and all support) there is nothing we can do.


