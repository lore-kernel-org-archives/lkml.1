Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbXE0Vzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbXE0Vzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbXE0Vzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:55:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757102AbXE0Vza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:55:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Mon, 28 May 2007 00:01:12 +0200
User-Agent: KMail/1.9.5
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Pavel Machek" <pavel@ucw.cz>, "Alan Stern" <stern@rowland.harvard.edu>,
       "Oliver Neukum" <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <20070527204955.GA22202@srcf.ucam.org> <3ae72650705271449q37f523c3t5980541122ab871@mail.gmail.com>
In-Reply-To: <3ae72650705271449q37f523c3t5980541122ab871@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705280001.13461.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 27 May 2007 23:49, Kay Sievers wrote:
> On 5/27/07, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Sun, May 27, 2007 at 10:31:53PM +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >
> > > Use a hibernation and suspend notifier to disable the firmware requesting
> > > mechanism before a hibernation/suspend and enable it after the operation.
> >
> > This avoids the problem of .resume methods calling userspace while
> > userspace is frozen and a resulting hang, but does it actually result in
> > the drivers beginning to work again? If we remove process freezing in
> > STR, this should just work[1] without the need to complicate things. On
> > the other hand, if we don't want to support these functions in the
> > suspend and resume methods we could just audit the kernel and remove
> > them all.
> 
> What exactly is the problem we see here? The timeout of the firmware loader?
> What goes wrong with frozen userspace, usually there is only a netlink
> message sent from the kernel, which should be received and handled
> just fine when userspace is running again.

Users report the timeout as a problem and it's not that straightforward to
figure out what happens.

Still, I agree it's much better if drivers don't use request_firmware() in
their .resume() routines at all, because they shouldn't rely upon user land at
this point.

Greetings,
Rafael
