Return-Path: <linux-kernel-owner+w=401wt.eu-S1161045AbXAZPdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161045AbXAZPdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 10:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161046AbXAZPdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 10:33:35 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45237 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161045AbXAZPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 10:33:34 -0500
Date: Fri, 26 Jan 2007 09:33:29 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Oleg Nesterov <oleg@tv-sign.ru>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Hokka Zakrisson <daniel@hozac.com>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Message-ID: <20070126153329.GA12550@sergelap.austin.ibm.com>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <45BA1861.4090002@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA1861.4090002@googlemail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michal Piotrowski (michal.k.k.piotrowski@gmail.com):
> Hi Serge,
> 
> akpm@osdl.org napisa?(a):
> > The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> > 
> >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> > 
> > It contains the following patches against 2.6.20-rc6:
> > 
> > origin.patch
> [..]
> > namespaces-fix-exit-race-by-splitting-exit.patch
> [..]
> 
> I'm receiving an error
> 
> In file included from /mnt/md0/devel/linux-work5/include/linux/sched.h:87,
>                  from /mnt/md0/devel/linux-work5/include/linux/utsname.h:35,
>                  from include2/asm/elf.h:12,
>                  from /mnt/md0/devel/linux-work5/include/linux/elf.h:7,
>                  from /mnt/md0/devel/linux-work5/include/linux/module.h:15,
>                  from /mnt/md0/devel/linux-work5/include/linux/crypto.h:21,
>                  from /mnt/md0/devel/linux-work5/arch/i386/kernel/asm-offsets.c:7:
> /mnt/md0/devel/linux-work5/include/linux/nsproxy.h: In function 'preexit_task_namespaces':
> /mnt/md0/devel/linux-work5/include/linux/nsproxy.h:56: error: dereferencing pointer to incomplete type
> make[2]: *** [arch/i386/kernel/asm-offsets.s] Error 1
> make[1]: *** [prepare0] Error 2
> make: *** [_all] Error 2
> 
> Regards,
> Michal

Sorry, I don't know where to get a series file for this patchset?

It sounds like your tree doesn't #include <linux/sched.h> at the top of
include/linux/nsproxy.h.  That was added by a separate patch I think
last week - a few architectures (which i was testing) had a #include chain
which ended up in sched.h being included free, but some arches had a
different chain.

Anyway please try #include <linux/sched.h> at the top of
include/linux/nsproxy.h and let me know if that doesn't fix the problem.

thanks,
-serge
