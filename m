Return-Path: <linux-kernel-owner+w=401wt.eu-S938572AbXGTWvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938572AbXGTWvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759160AbXGTWvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:51:22 -0400
Received: from ns1.suse.de ([195.135.220.2]:47415 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905AbXGTWvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:51:21 -0400
Date: Fri, 20 Jul 2007 15:50:47 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Message-ID: <20070720225047.GA17520@suse.de>
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 06:32:21PM +0200, Michal Piotrowski wrote:
>  Hi Greg,
> 
>  This looks like a sysfs bug
>  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/00003.jpg
> 
>  l *kernel_param_sysfs_setup+0x75
>  0xc13c0894 is in kernel_param_sysfs_setup (kernel/params.c:570).
>  565             mk->mod = THIS_MODULE;
>  566             kobj_set_kset_s(mk, module_subsys);
>  567             kobject_set_name(&mk->kobj, name);
>  568             kobject_init(&mk->kobj);
>  569             ret = kobject_add(&mk->kobj);
>  570             BUG_ON(ret < 0);
>  571             param_sysfs_setup(mk, kparam, num_params, name_skip);
>  572             kobject_uevent(&mk->kobj, KOBJ_ADD);
>  573     }
>  574
> 
>  http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/mm-config

What kernel version is this happening on?  The -mm tree?  Can you try
Linus's tree instead?

It looks like there was some needed information right before the first
stack dump, showing exactly what kobject was trying to be added that was
already present.  Odds are this is a kernel parameter with the same name
as a duplicate one within the same module, but the trick is going to be
trying to figure out what module is causing this.

So it's not a sysfs bug, but rather a driver issue that this is
catching.

Does that make sense?

greg k-h
