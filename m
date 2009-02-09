Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbZBIG77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbZBIG77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 01:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbZBIG7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 01:59:50 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53529 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZBIG7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 01:59:49 -0500
Date: Mon, 9 Feb 2009 15:56:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
Subject: Re: [PATCH] sh: maple: add support for Visual Memory Card devices, and make consequential changes to maple input drivers - 2/3 - v5
Message-ID: <20090209065632.GA21980@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Greg KH <greg@kroah.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
	MTD <linux-mtd@lists.infradead.org>,
	linux-sh <linux-sh@vger.kernel.org>,
	linux-input <linux-input@vger.kernel.org>
References: <1234122069.6736.8.camel@localhost.localdomain> <1234123473.6736.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234123473.6736.29.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 08:04:33PM +0000, Adrian McMenamin wrote:
> Change the maple bus driver to support the visual memory unit driver.
> 
> The maple bus driver currently only supports synchronous polling of attached devices status. These changes allow
> the bus to handle asynchronous commands such as block reads and writes. 
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

The ordering of your patch series is a bit vague. Do the changes to the
maple bus code need to be made before the VMU patch can be applied? Do
the input driver changes have to be made at the same time as the changes
to the bus code, or are they ok to leave as a separate patch after the
bus changes?

All of these seem to have some interdependency issues that haven't been
noted at all, making it incredibly difficult to apply incrementally. Your
subject for the series also seems to imply you have no idea how they
logically structure, and that you simply hacked things up until the point
where everything worked, rather than paying attention to logical
incremental changes to show how you got from point A to point B without
breaking bisection along the way.

We do not want to have the tree in a state where bisection is broken, nor
do we want to apply huge monolothic changes that are unable to be clearly
broken out.

At this point the maple bus stuff I am fine with, and I have no real
objections to the driver patches either, it is more your methodology or
lack thereof that makes dealing with this rather taxing. If you want your
patches applied, small incremental patches that don't leave the tree in a
broken state are the way to go.

Presently I have no idea how to split this series up, and even if the
other subsystem folks add their Acked-bys, this will not be going in as
one large change.
