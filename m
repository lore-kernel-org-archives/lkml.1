Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbXK0P63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbXK0P63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 10:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbXK0P6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 10:58:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44641 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756452AbXK0P6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 10:58:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 3/6] Suspend: Use common prefix in messages
Date: Tue, 27 Nov 2007 17:16:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200711270025.08128.rjw@sisk.pl> <200711270030.10561.rjw@sisk.pl> <20071127002145.GD9759@elf.ucw.cz>
In-Reply-To: <20071127002145.GD9759@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711271716.14562.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 27 of November 2007, Pavel Machek wrote:
> Hi!
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Make suspend messages start with one common prefix "PM: ".
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> I do not think I like the PREFIX idea (see other message).

The problem is that we use three different types of messages:
- with no prefix at all
- with "PM: "
- with "swsusp: "
and I think that we should use just one, preferably "PM: ".

> > @@ -344,11 +344,12 @@ static int enter_state(suspend_state_t s
> >  	if (!mutex_trylock(&pm_mutex))
> >  		return -EBUSY;
> >  
> > -	printk("Syncing filesystems ... ");
> > +	printk(KERN_INFO PREFIX "Syncing filesystems ... ");
> >  	sys_sync();
> > -	printk("done.\n");
> > +	printk(KERN_INFO "done.\n");
> 
> 
> Plus this is wrong.

Yes, I've had a temporary blackout regarding prinkt(), not even making much
sense ...

I'll resend the entire series in a while.

Greetings,
Rafael
