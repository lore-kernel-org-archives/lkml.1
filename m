Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbXFOVay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbXFOVay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXFOVaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:30:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57088 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbXFOVap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:30:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Uli Luckas <u.luckas@road.de>
Subject: Re: [PATCH -mm 2/2] PM: Disable usermode helper before hibernation and suspend
Date: Fri, 15 Jun 2007 23:36:45 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706042325.28965.rjw@sisk.pl> <200706042328.27887.rjw@sisk.pl> <200706151508.53191.u.luckas@road.de>
In-Reply-To: <200706151508.53191.u.luckas@road.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152336.46278.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 15 June 2007 15:08, Uli Luckas wrote:
> On Monday, 4. June 2007, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Use a hibernation and suspend notifier to disable the user mode helper
> > before a hibernation/suspend and enable it after the operation.
> >
> Hi Rafael,
> I have a couple of questions, regarding this patch ...
> > -	if (!khelper_wq)
> > +	if (!khelper_wq || usermodehelper_disabled)
> >  		return -EBUSY;
> 1) how about not returning -EBUSY here, if (wait == UMH_NO_WAIT)?

Yes, this would make sense.

> 2) how does your patch prevent wait_for_completion(&done) to hang during
>    freezing if usermodehelper_pm_callback is called _after_ the above check?

It doesn't.  Once the helper is running, we can't distinguish it from any other
user land process.

Still, it narrows the window quite a bit.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
