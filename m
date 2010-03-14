Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0COCcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 22:32:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581Ab0COCcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 22:32:21 -0400
Date: Sun, 14 Mar 2010 19:31:14 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mel Gorman <mel@csn.ul.ie>, Markus Rechberger <mrechberger@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USBFS Memory allocation Bug
Message-Id: <20100314193114.619a2616.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.44L0.1003111155030.1367-100000@iolanthe.rowland.org>
References: <20100310155519.GO4883@csn.ul.ie>
	<Pine.LNX.4.44L0.1003111155030.1367-100000@iolanthe.rowland.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 11:56:22 -0500 (EST) Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 10 Mar 2010, Mel Gorman wrote:
> 
> > > > Is there any means for the driver to take the large request, break it up
> > > > into multiple smaller requests and submit them one at a time?
> > > 
> > > In theory almost anything is possible.  But it would be a big effort
> > > and not consistent with the way the rest of the driver works.
> > > 
> > 
> > Then about the only other suggestion would be a mempool containing a small
> > number of largest-possible buffers that is enabled if there is no swap
> > available.
> 
> Considering that this is the first report I have heard about this sort 
> of problem, and that adding swap space would probably fix it, I'm not 
> inclined to make any changes.

Adding swap space is unlikely to help here.  For an order-6 allocation
the page allocator will go into wtf-youre-kidding-me mode and won't
even bother trying.

Asking the allocator for 2^6 physically contiguous pages is terribly
unreliable and shouldn't be done by any kernel code which wants to be
useful.


