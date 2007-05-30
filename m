Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbXE3VO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbXE3VO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbXE3VOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:14:20 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:17029 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033AbXE3VOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q6CpNfVbrvywgCIL7Qk3IhUuO6rGYtJjWLOJ9UQtHMBSYChf/lNGMlcLYMGcpu/ENvjyqbZQXGOHHWwPnEoHSRkVSHlg3D0jCxkYImWLLjA+AdPpumbjdpwfIiuW8q13Sh+TPZmRvrNVzM+pSRlbOXx/pHM3NHPqfCDHBiuIndU=
Message-ID: <a781481a0705301414t4a0c1b2epe5e14b62ec8dc872@mail.gmail.com>
Date: Thu, 31 May 2007 02:44:17 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: [PATCH] drivers/block/ub.c: use list_for_each_entry()
Cc: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>, axboe@kernel.dk,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070530123840.e54d73c2.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070530084752.GE14284@traven>
	 <20070530123840.e54d73c2.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pete,

On 5/31/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> On Wed, 30 May 2007 10:47:52 +0200, Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:
>
> > @@ -1608,8 +1605,7 @@ static void ub_reset_task(struct work_struct *work)
> >       spin_lock_irqsave(sc->lock, flags);
> >       sc->reset = 0;
> >       tasklet_schedule(&sc->tasklet);
> > -     list_for_each(p, &sc->luns) {
> > -             lun = list_entry(p, struct ub_lun, link);
> > +     list_for_each_entry(lun, &sc->luns, link) {
> >               blk_start_queue(lun->disk->queue);
> >       }
> >       wake_up(&sc->reset_wait);
>
> This patch straddles the border of acceptable. The pointless obfuscation
> is balanced against the removal of explicit type in list_entry() and thus
> a possible mismatched struct. I'm not acking nor naking this.

A list_for_each() followed by list_entry() ---> list_for_each_entry()
conversion is a pretty harmless (and desirable) conversion, IMO.
In fact list_for_each_entry() itself uses list_entry(..., typeof(*p), ...)
which seems to be a safer way to use list_entry() than specifying
the type explicity/manually in its arguments, no?

Satyam
