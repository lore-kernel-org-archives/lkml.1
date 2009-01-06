Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbZAFRwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbZAFRwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 12:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZAFRwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 12:52:05 -0500
Received: from kroah.org ([198.145.64.141]:54995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754078AbZAFRwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 12:52:03 -0500
Date: Tue, 6 Jan 2009 09:12:13 -0800
From: Greg KH <greg@kroah.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>,
       Tony Luck <tony.luck@gmail.com>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Message-ID: <20090106171213.GA21880@kroah.com>
References: <20090106162741.GA7991@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106162741.GA7991@sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:27:41AM -0600, Dimitri Sivanich wrote:
> Turn on CONFIG_HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN.
> 
> SGI Altix has unsynchronized itc clocks.  This results in rq->clock
> occasionally being set to a time in the past by a remote cpu.
> 
> Note that it is possible that this problem may exist for other ia64
> machines as well, based on the following comment for sched_clock() in
> arch/ia64/kernel/head.S:
> 
>  * Return a CPU-local timestamp in nano-seconds.  This timestamp is
>  * NOT synchronized across CPUs its return value must never be
>  * compared against the values returned on another CPU.  The usage in
>  * kernel/sched.c ensures that.
> 
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> ---
> 
> Greg, if everyone is OK with this patch, this should also be applied
> to all stable trees starting with 2.6.26.

That's fine (but 2.6.26 is no longer getting -stable releases).

Just let stable@kernel.org know when this patch is applied in Linus's
tree.  You can do this automatically by adding a:
	Cc: stable <stable@kernel.org>
to the signed-off-by: area of the patch, and the stable team will be
automatically notified when it goes into Linus's tree.

thanks,

greg k-h
