Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYDRCva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYDRCva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 22:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYDRCvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 22:51:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855AbYDRCvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 22:51:22 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH update] firewire: fw-ohci: work around generation bug =?iso-8859-1?q?in=09TI_controllers?= (fix AV/C and more)
Date: Thu, 17 Apr 2008 22:51:05 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <tkrat.95472d87fa4e6c81@s5r6.in-berlin.de> <200804141330.22131.jwilson@redhat.com> <4807D374.8090608@s5r6.in-berlin.de>
In-Reply-To: <4807D374.8090608@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804172251.06018.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2008 06:47:16 pm Stefan Richter wrote:
> Jarod Wilson wrote:
> > On Saturday 12 April 2008 04:31:25 pm Stefan Richter wrote:
> >> +	ohci->bus_reset_packet_quirk = dev->vendor == PCI_VENDOR_ID_TI;
> >> +
> >
> > I have a few cards with PCI_VENDOR_ID_CREATIVE with a TI TSB41AB2 chip on
> > 'em (SoundBlaster Audigy w/FireWire port). I've not had any issues on any
> > of the cards I've got, but do we want to add them to the work-around list
> > just to be safe?
>
> No, we don't need to.  TSB41AB2 is only a PHY, not a link layer
> controller.  While the PHYs (the combination of PHYs which are present
> on the bus) influence the conditions under which the bug can happen, the
> cause for the bug is in the link layer controller alone.
>
> So unless Creative used a TI design in their link layer controller or
> otherwise managed to implement this same quirk as TI (Agere, NEC, and
> VIA didn't according to my tests so far), the presence of TSB41AB2 on a
> card does not make it necessary to activate the quirk workaround.

Ah, I'll have to take a closer look at these cards and see if I can figure out 
what drives the link layer... But barring the discovery of another TI chip, 
I'm assuming an attempt to reproduce the generation issue will be fruitless.

Well, based on the positive results we've seen thus far with TI controllers 
and this patch in Fedora kernels:

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
