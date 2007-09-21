Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbXIUNhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbXIUNhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXIUNhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:37:07 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:49264 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbXIUNhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:37:06 -0400
Date: Fri, 21 Sep 2007 14:36:50 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Yinghai.Lu@Sun.COM, bryan.wu@analog.com,
       dilinger@queued.net, kraxel@redhat.com, Gerd Hoffmann <kraxel@suse.de>,
       lethal@linux-sh.org, rgetz@blackfin.uclinux.org, vapier.adi@gmail.com,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] kernel/printk.c: Concerns about the console handover
In-Reply-To: <20070921010349.2caee558.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64N.0709211428300.2724@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl>
 <20070921010349.2caee558.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Andrew Morton wrote:

> It would be useful to have some basic information like: Which kernel
> version was this found in?  Which kernel version last worked?

 The kernel used was a 2.6.23-rc5 snapshot from Sep 4th, 2007 taken from 
the linux-mips.org tree (as stated by the revision of the patch provided).  
There is no version that can be considered working as the change to add 
the printk() to register_console() went in before drivers/serial/zs.c was 
added and the old drivers/tc/zs.c driver might have been to sloppy to 
handle such bits as the transmitter enable properly.  I may investigate.

 Chances are nobody tried any version of the kernel from the period 
between the printk() was added and drivers/tc/zs.c removed with the 
DECstation; I have not.

 Anyway, I did confirm keeping the transmitter enabled all the time makes 
the problem go away.

  Maciej
