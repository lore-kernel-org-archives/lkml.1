Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab0CHWRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:17:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42110 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755725Ab0CHWRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:17:32 -0500
Date: Mon, 8 Mar 2010 17:17:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] Driver core: don't initialize wakeup flags
In-Reply-To: <20100308220035.GA21390@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1003081711170.1297-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Greg KH wrote:

> On Mon, Mar 08, 2010 at 04:46:19PM -0500, Alan Stern wrote:
> > This patch (as1351) removes an unnecessary and unwanted assignment
> > from device_initialize().  The wakeup flags are set to 0 along with
> > everything else when the device structure is allocated, so we don't
> > need to do it again.  Furthermore, the subsystem might already have
> > set these flags to their correct values; we don't want to override it.
> 
> Does this solve a bug where a subsystem does do this already?  Or can it
> wait for 2.6.35?

It does not fix any existing bugs.

On the other hand, I have just submitted a separate patch adding 
remote-wakeup support for PNP devices (i8042 keyboard ports in 
particular) that depends on this one.  If you consider not waking up 
from suspend when keys are typed to be a bug, then the two patches 
together (plus a third that enables remote wakeup for the keyboard 
port by default) would count as a bug fix.

Or to put it differently, I'm waffling.  :-)

Alan Stern

