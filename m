Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbXDPVec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbXDPVec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbXDPVec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:34:32 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2458 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbXDPVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:34:31 -0400
Date: Mon, 16 Apr 2007 22:34:21 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Anton Vorontsov <cbou@mail.ru>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 7/7] [RFC] APM emulation driver for class batteries
Message-ID: <20070416213421.GA32258@flint.arm.linux.org.uk>
Mail-Followup-To: Anton Vorontsov <cbou@mail.ru>,
	linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
References: <20070411232644.GG20095@zarina> <20070413135005.GE20618@zarina> <20070416202421.GC19713@flint.arm.linux.org.uk> <20070416210829.GA5107@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416210829.GA5107@zarina>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 01:08:29AM +0400, Anton Vorontsov wrote:
> On Mon, Apr 16, 2007 at 09:24:21PM +0100, Russell King wrote:
> > Utterly unsafe.  What happens if some other module gets loaded which
> > does this, and then this module is unloaded followed by the other
> > module.  Result: Oops.
> 
> Right. And loading two modules which changing apm_get_power_status
> is a race already. Thus, APM interface needs a mutex.
> 
> Or pda_power should be marked "bool" in Kconfig, as it is done
> in arch/arm/common/sharpsl_pm.c. Sharpsl_pm is safe only because it
> can't be a module.
> 
> Personally I'd keep things as is for now (i.e. I'd want tristate for
> PDA_POWER, not bool). Later APM API can be fixed.

Experience shows "Later" more often than not means "never", inspite
of what is said at the time the word is used...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
