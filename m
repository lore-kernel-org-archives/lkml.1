Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYDMVHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYDMVHJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 17:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYDMVG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 17:06:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:35817 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYDMVGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 17:06:55 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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
In-Reply-To: <200804131533.03150.rjw@sisk.pl>
References: <200804040111.15255.rjw@sisk.pl>
	 <20080412002302.GA27656@kroah.com> <200804131531.11650.rjw@sisk.pl>
	 <200804131533.03150.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 07:05:11 +1000
Message-Id: <1208120711.6958.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-04-13 at 15:33 +0200, Rafael J. Wysocki wrote:
> + *     The PM core executes @prepare() for all devices before starting to
> + *     execute suspend callbacks for any of them, so drivers may assume all of
> + *     the other devices to be present and functional while @prepare() is being
> + *     executed.  In particular, it is safe to make GFP_KERNEL memory
> + *     allocations from within @prepare().  However, drivers may NOT assume
> + *     anything about the availability of the user space at that time and it
> + *     is not correct to request firmware from within @prepare() (it's too
> + *     late to do that).  [To work around this limitation, drivers may
> + *     register suspend and hibernation notifiers that are executed before the
> + *     freezing of tasks.]

Can you tell me why you kept that limitation with user space ?

I don't see the point... On the contrary, prepare() is the pefect place
to implement handshaking with userspace for drivers that need to do so,
such as the DRM.

Ben.

