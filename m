Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbXB0Vvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbXB0Vvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXB0Vvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:51:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbXB0Vvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:51:38 -0500
Date: Tue, 27 Feb 2007 13:49:40 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: ebuddington@wesleyan.edu
Cc: Eric Buddington <ebuddington@verizon.net>, linux-kernel@vger.kernel.org,
       zaitcev@redhat.com
Subject: Re: USB misbehavior causes system hang
Message-Id: <20070227134940.63736039.zaitcev@redhat.com>
In-Reply-To: <20070227140610.GC6850@pool-71-123-99-133.spfdma.east.verizon.net>
References: <20070227140610.GC6850@pool-71-123-99-133.spfdma.east.verizon.net>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 09:06:21 -0500, Eric Buddington <ebuddington@verizon.net> wrote:

> sd 1:0:0:0: rejecting I/O to offline device
> ...
> SoftDog: Initiating system reboot.

> Now, the USB problem may well be a device or cabling issue, but I
> don't think that this drive failure should trigger a reboot - I assume
> the drive failure is somehow constipating the entire disk I/O system,
> and preventing my softdog-patting script from running.

Have you tried ub? In theory, its threadless design is supposed to
help with just this kind of a problem. Please let me know, I'm very
curous.

However, the main issue here is the OOM with all the dirty data.
We saw that before. For some weird reason, ext3 is especially good
at producing the immense amounts of write-out. Are you on ext3 or
VFAT on that drive?

Please try to find the CPU traces by hitting SysRq-w, SysRq-p. CPU
is looping under a lock somewhere and eventually it cases the watchdog
to trigger. It may be a USB issue, maybe a VM issue. I can't tell
until we get stack traces.

This does not help you to deal with the unreliable drive, I'm afraid,
but it would be a great service if you pinned down the reason of looping.

-- Pete
