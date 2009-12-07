Return-Path: <linux-kernel-owner+w=401wt.eu-S965133AbZLGWCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965133AbZLGWCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965108AbZLGWCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:02:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965081AbZLGWCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:02:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Date: Mon, 7 Dec 2009 23:02:57 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0912071610520.15701-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912071337020.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912071337020.3560@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912072302.57318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Linus Torvalds wrote:
> 
> On Mon, 7 Dec 2009, Alan Stern wrote:
> > 
> > It only seems that way because you didn't take into account devices 
> > that suspend synchronously but whose children suspend asynchronously.
> 
> But why would I care? If somebody suspends synchronously, then that's what 
> he wants.
> 
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

BTW, I still don't quite understand why not to put the parent's down_write
operation into the core.  It's not going to hurt for the "synchronous" devices
and the "asynchronous" ones will need to do it anyway.

Also it looks like that's something to do unconditionally for all nodes
having children, because the parent need not know if the children do async
operations.

Rafael
