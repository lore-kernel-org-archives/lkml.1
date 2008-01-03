Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYACRI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYACRI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYACRIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:08:48 -0500
Received: from outbound-mail-12.bluehost.com ([69.89.18.112]:35882 "HELO
	outbound-mail-12.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753022AbYACRIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:08:47 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 12:08:47 EST
From: "Richard D" <richard@embunus.com>
To: "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'David Brownell'" <david-b@pacbell.net>
Cc: "'Mike Frysinger'" <vapier.adi@gmail.com>, <gregkh@suse.de>,
       <linux-usb-devel@lists.sourceforge.net>,
       "'Robin Getz'" <rgetz@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>
References: <200801021225.28370.david-b@pacbell.net> <Pine.LNX.4.44L0.0801021556070.2990-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801021556070.2990-100000@iolanthe.rowland.org>
Subject: RE: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Thu, 3 Jan 2008 22:31:54 +0530
Message-ID: <001b01c84e2a$60558730$21009590$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AchNgwDTSU/J9nGuQRe+GG9JFKtNlwApsNxg
Content-Language: en-us
X-Identified-User: {2260:host187.hostmonster.com:embunusc:embunus.com} {sentby:bopbeforesmtp 121.247.188.187 authed with embunus.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Alan Stern
> Sent: Thursday, January 03, 2008 2:29 AM
> To: David Brownell
> Cc: Mike Frysinger; gregkh@suse.de; linux-usb-
> devel@lists.sourceforge.net; Robin Getz; linux-kernel@vger.kernel.org
> Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB
> options normally reserved for OTG
> 
> On Wed, 2 Jan 2008, David Brownell wrote:
> 
> > On Wednesday 02 January 2008, Alan Stern wrote:
> > > On Wed, 2 Jan 2008, Mike Frysinger wrote:
> > >
> > > > perhaps the code size is arguable as to whether it really
> matters.
> > > > the reason we want it is that we have a USB host controller that
> will
> > > > not work with USB hubs, so we want to make sure the system does
> not
> > > > attempt such things.  (yes, such a USB host controller is
> retarded,
> > > > but the decision was out of our hands.)
> > >
> > > Just out of curiosity, how does a host controller manage to avoid
> > > working with external hubs?
> >
> > The transaction translators in external high speed hubs require
> > hosts to issue particular USB transactions.  If the host controller
> > doesn't implement the that split transaction support, then it won't
> > be supporting external hubs.
> 
> So in theory one could connect a high-speed hub to such a host
> controller and expect it to communicate with high-speed devices.  So
> long as no full- or low-speed devices are added there wouldn't be any
> split transactions.  It wouldn't be USB-2.0 compliant but it should
> still work.


Perhaps we could reject any low/full speed devices after the USBV
enumeration phase itself. This would need perhaps a flag in the struct
hc_driver which the hub code (that does the enumeration) can check and
reject further enumeration?
Atleast this way we can support high speed devices.



