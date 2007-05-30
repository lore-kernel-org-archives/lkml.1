Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbXE3U0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbXE3U0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXE3U0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:26:14 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:53538
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751782AbXE3U0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:26:13 -0400
Date: Wed, 30 May 2007 22:28:00 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: axboe@kernel.dk, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] drivers/block/ub.c: use list_for_each_entry()
Message-ID: <20070530202800.GL14284@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	Pete Zaitcev <zaitcev@redhat.com>, axboe@kernel.dk,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070530084752.GE14284@traven> <20070530123840.e54d73c2.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530123840.e54d73c2.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, May 30, 2007 at 12:38:40PM -0700 Pete Zaitcev ha dit:

> On Wed, 30 May 2007 10:47:52 +0200, Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:
> 
> > @@ -1608,8 +1605,7 @@ static void ub_reset_task(struct work_struct *work)
> >  	spin_lock_irqsave(sc->lock, flags);
> >  	sc->reset = 0;
> >  	tasklet_schedule(&sc->tasklet);
> > -	list_for_each(p, &sc->luns) {
> > -		lun = list_entry(p, struct ub_lun, link);
> > +	list_for_each_entry(lun, &sc->luns, link) {
> >  		blk_start_queue(lun->disk->queue);
> >  	}
> >  	wake_up(&sc->reset_wait);
> 
> This patch straddles the border of acceptable. The pointless obfuscation
> is balanced against the removal of explicit type in list_entry() and thus
> a possible mismatched struct. I'm not acking nor naking this.

if i understand you correctly the problem isn't so much the patch, but
the use of list_for_each_entry() in general. i thought
list_for_each_entry() is preferred over list_for_each() when its use
is possible. 

i understand your point, though i think only a chain of errors would
make list_for_each_entry() a problem without being notified by the
compiler:

1) the mismatched struct must have a list_head pointer
2) the name of this list_head pointer must match the name in
list_for_each_entry()
3) the mismatched struct must be 'compatible' with the code in the
loop

please correct me if i misinterpreted the reason of your concerns

regards

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      El trabajo es el refugio de los que no tienen nada que hacer
                            (Oscar Wilde)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
