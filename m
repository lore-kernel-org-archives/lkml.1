Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbZHLPrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbZHLPrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZHLPrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:47:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44336 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751737AbZHLPrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:47:08 -0400
Date: Wed, 12 Aug 2009 11:47:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Magnus Damm <magnus.damm@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH update] PM: Introduce core framework for run-time PM of
  I/O devices (rev. 15)
In-Reply-To: <aec7e5c30908120337g2928b825m1a17a311a0756305@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0908121145200.9635-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Magnus Damm wrote:

> > --- /dev/null
> > +++ linux-2.6/drivers/base/power/runtime.c
> [...]
> > +int __pm_runtime_suspend(struct device *dev, bool from_wq)
> > +       __releases(&dev->power.lock) __acquires(&dev->power.lock)
> [...]
> > +       if (dev->bus && dev->bus->pm && dev->bus->pm->runtime_suspend) {
> > +               spin_unlock_irq(&dev->power.lock);
> > +
> > +               retval = dev->bus->pm->runtime_suspend(dev);
> > +
> > +               spin_lock_irq(&dev->power.lock);
> > +               dev->power.runtime_error = retval;
> > +       } else {
> > +               retval = -ENOSYS;
> > +       }
> 
> Nit: { and } above do not follow the regular coding style.

As a matter of fact they do.  From Documentation/CodingStyle:


Do not unnecessarily use braces where a single statement will do.

if (condition)
	action();

This does not apply if one branch of a conditional statement is a single
statement. Use braces in both branches.

if (condition) {
	do_this();
	do_that();
} else {
	otherwise();
}


Alan Stern

