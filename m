Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbYDAIf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbYDAIf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbYDAIfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:35:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:52980 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbYDAIfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:35:18 -0400
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 6)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <1207037741.23143.81.camel@nigel-laptop>
References: <200803292317.50218.rjw@sisk.pl>
	 <200803292320.38378.rjw@sisk.pl> <200803300454.26318.rjw@sisk.pl>
	 <200803312329.03455.rjw@sisk.pl>  <1207037741.23143.81.camel@nigel-laptop>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 19:27:40 +1100
Message-Id: <1207038460.10388.214.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-01 at 19:15 +1100, Nigel Cunningham wrote:
> > + *   However, drivers may NOT assume anything about the availability of the
> > + *   user space at that time and it is not correct to request firmware from
> > + *   within @prepare() (it's too late to do that).
> 
> That doesn't sound good. It would be good to be able to get drivers to
> request firmware early in the process.

Agreed. Prepare() should still allow request_firmware and full userspace
communication / helper usage.

> > + * @complete: Undo the changes made by @prepare().  This method is executed for
> > + *   all kinds of resume transitions, following one of the resume callbacks:
> > + *   @resume(), @thaw(), @restore().  Also called if the state transition
> > + *   fails before the driver's suspend callback (@suspend(), @freeze(),
> > + *   @poweroff()) can be executed (e.g. if the suspend callback fails for one
> > + *   of the other devices that the PM core has unsucessfully attempted to

Ben.


