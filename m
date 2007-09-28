Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbXI1JHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbXI1JHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755611AbXI1JHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:07:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45747 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbXI1JHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:07:35 -0400
Date: Fri, 28 Sep 2007 02:05:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, roel <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] spin_lock_unlocked cleanups
Message-Id: <20070928020559.6b05f330.akpm@linux-foundation.org>
In-Reply-To: <20070928085347.GB12086@shadowen.org>
References: <46FC2245.50907@tiscali.nl>
	<1190967450.18681.10.camel@chaos>
	<20070928012656.0bae3991.akpm@linux-foundation.org>
	<20070928085347.GB12086@shadowen.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 09:53:47 +0100 Andy Whitcroft <apw@shadowen.org> wrote:

> On Fri, Sep 28, 2007 at 01:26:56AM -0700, Andrew Morton wrote:
> > On Fri, 28 Sep 2007 10:17:30 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > can we please add this to checkpatch.pl ? 
> > > 
> > > > -spinlock_t bpci_lock = SPIN_LOCK_UNLOCKED;
> > > > +DEFINE_SPINLOCK(bpci_lock);
> > 
> > That check is already in checkpatch.  Problem is that hardly anyone
> > runs the thing.
> > 
> > I think we're ready to wire checkpatch up to a email robot which monitors
> > the mailing lists and sends people nastygrams.  I bet that'll be popular ;)
> 
> That shouldn't be too hard.  checkpatch has been subscribed since birth
> but short circuiting the replies to me only.
> 
> I guess the main question is whether to reply-all or reply just to the
> sender when commenting on patches.  Perhaps for the sanity of the rest
> of the world, just the sender makes most sense.

For sure.

> > (I'd love it if it could detect wordwrapped and tab-expanded patches, too. 
> > You wouldn't _believe_...)
> 
> It should pick up both of these, the word-wrapping is already there as
> we detect lines within patch segments which don't start '[ +-]', the
> tab-expanded should be picked up as every line would be "don't use
> spaces use tabs for indent".

OK.

Often patches are wordwrapped only in the header:

--- old/drivers/ata/libata-sff.c	2007-04-26 12:02:46.000000000 -0400
+++ linux/drivers/ata/libata-sff.c	2007-04-29 08:29:27.000000000 -0400
@@ -413,6 +413,24 @@
 	ap->ops->irq_on(ap);

comes through as

--- old/drivers/ata/libata-sff.c	2007-04-26
12:02:46.000000000 -0400
+++ linux/drivers/ata/libata-sff.c	2007-04-29
08:29:27.000000000 -0400
@@ -413,6 +413,24 @@
 	ap->ops->irq_on(ap);

and the rest of the patch is good.

<tests it>

Yup, fooled you ;)
