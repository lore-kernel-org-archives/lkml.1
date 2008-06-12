Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYFLSE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYFLSE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYFLSEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:04:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536AbYFLSEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:04:00 -0400
Date: Thu, 12 Jun 2008 11:03:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 00/11] GRU Driver
Message-Id: <20080612110336.cde5fccb.akpm@linux-foundation.org>
In-Reply-To: <20080612140509.GA21437@sgi.com>
References: <20080609211028.110089743@attica.americas.sgi.com>
	<20080612132700.GA18107@elte.hu>
	<20080612140509.GA21437@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 09:05:09 -0500 Jack Steiner <steiner@sgi.com> wrote:

> On Thu, Jun 12, 2008 at 03:27:00PM +0200, Ingo Molnar wrote:
> > 
> > * steiner@sgi.com <steiner@sgi.com> wrote:
> > 
> > > This series of patches adds a driver for the SGI UV GRU. The driver is 
> > > still in development but it currently compiles for both x86_64 & IA64. 
> > > All simple regression tests pass on IA64. Although features remain to 
> > > be added, I'd like to start the process of getting the driver into the 
> > > kernel. Additional kernel drivers will depend on services provide by 
> > > the GRU driver.
> > > 
> > > The GRU is a hardware resource located in the system chipset. The GRU 
> > > contains memory that is mmaped into the user address space. This 
> > > memory is used to communicate with the GRU to perform functions such 
> > > as load/store, scatter/gather, bcopy, AMOs, etc.  The GRU is directly 
> > > accessed by user instructions using user virtual addresses. GRU 
> > > instructions (ex., bcopy) use user virtual addresses for operands.
> > 
> > did i get it right that it's basically a fast, hardware based message 
> > passing interface that allows two tasks to communicate via DMA and 
> > interrupts, without holding up the CPU? 
> 
> Yes
> 
> 
> > If that is the case, wouldnt the 
> > proper support model be a network driver, instead of these special 
> > ioctls. (a network driver with no checksumming, with scatter-gather, 
> > zero-copy and TSO support, etc.)
> > 
> > or a filesystem. Anything but special-purpose ioctls ...
> 
> The ioctls are not used directly by users.
> 
> Users function the GRU by directly writing to the memory that is mmaped into
> GRU space, ie; load/store directly to GRU space. The ioctls are used
> infrequently by libgru.so to configure the driver during user initialization
> and to handle errors that may occur.
> 
> For example, here is the code that is required to issue a GRU
> instruction & wait for completion:
> 

But could/should it be implemented as (say) a net driver?
