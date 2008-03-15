Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYCODbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYCODbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 23:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYCODbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 23:31:08 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:42504 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbYCODbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 23:31:06 -0400
Date: Sat, 15 Mar 2008 04:29:30 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] NTP4 user space bits update
In-Reply-To: <1205527012.6122.17.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0803150422200.1791@scrub.home>
References: <20080314184001.695807682@linux-m68k.org> 
 <20080314195736.853114795@linux-m68k.org> <1205527012.6122.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 14 Mar 2008, john stultz wrote:

> > -	  /* singleshot must not be used with any other mode bits */
> > -		if (txc->modes != ADJ_OFFSET_SINGLESHOT &&
> > -					txc->modes != ADJ_OFFSET_SS_READ)
> > +		/* singleshot must not be used with any other mode bits */
> > +		if (txc->modes & ~ADJ_OFFSET_SS_READ)
> >  			return -EINVAL;
> 
> This could probably go in the cleanup patch, no?

It does more than simple code indentation and refactoring, so I didn't 
want to include it there.

> > -#if 0	/* STA_CLOCKERR is never set yet */
> > -	time_status &= ~STA_CLOCKERR;		/* reset STA_CLOCKERR */
> > -#endif
> 
> This as well is just cleanup.

Debatable, it refers to user space APIs, so I included it here.

> > +		if (txc->modes & ADJ_STATUS) {
> > +			if ((time_status & STA_PLL) &&
> > +			    !(txc->status & STA_PLL)) {
> > +				time_state = TIME_OK;
> > +				time_status = STA_UNSYNC;
> > +			}
> > +			/* only set allowed bits */
> > +			time_status &= STA_RONLY;
> > +			time_status |= txc->status & ~STA_RONLY;
> > +		}
> 
> More cleanup.

Not really.

bye, Roman
