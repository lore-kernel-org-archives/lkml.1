Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbYDAVi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbYDAVi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760987AbYDAVhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:37:43 -0400
Received: from mail.crca.org.au ([67.207.131.56]:37792 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760241AbYDAVhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:37:41 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 6)
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <Pine.LNX.4.44L0.0804011653140.9362-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0804011653140.9362-100000@netrider.rowland.org>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Wed, 02 Apr 2008 08:38:06 +1100
Message-Id: <1207085886.23143.114.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2008-04-01 at 16:56 -0400, Alan Stern wrote:
> On Tue, 1 Apr 2008, Rafael J. Wysocki wrote:
> 
> > > Does ..._ext_... mean extended? (external?) If 'extended' (or if not),
> > > does that imply that they're mutually exclusive alternatives for drivers
> > > to use?
> > 
> > 'ext' means 'extended'.  The idea is that the 'extended' version will be used
> > by bus types / driver types that don't need to implement the _noirq callbacks.
> 
> Something's wrong here.  This seems to say that the "extended" version
> has _fewer_ method pointers -- in which case it should be called 
> "restricted" instead.

Agreed.

> > > So drivers can never validly fail to resume. That sounds fair enough. If
> > > the hardware has gone away while in lower power mode (USB, say), should
> > > the driver then just printk an error and return success?
> > 
> > I think so.
> > 
> > IMO, an error code returned by a driver's ->resume() should mean "the device
> > hasn't resumed and is presumably dead".  Otherwise, ->resume() should return
> > success.
> 
> If the device is gone, it doesn't much matter what resume() returns.

What if the same driver is handling multiple instances and only some of
them fail to resume?

Regards,

Nigel

