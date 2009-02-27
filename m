Return-Path: <linux-kernel-owner+w=401wt.eu-S1757901AbZB0Oqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbZB0Oqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 09:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbZB0OqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 09:46:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53657 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755187AbZB0OqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 09:46:20 -0500
Date: Fri, 27 Feb 2009 09:46:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>,
       Arve Hj?nnev?g <arve@android.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <20090227101632.GG4582@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0902270943490.2926-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009, Pavel Machek wrote:

> 
> > To summarize, we can:
> > * Use a refcount such that automatic suspend will only be possible if it's
> >   equal to zero (but that need not be the only criterion).
> > * Use a per-device flag in dev_pm_info that will be set whenever the device
> >   driver increases the refcount and unset whenever the driver decreases the
> >   refcount.
> > * Use a per-process flag that will be set whenever the process increases the
> >   refcount and unset whenever the process decreases the refcount.
> 
> Yes, that sounds sane, and that's how reasonable wakelock
> implementation should look like.

One small point: If you add a per-device flag and a per-process flag as 
described above, then drivers and processes must not acquire nested 
references.

Obviously this is fixable, but it's worth mentioning...

Alan Stern

