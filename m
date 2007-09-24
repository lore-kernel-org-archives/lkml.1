Return-Path: <linux-kernel-owner+w=401wt.eu-S1763906AbXIXQq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763906AbXIXQq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761495AbXIXQdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:33:06 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39152 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759346AbXIXQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:33:04 -0400
Subject: Re: 2.6.23-rc7-mm1: r/o mounts joke with lockdep
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <20070924092658.91c17511.akpm@linux-foundation.org>
References: <20070924095105.GD6757@localhost.sw.ru>
	 <20070924092658.91c17511.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 09:33:00 -0700
Message-Id: <1190651581.26982.230.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 09:26 -0700, Andrew Morton wrote:
> On Mon, 24 Sep 2007 13:51:05 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > static void lock_and_coalesce_cpu_mnt_writer_counts(void)
> > {
> > 	int cpu;
> > 	struct mnt_writer *cpu_writer;
> > 
> > 	for_each_possible_cpu(cpu) {
> > 		cpu_writer = &per_cpu(mnt_writers, cpu);
> > 		spin_lock_nested(&cpu_writer->lock, 42);
> > 		                                   ^^^^
> > 
> > What the heck is going on?
> 
> that was some random 2:00AM hack by me to make the warnings go away.
> 
> > Given that MAX_LOCKDEP_SUBCLASSES is only 8,
> > this reliably turns off lockdep at boot.
> 
> that explains why it worked so well.

Arjan gave me some ideas on how to fix this more properly.  I'm trying
to reproduce it and working on a patch now.

-- Dave

