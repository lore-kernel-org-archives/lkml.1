Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbYKZHsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbYKZHsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYKZHsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:48:12 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54304 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbYKZHsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:48:11 -0500
Date: Tue, 25 Nov 2008 23:48:08 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the
	device
Message-ID: <20081126074808.GE6539@plum>
Reply-To: djwong@us.ibm.com
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com> <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixing cc/to list]

On Tue, Nov 25, 2008 at 08:46:37PM -0800, Trent Piepho wrote:
> 
> I've had a patch to fakephp that did something like this for a while, but I
> called pci_bus_assign_resources() _after_ adding the devices with calls to
> pci_bus_add_device().  It seems like that might be easier, to just add all
> the devices and then call pci_bus_assign_resources() when done.  It appears
> to work fine for me.  Is there a reason this is wrong?

afaict, pci_bus_add_devices calls device_add to set up sysfs files and
trigger a event that can (ultimately) cause a pci probe action to
happen... but the probe will fail because the resources aren't ready.
In any case, if a device shows up in sysfs I'd assume that to mean that
the device is ready to go--all the BARs are reserved for the device,
etc.  For sure, I woudn't expect to be racing
pci_bus_assign_resources().

--D
