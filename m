Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZBRPJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZBRPJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZBRPJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:09:28 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49964 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751098AbZBRPJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:09:27 -0500
Date: Wed, 18 Feb 2009 10:09:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <20090218065158.5efa8536@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0902181006150.3186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009, Arjan van de Ven wrote:

> On Wed, 18 Feb 2009 09:53:48 +0100
> Oliver Neukum <oliver@neukum.org> wrote:
> 
> > Am Wednesday 18 February 2009 00:26:53 schrieb Rafael J. Wysocki:
> > > > Another possibility is to set up independent runtime PM for the
> > > > transport and the device.  This means allowing the possibility
> > > > that the transport is suspended while its child (the device) is
> > > > not.  This is a little simpler (there's only one idle-timeout per
> > > > device, since the link is treated as an independent device), but
> > > > it violates the principle of never suspending a parent while
> > > > there is an active child.
> > > 
> > > Well, I think the first approach would be better.
> > 
> > I am afraid it wouldn't be. How do you deal with shared transports?
> > 
> 
> realistically, something like this you need to design like this
> Step 1) Assume the hardware is smart and can do this for you on the fly,
>         but it might need guidance.
>         (For many busses there are platforms that do this)
> Step 2) For hardware that is not smart, emulate the smartness in the
>         driver, with help of the subsystem. These two together have
>         the right knowledge to make such decisions.

Arjan, you're missing the point.  This part of the discussion is 
already focussed on your Step 2.  The question we are concerned with 
is: _How_ shall the driver and subsystem go about emulating the 
smartness?

Oliver's comment is a good one.  The principle of not suspending a
parent with active children has never been set in stone; with care we
should be able to circumvent it.

Alan Stern

