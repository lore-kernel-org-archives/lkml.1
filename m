Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYDMXHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYDMXHn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 19:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYDMXHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 19:07:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbYDMXHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 19:07:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 01:08:04 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804040111.15255.rjw@sisk.pl> <200804140027.12161.rjw@sisk.pl> <1208126822.6958.63.camel@pasglop>
In-Reply-To: <1208126822.6958.63.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200804140108.05447.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Benjamin Herrenschmidt wrote:
> 
> > Well, I'm not sure and I'm not going to introduce the change right now, after
> > the paches have been included in -mm.
> > 
> > That would require quite some changes in the core code that I'd prefer to
> > avoid for now.  We can do something like this in a separate patch series after
> > the present one settles down a bit.
> 
> I disagree.

Okay, so we have different opinions. :-)
 
> Doing it later would introduce yet another major semantic change.
>
> I think we should get it right now. There's no hurry in pushing things
> especially if they aren't quite right.

>From my point of view, they are as right as they can be at the moment.

Besides, maintainig a set of patches like this so that it always applies to
a tree that's continuously changing under it is far from funny.  I'm not going
to do it much longer, that's for sure.

> The ability for prepare() callbacks to sync with userland,
> request_firmware, etc... is an important feature that's been needed for
> some time imho.

Well, if we put ->prepare() before the freezer, what can it actually do?
Certainly nothing that will block any (user space) task, because the freezer
won't work after that.  So, all of the significant suspend work, like blocking
tasks using the device etc., will have to be done by ->suspend().  Will that be
convenient?  I'm not sure.  I'm not even sure that would be _doable_ at all.

The point of view depends on what you think ->prepare() should be used for
and I'm sure you have some specific cases in mind.  However, are they generic
enough?

Thanks,
Rafael
