Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbYAKLYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbYAKLYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760700AbYAKLYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:24:46 -0500
Received: from ns.suse.de ([195.135.220.2]:45955 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411AbYAKLYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:24:45 -0500
Subject: Re: Query on lock protection in random number driver
From: Nikanth Karthikesan <knikanth@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com
In-Reply-To: <47879DA2.BANGALORE.BLR.100.174746A.1.EEA6.1@1:7.BANGALORE.BLR.100.0.1.0.1@16>
References: <1200049691.3844.44.camel@nikanth-laptop.blr.novell.com>
	 <47879DA2.BANGALORE.BLR.100.174746A.1.EEA6.1@1:7.BANGALORE.BLR.100.0.1.0.1@16>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 16:58:28 +0530
Message-Id: <1200050908.3844.56.camel@nikanth-laptop.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-11 at 12:12 +0100, Andi Kleen wrote:
> Nikanth Karthikesan <knikanth@suse.de> writes:
> >
> > Also the globals random_read_wakeup_thresh and
> > random_write_wakeup_thresh are not at all protected by any locks! Why
> > locks are not needed for these?
> 
> Reading variables sizeof <= native word size (32bit or 64bit depending
> on architecture) is atomic by itself. This is not necessarily
> guaranteed in ISO-C or POSIX threads, but Linux can assume that.

Yes, I found that by checking the implementation of atomic_read.

But I didnt check the implementation of atomic_set before sending the
mail and assumed assigning to a variable may not be atomic on all arch,
and because of that, we may be reading a half-written, variable! But
assigning to an int is also atomic on all arch.

Thanks a lot.

Thanks
Nikanth Karthikesan

