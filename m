Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbYFPMaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbYFPMaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYFPMaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:30:05 -0400
Received: from atlantis.8hz.com ([212.129.237.78]:57611 "EHLO atlantis.8hz.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbYFPMaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:30:04 -0400
X-Greylist: delayed 1103 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2008 08:30:03 EDT
Date: Mon, 16 Jun 2008 12:11:39 +0000
From: Sean Young <sean@mess.org>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: Regression: boot failure on AMD Elan TS-5500
Message-ID: <20080616121138.GA51097@atlantis.8hz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symptons are either a crash or reboot on booting the kernel. No printk's
have occurred yet -- even with early printk on.

2.6.15 worked on this board however current does not. I've bisected it to:

	commit a24e785111a32ccb7cebafd24b1b1cb474ea8e5d
	Author: Rusty Russell <rusty@rustcorp.com.au>
	Date:   Sun Oct 21 16:41:35 2007 -0700

	    i386: paravirt boot sequence
	    
	    This patch uses the updated boot protocol to do paravirtualized boot.
	    If the boot version is >= 2.07, then it will do two things:
	    
	     1. Check the bootparams loadflags to see if we should reload the
		segment registers and clear interrupts.  This is appropriate
		for normal native boot and some paravirtualized environments, but
		inapproprate for others.
	    
	     2. Check the hardware architecture, and dispatch to the appropriate
		kernel entrypoint.  If the bootloader doesn't set this, then we
		simply do the normal boot sequence.

Unfortunately this patch can't be reverse-applied onto mainline, so I've
tried it on 2.6.24-rc1. 2.6.24-rc1 as-is fails, but with this patch
reverted it does work.

This is the board: 

http://www.embeddedarm.com/products/board-detail.php?product=TS-5500

Regards
Sean
