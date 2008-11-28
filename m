Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYK1KMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYK1KMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 05:12:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYK1KLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 05:11:51 -0500
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:44487 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYK1KLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 05:11:50 -0500
Date: Fri, 28 Nov 2008 02:11:49 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Matthew Wilcox <matthew@wil.cx>
cc: Alex Chiang <achiang@hp.com>, "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the	device
In-Reply-To: <20081127024204.GJ25548@parisc-linux.org>
Message-ID: <Pine.LNX.4.58.0811280151230.24816@shell4.speakeasy.net>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum>
 <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum>
 <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
 <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
 <20081127024204.GJ25548@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Matthew Wilcox wrote:
> On Wed, Nov 26, 2008 at 05:44:35PM -0800, Trent Piepho wrote:
> > Is there a reason you had to change it?  It breaks an existing interface.
> > It's clearly more inefficient and complicated to find a slot using it.  The
> > exiting PCI device name, like "0000:01:00.0", has been used in the sysfs
> > interface and with tools like lspci since forever.  Why should
> > /sys/bus/pci/slots use different names from /sys/bus/pci/devices for the
> > same device?
>
> Because fakephp was the odd one out.  Every other hotplug driver
> registers a slot number and puts the address in the directory.  We're
> making hotplug drivers simpler (by sharing more of the logic in the
> core) and so fakephp had to change to match the other drivers.  I'm
> sorry for your inconvenience, but it's necessary.

Seems like changing a long established interface like this should be put on
the feature removable schedule.

> We can discuss other ways to make your life better, but it can't be
> changed back to one 'slot' per PCI function.

Why not have a slot per pci function with each hotplug driver adding
attributes to the slot?  The slot would be registered by the hotplug core.

Is there any reason the fakephp driver should not be allowed to enable and
disable individual functions?  There a lot of mutli-function devices that
allow individual functions to be enabled and disabled with registers on the
primary function.  For instance, it would be possible to work around a BIOS
that doesn't have an option to disabled a southbridge's USB controller by
doing so in Linux and then using fakephp to remove the device, and thus
free address space that other devices might need.
