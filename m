Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbZAGPQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbZAGPQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZAGPQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:16:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:39972 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZAGPQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:16:17 -0500
Subject: Re: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
From: Peter Zijlstra <peterz@infradead.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       "Luck, Tony" <tony.luck@intel.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>, Tony Luck <tony.luck@gmail.com>
In-Reply-To: <20090107133230.GA28694@sgi.com>
References: <57C9024A16AD2D4C97DC78E552063EA35CB95575@orsmsx505.amr.corp.intel.com>
	 <20090106201950.GA3850@sgi.com>
	 <57C9024A16AD2D4C97DC78E552063EA35CB955B4@orsmsx505.amr.corp.intel.com>
	 <1231275441.11687.110.camel@twins> <20090106225054.GB3850@sgi.com>
	 <1231283763.11687.135.camel@twins> <20090107030030.GH3390@wotan.suse.de>
	 <1231313289.11687.172.camel@twins> <20090107094328.GD3850@sgi.com>
	 <1231322037.11687.178.camel@twins>  <20090107133230.GA28694@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Jan 2009 16:16:14 +0100
Message-Id: <1231341374.11687.303.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 07:32 -0600, Dimitri Sivanich wrote:
> Peter,
> 
> On Wed, Jan 07, 2009 at 10:53:57AM +0100, Peter Zijlstra wrote:
> > 
> > Clock state is kept per-cpu, and locked with a spinlock. When we request
> 
> Admittedly I have not looked at this possibility too closely, but my
> initial concern upon looking at sched_clock_cpu() for the UNSTABLE
> case was the lock_double_clock() and what sort of contention that
> might cause on larger systems under certain conditions.

Similar contention would already exist on rq->lock.
