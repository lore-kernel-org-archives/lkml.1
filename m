Return-Path: <linux-kernel-owner+w=401wt.eu-S966977AbXEGVaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966977AbXEGVaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966834AbXEGVam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:30:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39626 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966816AbXEGVal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:30:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
Date: Mon, 7 May 2007 23:35:14 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
References: <200705041132.32227.rjw@sisk.pl> <1178538404.7261.16.camel@johannes.berg> <1178538966.7261.18.camel@johannes.berg>
In-Reply-To: <1178538966.7261.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705072335.15357.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 May 2007 13:56, Johannes Berg wrote:
> On Mon, 2007-05-07 at 13:46 +0200, Johannes Berg wrote:
> > On Sat, 2007-05-05 at 15:50 +0200, Rafael J. Wysocki wrote:
> > 
> > > @@ -60,6 +60,9 @@ void hibernation_set_ops(struct hibernat
> > >  	}
> > >  	mutex_lock(&pm_mutex);
> > >  	hibernation_ops = ops;
> > > +	if (ops)
> > > +		hibernation_mode = HIBERNATION_PLATFORM;
> > 
> > 	else if (hibernation_mode == HIBERNATION_PLATFORM)
> > 		hibernation_mode = HIBERNATION_SHUTDOWN;
> 
> Also, you could then simplify all the instances of
>   (hibernation_mode == HIBERNATION_PLATFORM && hibernation_ops) 
> to just
>   (hibernation_mode == HIBERNATION_PLATFORM)
> in various if statements and other places.

No, that's not a good idea, because of the "reduce code duplication patch"
that I'd like to go on top of this.  I'd rather use 'if (hibernation_ops)' here. :-)

Greetings,
Rafael
