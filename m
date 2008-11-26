Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYKZEr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYKZEr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 23:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYKZErS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 23:47:18 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:45228 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbYKZErS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 23:47:18 -0500
Date: Tue, 25 Nov 2008 20:46:37 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: "Darrick J. Wong" <djwong@us.ibm.com>
cc: Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the device
In-Reply-To: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, Darrick J. Wong wrote:
> For PCI devices, pci_bus_assign_resources() must be called to set up the
> pci_device->resource array before pci_bus_add_devices() can be called, else
> attempts to load drivers results in BAR collision errors where there are none.

I've had a patch to fakephp that did something like this for a while, but I
called pci_bus_assign_resources() _after_ adding the devices with calls to
pci_bus_add_device().  It seems like that might be easier, to just add all
the devices and then call pci_bus_assign_resources() when done.  It appears
to work fine for me.  Is there a reason this is wrong?
