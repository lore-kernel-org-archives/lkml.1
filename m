Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbZLWQOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbZLWQOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZLWQOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:14:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51477 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbZLWQOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:14:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [Regression, 2.6.33-rc1->current git] NULL pointer in usb_serial_probe() introduced by the recent kfifo changes
Date: Wed, 23 Dec 2009 17:15:11 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc1-tst; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200912230251.31568.rjw@sisk.pl> <20091223053734.GC22808@kroah.com>
In-Reply-To: <20091223053734.GC22808@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912231715.11372.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 December 2009, Greg KH wrote:
> On Wed, Dec 23, 2009 at 02:51:31AM +0100, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > Something like the patch below is necessary to fix a new NULL pointer deref
> > in usb_serial_probe() that appeared after the recent kfifo changes (in short,
> > the kfifo changes modified the semantics of kfifo_alloc() that
> > usb_serial_probe() reiled on).
> 
> What semantic changed?  I thought that the kfifo patches came with
> patches that also fixed up any changed that were needed.  What went
> wrong here?

Previously write_fifo was allocated by kfifo_alloc() along with the structure
members.  Now kfifo_alloc() expects to get a pointer to existing structure.

> Does your patch solve the oops?

Sure, that's why I posted it. :-)

Rafael
