Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbYITIOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbYITIOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 04:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYITINu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 04:13:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57485 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbYITINt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 04:13:49 -0400
Date: Sat, 20 Sep 2008 09:13:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Message-ID: <20080920081326.GB11114@flint.arm.linux.org.uk>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-3-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-4-git-send-email-felipe.balbi@nokia.com> <200809191741.44986.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200809191741.44986.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 05:41:44PM -0700, David Brownell wrote:
> On Friday 19 September 2008, Felipe Balbi wrote:
> >  static int omap_wdt_open(struct inode *inode, struct file *file)
> >  {
> > -       struct omap_wdt_dev *wdev;
> > -       void __iomem *base;
> > -       wdev = platform_get_drvdata(omap_wdt_dev);
> > -       base = wdev->base;
> > +       struct omap_wdt_dev *wdev = platform_get_drvdata(omap_wdt_dev);
> > +       void __iomem *base = wdev->base;
> > +
> 
> Oh, I see where "omap_wdt_dev" (global) gets used.  The normal
> way to do stuff like that is using void* pointers placed in the
> inode and file structures for exactly that purpose.

You don't have an inode or a file structure until open() is called -
at which point it _is_ placed in file->private_data.  So this driver
is doing the right thing.
