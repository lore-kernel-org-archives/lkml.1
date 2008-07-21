Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYGUTuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYGUTuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 15:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYGUTuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 15:50:00 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60653 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYGUTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 15:49:59 -0400
Date: Mon, 21 Jul 2008 13:49:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Eran Liberty <liberty@extricom.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, eran.liberty@gmail.com
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
Message-ID: <20080721194957.GH24246@parisc-linux.org>
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4884E0FB.9010909@extricom.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 10:18:19PM +0300, Eran Liberty wrote:
> Dear Penguins,
> 
> As a follow up on my own post ( http://lkml.org/lkml/2008/6/18/195 ), I
> have  solved a small bug/misbehavior within the pci_scan_single_device().

To quote your original post here for ease of replying:

> 1. Calling pci_remove_bus_device() on some of the devices on a bus will 
> remove them. (ok)
> 2. Calling pci_scan_child_bus() on that bus will scan the bus for 
> devices and add them all. even the ones already in the bus device list, 
> which will now be duplicated in the bus device list! (no so ok)

I think this is your real problem, that you're rescanning the entire
bus.  I don't think that's the route we'd recommend taking.

Why don't you call pci_scan_slot() instead?  You won't get the benefit of
pcibios_fixup_bus(), but I'm not convinced that's safe to call on a bus
that's already been scanned.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
