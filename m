Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZK3QjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZK3QjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZK3QjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:39:23 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60367 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZK3QjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:39:23 -0500
Date: Mon, 30 Nov 2009 08:39:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091130163923.GC6762@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130075557.GI17484@wotan.suse.de> <alpine.LFD.2.00.0911300706420.2872@localhost.localdomain> <20091130154031.GE21639@wotan.suse.de> <alpine.LFD.2.00.0911300754420.2872@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911300754420.2872@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 08:07:16AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 30 Nov 2009, Nick Piggin wrote:
> > 
> > Well the simple thing I tried earlier was a per-cpu array of nesting
> > counter there. It's not _too_ expensive, but it does add another cacheline
> > access and branch there. It seems to work in solving the livelock though.
> 
> So how did you do the nesting counter? Afaik, it needs to be something 
> like
> 
> 	local_irq_save(flags);
> 	if (!get_cpu_var(tasklist_counter)++)
> 		spin_lock(&tasklist_lock);
> 	local_irq_restore(flags);
> 
> on the read_lock side (and the same in reverse on unlock). Which seems 
> quite a bit more expensive than what we have now. Especially on UP, but I 
> guess you can make it conditional on CONFIG_SMP (but that won't help 
> generic kernels).

My suggestion would be to put the nesting counter in the task structure
to avoid this problem.

							Thanx, Paul
