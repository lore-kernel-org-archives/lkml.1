Return-Path: <linux-kernel-owner+w=401wt.eu-S933534AbYAaXQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbYAaXQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYAaXQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:16:46 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:15338 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754345AbYAaXQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:16:45 -0500
Date: Fri, 1 Feb 2008 08:15:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: Always build in kernel/ksysfs.o.
Message-ID: <20080131231554.GA16399@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20080131091234.GA14631@linux-sh.org> <20080131170344.GA20966@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131170344.GA20966@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 09:03:44AM -0800, Greg KH wrote:
> On Thu, Jan 31, 2008 at 06:12:34PM +0900, Paul Mundt wrote:
> > kernel/ksysfs.c seems to be a random dumping group for misc globals
> > that the rest of the tree depend on. This has caused problems with
> > exports in the past when sysfs is disabled, which can already be
> > observed in commit-id 51107301b629640f9ab76fe23bf385e187b9ac29.
> > 
> > The latest one is the kernel_kobj usage, which presently results in:
> > 
> > fs/built-in.o: In function `debugfs_init':
> > inode.c:(.init.text+0xc34): undefined reference to `kernel_kobj'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > kernel/ksysfs.c itself at this point only contains globals and some
> > basic sysfs initialization, the sysfs initialization code is optimized
> > out when we build with sysfs disabled. Given that, it's easier to just
> > build in unconditionally, rather than trying to find some other random
> > place to dump and initialize the globals.
> > 
> > Additionally, the current trend seems to be decoupling of kobjects from
> > sysfs, in which case it still makes sense to perform the kernel_kobj
> > initialization that happens here even if sysfs is disabled, as
> > lib/kobject.o is built-in unconditionally.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> I'll take this, it looks right, but I don't think it fixes the
> kernel_kobj problem, that shows up in a number of other places too.  I'm
> working on fixing that up properly right now, give me a day, I'm doing
> builds with tons of different kernel options :)
> 
Thanks. At least it makes the link error go away, which is the only
kernel_kobj problem I had. If there's a greater conceptual problem with
kernel_kobj, that's out of scope for this patch, and I defer to you on
such matters ;-)
