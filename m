Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYC0FHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYC0FHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 01:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYC0FH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 01:07:29 -0400
Received: from eastrmmtao103.cox.net ([68.230.240.9]:53678 "EHLO
	eastrmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbYC0FH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 01:07:28 -0400
Date: Thu, 27 Mar 2008 01:07:26 -0400
From: Brad Sawatzky <brad+kernel@swatter.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial: fix regression in Visor/Palm OS module for
	kernels >= 2.6.24
Message-ID: <20080327050725.GC11011@enigma.swatter.net>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <20080327001557.GA16176@enigma.swatter.net> <Pine.LNX.4.44L0.0803262252420.21714-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0803262252420.21714-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008, Alan Stern wrote:

> On Wed, 26 Mar 2008, Brad Sawatzky wrote:
> 
> > On Wed, 26 Mar 2008, Oliver Neukum wrote:
> > 
> > > Am Mittwoch, 26. März 2008 03:32:43 schrieb Brad Sawatzky:
> > [ . . . ]
> > > > I suppose it's possible that the kernel is identifying 3 bulk endpoints
> > > > when there should only be 2 and there is some issue with the lower level
> > > > endpoint probe?
> > > 
> > > Send in "lsusb -v". Are you sure all devices have 3 endpoints?
[ . . . ]
> You did not understand Oliver's question.  Yes, your device has 3
> bulk-OUT endpoints (and 2 bulk-IN).  But do you know whether _all_
> Visor/Palm OS devices do?  If they don't, your patch will cause the
> driver to stop working when someone plugs in a device with only 2
> endpoints.

You're absolutely right -- a very legitimate point.

I only have one PalmOS USB device and can only provide data for that unit.
As mentioned in the initial post I think it is very suggestive that there is
a kernel bug report saying that both a Treo90 and a Treo750p that exhibited
identical symptoms.  I'd bet a beer that that the kernel also reports 3
bulk out endpoints for those devices, but I can't prove it.

I'm more concerned that the kernel is creating a bogus 3rd endpoint (for
all devices assigned to the so-called "handspring_device") when it should
not.  Any suggestions on how to check that with my particular unit?

I was hoping that whomever authored the original code (Greg?) might know
where the original num_bulk_out=2 value came from: reverse engineering,
best guess, or honest-to-god documentation from Palm?

FWIW, another option I considered was patching the test added in commit
063a2da8f01806906f7d7b1a1424b9afddebc443 to use '<=' instead of '!=' in the
obvious places.  That is, test if the usb-serial subsystem reports at least
as many endpoints as the device definition "requires" rather than checking
for an exact number.  That behaviour is closer to the pre-2.6.24 code (ie.
no check at all) and might be a better fix (provided this 3rd bulk-out
endpoint I'm seeing is 'real' and not due to a lower-level bug).

-- Brad
