Return-Path: <linux-kernel-owner+w=401wt.eu-S1764404AbXJRQSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764404AbXJRQSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbXJRQSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:18:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42940 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbXJRQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:18:44 -0400
Date: Thu, 18 Oct 2007 17:18:27 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] serial: do not call ->pm() on initialization for console port
Message-ID: <20071018161827.GB16244@flint.arm.linux.org.uk>
References: <20071019.011355.39154656.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019.011355.39154656.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 01:13:55AM +0900, Atsushi Nemoto wrote:
> This commit in current git tree broke serial console for serial_txx9 driver.
> 
> > commit 97d97224ff361e08777fb33e0fd193ca877dac28
> > Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
> > Date:   Sat Sep 1 21:25:09 2007 +0100
> > 
> >     [SERIAL] Fix console initialisation ordering
> 
> The serial_txx9 driver initialize its port entirely on its ->pm()
> method if new state was 0.  With the commit, serial_core calls ->pm()
> even if the port was used for console.

This'll break some of the ARM drivers, and although I investigated
this a month or so ago, I've completely forgotten the details.

> Attached patch fixes this problem.  Is this a right way?
> If not, I will fix the serial_txx9 driver to skip the initialization in
> ->pm() if oldstate was -1.

I'll have to investigate further to refresh myself with what's going
on here, but your patch looks wrong.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
