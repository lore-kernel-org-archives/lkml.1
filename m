Return-Path: <linux-kernel-owner+w=401wt.eu-S965083AbZLGVmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083AbZLGVmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965055AbZLGVmB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:42:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965024AbZLGVl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:41:57 -0500
Date: Mon, 7 Dec 2009 13:41:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <Pine.LNX.4.44L0.0912071610520.15701-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912071337020.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912071610520.15701-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Dec 2009, Alan Stern wrote:
> 
> It only seems that way because you didn't take into account devices 
> that suspend synchronously but whose children suspend asynchronously.

But why would I care? If somebody suspends synchronously, then that's what 
he wants.

> A synchronous suspend routine for a device with async child suspends
> would have to look just like your usb_node_suspend():

Sure. But that sounds like a "Doctor, it hurts when I do this" situation. 
Don't do that.

Make the USB host controller do its suspend asynchronously. We don't 
suspend PCI bridges anyway, iirc (but I didn't actually check). And at 
worst, we can make the PCI _bridges_ know about async suspends, and solve 
it that way - without actually making any normal PCI drivers do it.

		Linus
