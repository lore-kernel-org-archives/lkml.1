Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072Ab0ARCEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab0ARCEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905Ab0ARCD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:03:58 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:42646 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0ARCD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:03:56 -0500
Date: Sun, 17 Jan 2010 18:03:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-01-13-12-17 uploaded (cgroup)
Message-Id: <20100117180314.247bac92.randy.dunlap@oracle.com>
In-Reply-To: <20100114172006.GA8081@ghc07.ghc.andrew.cmu.edu>
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
	<20100114080748.4eaf91d6.randy.dunlap@oracle.com>
	<20100114172006.GA8081@ghc07.ghc.andrew.cmu.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B53C180.0107:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 12:20:06 -0500 Ben Blum wrote:

> On Thu, Jan 14, 2010 at 08:07:48AM -0800, Randy Dunlap wrote:
> > On Wed, 13 Jan 2010 12:17:36 -0800 akpm@linux-foundation.org wrote:
> > 
> > > The mm-of-the-moment snapshot 2010-01-13-12-17 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://zen-kernel.org/kernel/mmotm.git
> > 
> > 
> > patch:  cgroups-subsystem-module-unloading.patch
> > 
> > When CONFIG_MODULE_UNLOAD is not enabled:
> > 
> > kernel/cgroup.c:1013: error: implicit declaration of function 'module_refcount'
> > 
> > 
> > 
> > ---
> > ~Randy
> > 
> 
> Argh, my fault. try_module_get and module_put tricked me by not
> depending on that config option while module_refcount did. Fix here:
> 
> From: Ben Blum <bblum@andrew.cmu.edu>
> Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 391ff41..32e001e 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -964,7 +964,9 @@ static int rebind_subsystems(struct cgroupfs_root *root,
>  			 * drop the extra reference.
>  			 */
>  			module_put(ss->module);
> +#ifdef CONFIG_MODULE_UNLOAD
>  			BUG_ON(ss->module && !module_refcount(ss->module));
> +#endif
>  		} else {
>  			/* Subsystem state shouldn't exist */
>  			BUG_ON(cgrp->subsys[i]);

Thanks.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
~Randy
