Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYEZR7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYEZR7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYEZR70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:59:26 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:12951 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbYEZR70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:59:26 -0400
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linville@tuxdriver.com, rusty@rustcorp.com.au, matthew@wil.cx,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, arjan@infradead.org
In-Reply-To: <20080526192914.31045d09@brian.englab.brq.redhat.com>
References: <20080522232103.120033152@mvista.com>
	 <20080526192914.31045d09@brian.englab.brq.redhat.com>
Content-Type: text/plain
Date: Mon, 26 May 2008 10:59:23 -0700
Message-Id: <1211824763.18130.234.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-26 at 19:29 +0200, Michal Schmidt wrote:
> On Thu, 22 May 2008 16:21:03 -0700
> Daniel Walker <dwalker@mvista.com> wrote:
> 
> > Signed-off-by: Daniel Walker <dwalker@mvista.com>
> >  
> > ---
> >  drivers/net/wireless/airo.c |  107
> > ++++++++++++++++++++++---------------------- 1 file changed, 54
> > insertions(+), 53 deletions(-)
> > 
> > Index: linux-2.6.25/drivers/net/wireless/airo.c
> > ===================================================================
> > --- linux-2.6.25.orig/drivers/net/wireless/airo.c
> > +++ linux-2.6.25/drivers/net/wireless/airo.c
> 
> > @@ -3211,7 +3212,7 @@ static irqreturn_t airo_interrupt(int ir
> >  				set_bit(FLAG_UPDATE_UNI,
> > &apriv->flags); set_bit(FLAG_UPDATE_MULTI, &apriv->flags);
> >  
> > -				if (down_trylock(&apriv->sem) != 0) {
> > +				if (mutex_trylock(&apriv->lock) ==
> > 0) { set_bit(JOB_EVENT, &apriv->jobs);
> >  					wake_up_interruptible(&apriv->thr_wait);
> >  				} else
> 
> 
> Mutexes are not allowed in interrupt context, not even mutex_trylock.

I know .. I must have missed that it was in ISR .. Thanks for noticing
it.

Daniel

