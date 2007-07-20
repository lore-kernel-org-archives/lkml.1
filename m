Return-Path: <linux-kernel-owner+w=401wt.eu-S936067AbXGTW7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936067AbXGTW7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbXGTW7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:59:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbXGTW7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:59:22 -0400
Date: Fri, 20 Jul 2007 15:59:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Message-Id: <20070720155912.079c5a27.akpm@linux-foundation.org>
In-Reply-To: <20070720225047.GA17520@suse.de>
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	<20070720225047.GA17520@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 15:50:47 -0700
Greg KH <gregkh@suse.de> wrote:

> On Fri, Jul 20, 2007 at 06:32:21PM +0200, Michal Piotrowski wrote:
> >  Hi Greg,
> > 
> >  This looks like a sysfs bug
> >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/00003.jpg
> > 
> >  l *kernel_param_sysfs_setup+0x75
> >  0xc13c0894 is in kernel_param_sysfs_setup (kernel/params.c:570).
> >  565             mk->mod = THIS_MODULE;
> >  566             kobj_set_kset_s(mk, module_subsys);
> >  567             kobject_set_name(&mk->kobj, name);
> >  568             kobject_init(&mk->kobj);
> >  569             ret = kobject_add(&mk->kobj);
> >  570             BUG_ON(ret < 0);
> >  571             param_sysfs_setup(mk, kparam, num_params, name_skip);
> >  572             kobject_uevent(&mk->kobj, KOBJ_ADD);
> >  573     }
> >  574
> > 
> >  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/mm-config
> 
> What kernel version is this happening on?  The -mm tree?  Can you try
> Linus's tree instead?
> 
> It looks like there was some needed information right before the first
> stack dump, showing exactly what kobject was trying to be added that was
> already present.  Odds are this is a kernel parameter with the same name
> as a duplicate one within the same module, but the trick is going to be
> trying to figure out what module is causing this.
> 
> So it's not a sysfs bug, but rather a driver issue that this is
> catching.

In that case a BUG was way too harsh treatment, and in fact directly
contributed to our inability to debug the bug!

Can we wind that back a bit?  Add some useful printks and then recover
in some fashion?

