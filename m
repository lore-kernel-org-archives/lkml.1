Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZJVBgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZJVBgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 21:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZJVBgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 21:36:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43782 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752694AbZJVBgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 21:36:39 -0400
Date: Wed, 21 Oct 2009 21:36:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       <linux-media@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
In-Reply-To: <200910220138.06878.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.44L0.0910212131560.24481-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009, Laurent Pinchart wrote:

> On Wednesday 21 October 2009 22:09:46 Ozan Çağlayan wrote:
> > Laurent Pinchart wrote:
> > > Probably because hal opens the device to query its capabilities and
> > > closes it right after. The driver submits the interrupt URB when the
> > > first user opens the device and cancels it when the last user closes the
> > > device.
> > 
> > So who's guilty now?
> > 
> > :)
> 
> Not me :-)
> 
> I don't think there's anything wrong with submitting an interrupt URB and 
> canceling it soon after.

Nothing wrong at all.  Even if hal didn't do this, the same thing might
very well occur the second time somebody ran a program accessing the
video device.

The real problem will be to figure out why the hardware isn't turning
off the periodic schedule.  It might be a timing issue (the schedule
was running too briefly before the driver tried to disable it).  That
could explain why it shows up only occasionally.  But if it isn't, I
have no idea what the underlying cause is or how to fix it.

Alan Stern

