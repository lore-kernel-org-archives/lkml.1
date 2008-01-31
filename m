Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbYAaRFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbYAaRFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760169AbYAaRFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:05:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37564 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbYAaRFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:05:17 -0500
Date: Thu, 31 Jan 2008 09:03:44 -0800
From: Greg KH <greg@kroah.com>
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: Always build in kernel/ksysfs.o.
Message-ID: <20080131170344.GA20966@kroah.com>
References: <20080131091234.GA14631@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131091234.GA14631@linux-sh.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 06:12:34PM +0900, Paul Mundt wrote:
> kernel/ksysfs.c seems to be a random dumping group for misc globals
> that the rest of the tree depend on. This has caused problems with
> exports in the past when sysfs is disabled, which can already be
> observed in commit-id 51107301b629640f9ab76fe23bf385e187b9ac29.
> 
> The latest one is the kernel_kobj usage, which presently results in:
> 
> fs/built-in.o: In function `debugfs_init':
> inode.c:(.init.text+0xc34): undefined reference to `kernel_kobj'
> make: *** [.tmp_vmlinux1] Error 1
> 
> kernel/ksysfs.c itself at this point only contains globals and some
> basic sysfs initialization, the sysfs initialization code is optimized
> out when we build with sysfs disabled. Given that, it's easier to just
> build in unconditionally, rather than trying to find some other random
> place to dump and initialize the globals.
> 
> Additionally, the current trend seems to be decoupling of kobjects from
> sysfs, in which case it still makes sense to perform the kernel_kobj
> initialization that happens here even if sysfs is disabled, as
> lib/kobject.o is built-in unconditionally.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

I'll take this, it looks right, but I don't think it fixes the
kernel_kobj problem, that shows up in a number of other places too.  I'm
working on fixing that up properly right now, give me a day, I'm doing
builds with tons of different kernel options :)

thanks,

greg k-h
