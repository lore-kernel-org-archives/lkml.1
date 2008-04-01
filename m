Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYDAWAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYDAWAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYDAV75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:59:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48796 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYDAV74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:59:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 6)
Date: Tue, 1 Apr 2008 23:59:52 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
References: <Pine.LNX.4.44L0.0804011653140.9362-100000@netrider.rowland.org> <1207085886.23143.114.camel@nigel-laptop>
In-Reply-To: <1207085886.23143.114.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804012359.54031.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 1 of April 2008, Nigel Cunningham wrote:
> Hi.
> 
> On Tue, 2008-04-01 at 16:56 -0400, Alan Stern wrote:
> > On Tue, 1 Apr 2008, Rafael J. Wysocki wrote:
> > 
> > > > Does ..._ext_... mean extended? (external?) If 'extended' (or if not),
> > > > does that imply that they're mutually exclusive alternatives for drivers
> > > > to use?
> > > 
> > > 'ext' means 'extended'.  The idea is that the 'extended' version will be used
> > > by bus types / driver types that don't need to implement the _noirq callbacks.
> > 
> > Something's wrong here.  This seems to say that the "extended" version
> > has _fewer_ method pointers -- in which case it should be called 
> > "restricted" instead.
> 
> Agreed.

This was a mistake explained in another message.  The "don't" should not be
present in the above sentence.

> > > > So drivers can never validly fail to resume. That sounds fair enough. If
> > > > the hardware has gone away while in lower power mode (USB, say), should
> > > > the driver then just printk an error and return success?
> > > 
> > > I think so.
> > > 
> > > IMO, an error code returned by a driver's ->resume() should mean "the device
> > > hasn't resumed and is presumably dead".  Otherwise, ->resume() should return
> > > success.
> > 
> > If the device is gone, it doesn't much matter what resume() returns.
> 
> What if the same driver is handling multiple instances and only some of
> them fail to resume?

->resume() will be called separately for each of them.

Thanks,
Rafael
