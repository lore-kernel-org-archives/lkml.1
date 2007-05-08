Return-Path: <linux-kernel-owner+w=401wt.eu-S967006AbXEHLAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967006AbXEHLAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 07:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966461AbXEHLAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 07:00:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42483 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966404AbXEHLAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 07:00:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
Date: Tue, 8 May 2007 13:05:16 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
References: <200705041132.32227.rjw@sisk.pl> <200705072335.15357.rjw@sisk.pl> <1178613696.18162.28.camel@johannes.berg>
In-Reply-To: <1178613696.18162.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705081305.17628.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 May 2007 10:41, Johannes Berg wrote:
> On Mon, 2007-05-07 at 23:35 +0200, Rafael J. Wysocki wrote:
> 
> > > Also, you could then simplify all the instances of
> > >   (hibernation_mode == HIBERNATION_PLATFORM && hibernation_ops) 
> > > to just
> > >   (hibernation_mode == HIBERNATION_PLATFORM)
> > > in various if statements and other places.
> > 
> > No, that's not a good idea, because of the "reduce code duplication patch"
> > that I'd like to go on top of this.  I'd rather use 'if (hibernation_ops)' here. :-)
> 
> But if you want the user to be able to change away from 'platform' mode
> you still have to have
>   if (hibernation_ops && hibernation_mode == HIBERNATION_PLATFORM)
> in most places, no?

Yes, and that's why I'm not going to change that.  The code from user.c is also
going to call these functions in the future, so the full test is necessary.

For now, I'll only add the 'else if' check to hibernation_set_ops().

Greetings,
Rafael
