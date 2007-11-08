Return-Path: <linux-kernel-owner+w=401wt.eu-S1759934AbXKHJJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934AbXKHJJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759901AbXKHJIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:08:54 -0500
Received: from mout0.freenet.de ([195.4.92.90]:51118 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758911AbXKHJIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:08:50 -0500
To: "Peter Osterlund" <petero2@telia.com>, "Tejun Heo" <htejun@gmail.com>
From: balagi@justmail.de
Subject: Re: Re: pktcdvd oops
Cc: "Thomas Maier" <balagi@justmail.de>, "Jens Axboe" <jens.axboe@oracle.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, gregkh@suse.de
X-Priority: 3
X-Abuse: 300631278 / 195.140.123.22
User-Agent: freenetMail
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1Iq3NN-00049L-8x@www16.emo.freenet-rz.de>
Date: Thu, 08 Nov 2007 10:08:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

tested it too, running linux 2.6.23 in a qemu instance, and the patch worked.
But i would prefer to take the try_module_get() stuff into pkt_setup_dev() because
it is used also in the older procfs interface. Can we run into the same problem here, means
procfs holds no module references too, like sysfs now?

Maybe also the "/sys/class/pktcdvd/remove" command should be wrapped with an
try_module_get() ???

-Thomas

----- original Nachricht --------

Betreff: Re: pktcdvd oops
Gesendet: Mi 07 Nov 2007 23:07:10 CET
Von: "Peter Osterlund"<petero2@telia.com>

> On Wed, 7 Nov 2007, Tejun Heo wrote:
> 
> > Peter Osterlund wrote:
> >> If the
> >> __module_get() is not safe because the module code could have already
> >> been unloaded, how can it possibly be made safe by adding more code to
> >> the pktcdvd module? If the module is unloaded, trying to execute its
> >> code can't be a good thing no matter what the code does.
> >
> > sysfs itself is now out of module lifespan rules.  sysfs callbacks are
> > guaranteed to stay in memory while running by sysfs node removal waiting
> > for completion of in-flight operations before returning.  In pktcdvd's
> > case, class_destroy() call in pkt_sysfs_cleanup() will wait for all
> > in-flight sysfs r/w ops to complete.
> >
> > So, even while sysfs callbacks are executing, the module beneath can die
> > but it will stay in memory till all the callbacks return.  You need to
> > test module liveness using try_module_get() (and it can fail) if you
> > want to grab module reference from sysfs callbacks.
> 
> Thanks for the explanation.
> 
> Given that explanation, I think the patch is correct and it does fix the 
> BUG on my computer. Can you please push it upstream?
> 
> In any case:
> 
> Acked-by: Peter Osterlund <petero2@telia.com>
> 
> -- 
> Peter Osterlund - petero2@telia.com
> http://web.telia.com/~u89404340
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

--- original Nachricht Ende ----









