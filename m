Return-Path: <linux-kernel-owner+w=401wt.eu-S1759777AbXLUKoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbXLUKoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXLUKoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:44:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879AbXLUKoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:44:04 -0500
Date: Fri, 21 Dec 2007 02:42:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: trond.myklebust@fys.uio.no, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
Message-Id: <20071221024211.f4207136.akpm@linux-foundation.org>
In-Reply-To: <20071221102727.GB22452@elte.hu>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org>
	<20071220145415.f737e7f3.akpm@linux-foundation.org>
	<20071220234759.GA29776@elte.hu>
	<20071220161934.0f55029a.akpm@linux-foundation.org>
	<20071221003035.GA10123@elte.hu>
	<20071220164000.58c43b42.akpm@linux-foundation.org>
	<20071221102727.GB22452@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007 11:27:27 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> > local_read_flags().
> > 
> > > that should have been raw_local_irq_save(flags)!
> > 
> > So raw_local_save_flags() and raw_local_irq_save() have different semantics.
> > 
> > omigawd, what have we done?
> 
> i really tried to get this fixed years ago - but did not think of 
> local_read_flags as a solution. The patch below fixes this.
> 
> (if it's too burdensome to carry right now then i can regenerate this 
> patch in 30 seconds in the 2.6.25 merge window - but please remind me 
> then. Perhaps put in a patch into your queue that adds a comment to 
> remind me :-) )

I'd suggest that we add a local_read_flags() along with local_save_flags().
Then I can merge the parts of the patch which don't get destroyed by ongoing
churn and then we can come in and clean up the stragglers later.

box:/usr/src/25> grep -l local_save_flags patches/*.patch 
patches/git-perfmon.patch
patches/git-sh.patch
patches/git-x86.patch
patches/i386-use-raw_smp_processor_id-in-die.patch
patches/mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
patches/origin.patch


