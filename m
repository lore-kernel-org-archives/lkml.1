Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbYDAOnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbYDAOnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbYDAOmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:42:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54639 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755533AbYDAOmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:42:52 -0400
Date: Tue, 1 Apr 2008 10:42:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: Oliver Neukum <oliver@neukum.org>, Sergey Dolgov <solkaa@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: usb-storage, error reading the last 8 sectors, regression in
 2.6.25-rc7
In-Reply-To: <20080401143420.GB20920@one-eyed-alien.net>
Message-ID: <Pine.LNX.4.44L0.0804011040260.4253-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Matthew Dharm wrote:

> On Tue, Apr 01, 2008 at 10:28:52AM -0400, Alan Stern wrote:
> > On Tue, 1 Apr 2008, Oliver Neukum wrote:
> > 
> > > Am Dienstag, 1. April 2008 03:58:31 schrieb Alan Stern:
> > > > Nevertheless, it's clear that the problem has nothing to do with the 
> > > > USB stack.  The real source of the problem lies in the device itself, 
> > > > for reporting a bogus error when in fact nothing went wrong.  That may 
> > > > also explain why you don't always see the problem -- sometimes the 
> > > > device works the way it ought to.
> > > 
> > > Reminds me of the devices that can read the last sector but only if it is read
> > > by itself. Do you reckon this device may have the "opposite" quirk?
> > 
> > Could be something like that.
> 
> Didn't I see some SCSI patches go by to implement exactly this change?
> That is, only read the last sector by itself?

You are getting the two problems mixed up.  The older problem, which
the SCSI patche addressed, was that the device would fail when
accessing the last sector unless the transfer was 1 sector long.

This problem is different.  When performing an 8-sector read that 
includes the last sector, the device succeeds.  When performing a 
7-sector read starting from the same place (so not including the last 
sector), the device fails.

Alan Stern

