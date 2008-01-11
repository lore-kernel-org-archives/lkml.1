Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbYAKMrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbYAKMrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbYAKMrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:47:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50712 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbYAKMrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:47:13 -0500
Date: Fri, 11 Jan 2008 13:49:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com
Subject: Re: Query on lock protection in random number driver
Message-ID: <20080111124949.GA13458@one.firstfloor.org>
References: <1200049691.3844.44.camel@nikanth-laptop.blr.novell.com> <1200050908.3844.56.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200050908.3844.56.camel@nikanth-laptop.blr.novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 04:58:28PM +0530, Nikanth Karthikesan wrote:
> On Fri, 2008-01-11 at 12:12 +0100, Andi Kleen wrote:
> > Nikanth Karthikesan <knikanth@suse.de> writes:
> > >
> > > Also the globals random_read_wakeup_thresh and
> > > random_write_wakeup_thresh are not at all protected by any locks! Why
> > > locks are not needed for these?
> > 
> > Reading variables sizeof <= native word size (32bit or 64bit depending
> > on architecture) is atomic by itself. This is not necessarily
> > guaranteed in ISO-C or POSIX threads, but Linux can assume that.
> 
> Yes, I found that by checking the implementation of atomic_read.
> 
> But I didnt check the implementation of atomic_set before sending the
> mail and assumed assigning to a variable may not be atomic on all arch,
> and because of that, we may be reading a half-written, variable! But
> assigning to an int is also atomic on all arch.

For completeness this both only applies to naturally aligned variables
for portable code.

-Andi
