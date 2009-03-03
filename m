Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZCCN3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZCCN3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753816AbZCCN3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:29:06 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:22668 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZCCN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:29:05 -0500
Date: Tue, 3 Mar 2009 14:28:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add to_delayed_work helper function
Message-ID: <20090303142849.41b7f413@hyperion.delvare>
In-Reply-To: <20090303121138.GB5740@elte.hu>
References: <20090303083440.57df68c3@hyperion.delvare>
	<20090303002952.80f1afc8.akpm@linux-foundation.org>
	<20090303130601.2c8f4bb0@hyperion.delvare>
	<20090303121138.GB5740@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009 13:11:38 +0100, Ingo Molnar wrote:
> 
> * Jean Delvare <khali@linux-fr.org> wrote:
> 
> > It is a fairly common operation to have a pointer to a work and to
> > need a pointer to the delayed work it is contained in. In particular,
> > all delayed works which want to rearm themselves will have to do that.
> > So it would seem fair to offer a helper function for this operation.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> > ---
> > Andrew, does this variant please you better?
> > 
> >  arch/powerpc/kernel/vio.c                               |    2 +-
> >  drivers/crypto/hifn_795x.c                              |    2 +-
> >  drivers/input/mouse/hgpk.c                              |    2 +-
> >  drivers/net/dm9000.c                                    |    2 +-
> >  drivers/net/mlx4/en_netdev.c                            |    2 +-
> >  drivers/net/mlx4/en_rx.c                                |    2 +-
> >  drivers/s390/scsi/zfcp_fc.c                             |    2 +-
> >  drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    8 ++++----
> >  drivers/staging/rtl8187se/r8180_core.c                  |    8 ++++----
> >  drivers/staging/rtl8187se/r8180_dm.c                    |    6 +++---
> >  drivers/usb/wusbcore/devconnect.c                       |    2 +-
> >  include/linux/workqueue.h                               |    5 +++++
> >  mm/slab.c                                               |    3 +--
> >  13 files changed, 25 insertions(+), 21 deletions(-)
> 
> looks good,
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks for the review.

> one small detail:
> 
> > --- linux-2.6.29-rc6.orig/include/linux/workqueue.h	2009-01-29 08:27:20.000000000 +0100
> > +++ linux-2.6.29-rc6/include/linux/workqueue.h	2009-03-03 10:36:53.000000000 +0100
> > @@ -41,6 +41,11 @@ struct delayed_work {
> >  	struct timer_list timer;
> >  };
> >  
> > +static inline struct delayed_work *to_delayed_work(struct work_struct *_work)
> > +{
> > +	return container_of(_work, struct delayed_work, work);
> > +}
> > +
> 
> there's no need to name it _work i think and '*work' should be 
> just fine - this isnt a macro so there's no danger of namespace 
> interactions.

I was too chicken to do it because container_of itself is a macro. But
I tried it and you are correct. Updated patch follows.

-- 
Jean Delvare
