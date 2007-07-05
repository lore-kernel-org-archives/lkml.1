Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbXGELV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbXGELV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbXGELVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:21:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52849 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbXGELVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:21:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@suspend2.net
Subject: Re: [RFC][PATCH -mm] PM: Do not sync from within the freezer during suspend to RAM
Date: Thu, 5 Jul 2007 13:28:49 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Paul Mackerras <paulus@samba.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Ingo Molnar <mingo@elte.hu>
References: <200707041658.59588.rjw@sisk.pl> <20070704224942.GD2491@elf.ucw.cz> <200707050852.15392.nigel@nigel.suspend2.net>
In-Reply-To: <200707050852.15392.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051328.50845.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 00:52, Nigel Cunningham wrote:
> Hi.
> 
> On Thursday 05 July 2007 08:49:42 Pavel Machek wrote:
> > On Thu 2007-07-05 08:48:15, Nigel Cunningham wrote:
> > > Hi.
> > > 
> > > On Thursday 05 July 2007 00:58:58 Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > The syncing of filesystems from within the freezer in not needed for 
> suspend 
> > > to
> > > > RAM.  Change freeze_processes() so that it doesn't execute sys_sync() 
> and
> > > > introduce the "syncing" version of it to be called from the hibernation 
> code
> > > > paths.
> > > > 
> > > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > ---
> > > >  include/linux/freezer.h |   14 ++++++++++++--
> > > >  kernel/power/disk.c     |    2 +-
> > > >  kernel/power/main.c     |    6 ++++++
> > > >  kernel/power/process.c  |    8 +++++---
> > > >  kernel/power/user.c     |    2 +-
> > > >  5 files changed, 25 insertions(+), 7 deletions(-)
> > > 
> > > Looks ok, except that I wonder if you want the following fragment. It 
> looks to 
> > > me (looking at rc6) like with this code, you'll currently call sys_sync 
> twice 
> > > when suspending to ram. Maybe I'm misreading it. Also, shouldn't it be 
> done 
> > > after taking the mutex?
> > 
> > sys_sync() should be okay to call, mutex or not.
> 
> Yeah. That wasn't my point, sorry. Calling sys_sync is pointless if you're 
> going to fail to take the mutex. It makes more sense to know you've got it 
> before you start doing things related to actually suspending.

Well, that's a valid point, I'll move it under the mutex.

And why do you think it will be called twice?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
