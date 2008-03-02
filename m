Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbYCBFQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbYCBFQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 00:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYCBFQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 00:16:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43623 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbYCBFQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 00:16:14 -0500
Date: Sat, 1 Mar 2008 21:20:07 -0800
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/2] object debugging infrastructure
Message-ID: <20080302052007.GA24573@kroah.com>
References: <20080301100019.640027768@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080301100019.640027768@linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 10:24:52AM -0000, Thomas Gleixner wrote:
> We can see an ever repeating problem pattern with objects of any kind in
> the kernel:
> 
> 1) free of active objects
> 2) reinitialization of active objects

Ah, this looks nice.  For kobjects I would like to track the above, as
well as:
	- use of initialized objects
	- use of "freed" objects
	- objects that are never destroyed, yet the code controlling
	  them thinks they are.

I say "freed" as sometimes kobjects are in static structures and are not
in memory that ends up being kfree() so slab poisoning doesn't help.

Do you think that would be able to worked into this framework?  At first
glance, it seems like it would be easy to add, but would like to make
sure.

If so, I'll gladly add this to the kobjects to help with issues there.

thanks,

greg k-h
