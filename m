Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYJDM2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYJDM2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 08:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYJDM2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 08:28:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54542 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbYJDM2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 08:28:00 -0400
Date: Sat, 4 Oct 2008 14:27:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: NeilBrown <neilb@suse.de>, Andre Noll <maan@systemlinux.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mmotm 02/Oct] fix buid error of autodetect_raid()
Message-ID: <20081004122739.GB3728@elte.hu>
References: <20081004190725.CE3E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081004121012.GA582@elte.hu> <20081004211237.CE4D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081004211237.CE4D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Ingo,
> 
> Thank you for very quick responce.
> 
> > > Index: b/init/do_mounts_md.c
> > > ===================================================================
> > > --- a/init/do_mounts_md.c
> > > +++ b/init/do_mounts_md.c
> > > @@ -1,5 +1,6 @@
> > >  
> > >  #include <linux/raid/md.h>
> > > +#include <linux/delay.h>
> > 
> > hm, linux/raid/md.h already has:
> > 
> >   #include <linux/delay.h>
> > 
> > what config triggers this build failure, 
> 
> config attached.
> 
> 
> > and does your version of 
> > include/linux/raid/md.h have a linux/delay.h #include?
> 
> No.
> 
> git-md.patch of current mmotm has following hunk.
> ok, CCing NeilBrown and Andre Noll.
> 
> > diff -puN include/linux/raid/md.h~git-md include/linux/raid/md.h
> > --- a/include/linux/raid/md.h~git-md
> > +++ a/include/linux/raid/md.h
> > @@ -19,27 +19,7 @@
> >  #define _MD_H
> > 
> >  #include <linux/blkdev.h>
> > -#include <linux/major.h>
> > -#include <linux/ioctl.h>
> > -#include <linux/types.h>
> > -#include <linux/bitops.h>
> > -#include <linux/module.h>
> > -#include <linux/hdreg.h>
> > -#include <linux/proc_fs.h>
> >  #include <linux/seq_file.h>
> > -#include <linux/smp_lock.h>
> > -#include <linux/delay.h>
> > -#include <net/checksum.h>
> > -#include <linux/random.h>
> > -#include <linux/kernel_stat.h>
> > -#include <asm/io.h>
> > -#include <linux/completion.h>
> > -#include <linux/mempool.h>
> > -#include <linux/list.h>
> > -#include <linux/reboot.h>
> > -#include <linux/vmalloc.h>
> > -#include <linux/blkpg.h>
> > -#include <linux/bio.h>

ah, that indeed makes sense.

so the build error can not hit the fastboot tree, only if combined with 
the latest raid tree. I've applied your fix to tip/fastboot, thanks!

	Ingo
