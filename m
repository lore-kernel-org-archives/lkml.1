Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbZHGXmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbZHGXmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 19:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbZHGXmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 19:42:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38609 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142AbZHGXmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 19:42:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
Date: Sat, 8 Aug 2009 01:42:38 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "dtor@mail.ru" <dtor@mail.ru>
References: <Pine.LNX.4.44L0.0908041330040.3102-100000@iolanthe.rowland.org> <1249436851.2670.422.camel@rzhang-dt>
In-Reply-To: <1249436851.2670.422.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908080142.38226.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 August 2009, Zhang Rui wrote:
> On Wed, 2009-08-05 at 01:33 +0800, Alan Stern wrote:
> > On Tue, 4 Aug 2009, Rafael J. Wysocki wrote:
> > 
> > > Not only that.  I'd like to simplify the design, because IMO using one async
> > > domain would be much more straightforward than using multiple ones.
> > 
> > > If I understand the async framework correctly, the domains are only used for
> > > synchronization, ie. if you want to wait for a group of async operations to
> > > complete, you can put them all into one domain and then call
> > > async_synchronize_full_domain() to wait for them all together.
> > > 
> > > You don't need multiple domains to run multiple things in parallel.
> > 
> > There's a basic confusion going on here.
> > 
> > Rui is using "async domain" to mean a collection of devices which 
> > will be suspended or resumed serially.  Different domains run in 
> > parallel.
> > 
> > Rafael is using "async domain" to mean a collection of devices which 
> > will be suspended or resumed in parallel.  Different domains run 
> > serially.
> > 
> cool, thanks for stating the confusion so clearly, Alan. :)
> 
> Hi, Rafael,
> 
> maybe there is still some confusions about my proposal.
> 
> I re-read kernel/async.c file, and notice that Arjan calls the domain as
> *_synchronization_* domain. sorry I use the wrong word before.
> 
> And I use the synchronization domains just to keep devices dependency.
> 
> First, the general idea is to suspend/resume those slow devices in
> parallel. So we don't suspend/resume them synchronously, instead, we
> move these actions to the global domain.
> 
> Then, I found that these actions can not be run asynchronously because
> they depend on other devices.
> For example, sd depends on SATA controller, we should make sure the PM
> callbacks of sd and ahci sata controller are run serially. so a
> synchronization domain is created for them.
> This is how multiple synchronization domains come from in this proposal.

I think I understand now, thanks.

However, I'd like to avoid any naming confusion in future, so let's follow the
convention of async.c, please.

Best,
Rafael
