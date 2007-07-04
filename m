Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXGDWt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXGDWt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbXGDWtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:49:50 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33341 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755045AbXGDWtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:49:49 -0400
Date: Thu, 5 Jul 2007 00:49:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Paul Mackerras <paulus@samba.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH -mm] PM: Do not sync from within the freezer during suspend to RAM
Message-ID: <20070704224942.GD2491@elf.ucw.cz>
References: <200707041658.59588.rjw@sisk.pl> <200707050848.16163.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707050848.16163.nigel@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-07-05 08:48:15, Nigel Cunningham wrote:
> Hi.
> 
> On Thursday 05 July 2007 00:58:58 Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The syncing of filesystems from within the freezer in not needed for suspend 
> to
> > RAM.  Change freeze_processes() so that it doesn't execute sys_sync() and
> > introduce the "syncing" version of it to be called from the hibernation code
> > paths.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  include/linux/freezer.h |   14 ++++++++++++--
> >  kernel/power/disk.c     |    2 +-
> >  kernel/power/main.c     |    6 ++++++
> >  kernel/power/process.c  |    8 +++++---
> >  kernel/power/user.c     |    2 +-
> >  5 files changed, 25 insertions(+), 7 deletions(-)
> 
> Looks ok, except that I wonder if you want the following fragment. It looks to 
> me (looking at rc6) like with this code, you'll currently call sys_sync twice 
> when suspending to ram. Maybe I'm misreading it. Also, shouldn't it be done 
> after taking the mutex?

sys_sync() should be okay to call, mutex or not.
									Pavel



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
