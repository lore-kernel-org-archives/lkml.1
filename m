Return-Path: <linux-kernel-owner+w=401wt.eu-S2992540AbXCGXG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992540AbXCGXG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992709AbXCGXG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:06:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992540AbXCGXG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:06:58 -0500
Date: Wed, 7 Mar 2007 15:02:27 -0800
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: ebuddington@wesleyan.edu, Oliver Neukum <oneukum@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4 +
 USB HD
Message-Id: <20070307150227.e5395d6c.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.44L0.0703071713220.9831-100000@iolanthe.rowland.org>
References: <20070307204722.GA3605@pool-71-123-121-36.spfdma.east.verizon.net>
	<Pine.LNX.4.44L0.0703071713220.9831-100000@iolanthe.rowland.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 17:18:29 -0500 (EST), Alan Stern <stern@rowland.harvard.edu> wrote:

> I've never heard of a process failing to show up in a SysRq-t listing.  It 
> suggests something is wrong with the process management in the kernel you 
> were using.  That leads me to think a non -mm kernel might give more 
> informative results.

I think, if a process is looping, it's not shown in SysRq-t. So maybe
khubd is on a CPU.

In RHEL we have a patch for SysRq-w, which showed all CPU states by
the way of a special IPI (unless looping with closed interrups, of course).
But this capability seems a bit degraded in stock SysRq-w. It might not
catch this (does not seem for me in 2.6.20).

Another possibility is, something killed khubd. It's only a process
after all. Remember how we had grief with it being killed by "telinit 1".

-- Pete
