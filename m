Return-Path: <linux-kernel-owner+w=401wt.eu-S1030378AbXBRGxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030378AbXBRGxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 01:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030383AbXBRGxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 01:53:31 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4354 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030378AbXBRGxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 01:53:30 -0500
Date: Sun, 18 Feb 2007 06:53:18 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Alex Dubov <oakad@yahoo.com>
Cc: Pavel Machek <pavel@ucw.cz>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [mmc] incorrect behavior on resume
Message-ID: <20070218065318.GA14251@flint.arm.linux.org.uk>
Mail-Followup-To: Alex Dubov <oakad@yahoo.com>, Pavel Machek <pavel@ucw.cz>,
	Pierre Ossman <drzeus-mmc@drzeus.cx>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org
References: <20070218002903.GF14773@elf.ucw.cz> <40069.12630.qm@web36708.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40069.12630.qm@web36708.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 05:46:35PM -0800, Alex Dubov wrote:
> The problem here is that mmc_block's device is a child of real device
> (tifm_dev here), so it gets resumed right after it.

The host driver is supposed to call mmc_resume_host from it's resume
callback.  This should be called before the child's resume callback.

> However, it correct functioning depends on mmc_core, which must be
> manually resumed (mmc_resume_host). Therefore, I think this is
> purely mmc's problem.

I don't see that - as I say above, the correct sequence is:

 - host device resume
     - calls mmc_resume_host()
 - child's device resume (mmc_blk_resume)
     - mmc_queue_resume()

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
