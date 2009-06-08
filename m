Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZFHPhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZFHPhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZFHPhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:37:16 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:35910 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbZFHPhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:37:13 -0400
Date: Mon, 8 Jun 2009 17:36:11 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 01/38] pm: Move nvs routines into a seperate file.
Message-ID: <20090608173611.16238cf9@gondolin>
In-Reply-To: <20090608063501.GC1444@ucw.cz>
References: <20090604161847.513682672@de.ibm.com>
	<20090604161859.713228968@de.ibm.com>
	<20090608063501.GC1444@ucw.cz>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 08:35:01 +0200,
Pavel Machek <pavel@ucw.cz> wrote:

> On Thu 2009-06-04 18:18:48, Martin Schwidefsky wrote:
> > From: Cornelia Huck <cornelia.huck@de.ibm.com>
> > 
> > The *_nvs_* routines in swsusp.c make use of the io*map()
> > functions, which are only provided for HAS_IOMEM, thus
> > breaking compilation if HAS_IOMEM is not set. Fix this
> > by moving the *_nvs_* routines into nvs.c, which is only
> > compiled if HAS_IOMEM is set.
> > 
> > Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > ---
> >  include/linux/suspend.h |   18 ++++--
> >  kernel/power/Kconfig    |    4 +
> >  kernel/power/Makefile   |    1 
> >  kernel/power/nvs.c      |  131 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  kernel/power/swsusp.c   |  122 --------------------------------------------
> >  5 files changed, 147 insertions(+), 129 deletions(-)
> > 
> > Index: linux-2.6/kernel/power/nvs.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6/kernel/power/nvs.c
> 
> Ideally, filename would be a bit more descriptive. 

hibernate_nvs.c?

> 
> > @@ -0,0 +1,131 @@
> > +/*
> > + * Routines for NVS memory handling
> > + */
> 
> If you copy&pasted code, you need to copy&paste copyright notices, too.

Which ones? Rafael, it seems you wrote the NVS code - which copyright
should I use?

> 
> > --- linux-2.6.orig/kernel/power/Makefile
> > +++ linux-2.6/kernel/power/Makefile
> > @@ -7,5 +7,6 @@ obj-$(CONFIG_PM)		+= main.o
> >  obj-$(CONFIG_PM_SLEEP)		+= console.o
> >  obj-$(CONFIG_FREEZER)		+= process.o
> >  obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
> > +obj-$(CONFIG_NVS)		+= nvs.o
> >  
> >  obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
> 
> CONFIG_NVS is definitely not descriptive enough. C_HIBERNATION_NVS?

It's a hidden config variable - but I can change it to
CONFIG_HIBERNATION_NVS.
