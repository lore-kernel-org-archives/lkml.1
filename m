Return-Path: <linux-kernel-owner+w=401wt.eu-S965123AbZLGWBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123AbZLGWBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965102AbZLGWBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:01:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40037 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965068AbZLGWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:01:08 -0500
Date: Mon, 7 Dec 2009 17:01:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <alpine.LFD.2.00.0912071337020.3560@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0912071652040.15701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Linus Torvalds wrote:

> On Mon, 7 Dec 2009, Alan Stern wrote:
> > 
> > It only seems that way because you didn't take into account devices 
> > that suspend synchronously but whose children suspend asynchronously.
> 
> But why would I care? If somebody suspends synchronously, then that's what 
> he wants.

It doesn't mean he wants to block unrelated devices from suspending 
asynchronously, merely because they happen to come earlier in the list.

> > A synchronous suspend routine for a device with async child suspends
> > would have to look just like your usb_node_suspend():
> 
> Sure. But that sounds like a "Doctor, it hurts when I do this" situation. 
> Don't do that.
> 
> Make the USB host controller do its suspend asynchronously. We don't 
> suspend PCI bridges anyway, iirc (but I didn't actually check). And at 
> worst, we can make the PCI _bridges_ know about async suspends, and solve 
> it that way - without actually making any normal PCI drivers do it.

This sounds suspiciously like pushing the problem up a level and 
hoping it will go away.  (Sometimes that even works.)

In the end it isn't a very big issue.  Using one vs. two passes in 
dpm_suspend() is pretty unimportant.

Alan Stern

P.S.: In fact I planned all along to handle USB host controllers 
asynchronously anyway, since their resume routines contain some long 
delays.  I was merely using them as an example.

