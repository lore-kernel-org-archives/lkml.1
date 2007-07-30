Return-Path: <linux-kernel-owner+w=401wt.eu-S937260AbXG3CCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937260AbXG3CCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762328AbXG3CBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:01:52 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:56113 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761570AbXG3CBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:01:51 -0400
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.23-rc1
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46AD390B.2080400@garzik.org>
References: <1185720592.3434.7.camel@localhost.localdomain>
	 <46AD19F7.7040905@garzik.org>
	 <1185756759.3434.19.camel@localhost.localdomain>
	 <46AD390B.2080400@garzik.org>
Content-Type: text/plain
Date: Sun, 29 Jul 2007 21:01:49 -0500
Message-Id: <1185760909.3434.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-29 at 21:04 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > msleep_interruptible -> ssleep is a
> > change with zero practical impact for this driver,
> 
> eh, how do you figure?
> 
> A signal can clearly cause the abort-related functions to delay far 
> shorter than the driver wishes.
> 
> The msleep_interruptible() in arcmsr_wait_msgint_ready() probably isn't 
> fatal -- unless it's there to ensure the hardware isn't pounded -- but 
> again, a signal can cause a CPU-wasting busy loop that could last for 
> quite a while (in CPU terms).

I didn't say the usage wasn't a bad example or couldn't cause problems
in certain cases.  I said "zero practical effect".  This is because the
two possible threads that enter these routines already have all user
signals blocked.

James


