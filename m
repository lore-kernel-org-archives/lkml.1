Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbYDAU5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbYDAU5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYDAU46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:56:58 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3858 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752672AbYDAU45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:56:57 -0400
Date: Tue, 1 Apr 2008 16:56:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 6)
In-Reply-To: <200804012212.48609.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0804011653140.9362-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Rafael J. Wysocki wrote:

> > Does ..._ext_... mean extended? (external?) If 'extended' (or if not),
> > does that imply that they're mutually exclusive alternatives for drivers
> > to use?
> 
> 'ext' means 'extended'.  The idea is that the 'extended' version will be used
> by bus types / driver types that don't need to implement the _noirq callbacks.

Something's wrong here.  This seems to say that the "extended" version
has _fewer_ method pointers -- in which case it should be called 
"restricted" instead.

> > So drivers can never validly fail to resume. That sounds fair enough. If
> > the hardware has gone away while in lower power mode (USB, say), should
> > the driver then just printk an error and return success?
> 
> I think so.
> 
> IMO, an error code returned by a driver's ->resume() should mean "the device
> hasn't resumed and is presumably dead".  Otherwise, ->resume() should return
> success.

If the device is gone, it doesn't much matter what resume() returns.

Alan Stern

