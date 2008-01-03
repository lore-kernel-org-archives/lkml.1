Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbYACDwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbYACDwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 22:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYACDwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 22:52:30 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:4085 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbYACDw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 22:52:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cKY1nV5l6WCUHLdw42UaXSnzhjJC7LkCUJP24CJvrCB/3hglV/NxEbClEU/N902rWqx1Fk3pQuSGJOahIZZsaTQUuOxETNaVov/sl1khY5lNHrg2t2g5A/oQSlms1MGJBOLXAHrHgxPputXA1W/2po/yxkfH2RsHcpiywhttY+E=
Message-ID: <386072610801021952t710db0f8pa2b435224d6926b@mail.gmail.com>
Date: Thu, 3 Jan 2008 11:52:27 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Cc: "David Brownell" <david-b@pacbell.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net,
       "Robin Getz" <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0801021556070.2990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801021225.28370.david-b@pacbell.net>
	 <Pine.LNX.4.44L0.0801021556070.2990-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 3, 2008 4:58 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 2 Jan 2008, David Brownell wrote:
>
> > On Wednesday 02 January 2008, Alan Stern wrote:
> > > On Wed, 2 Jan 2008, Mike Frysinger wrote:
> > >
> > > > perhaps the code size is arguable as to whether it really matters.
> > > > the reason we want it is that we have a USB host controller that will
> > > > not work with USB hubs, so we want to make sure the system does not
> > > > attempt such things.  (yes, such a USB host controller is retarded,
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
>

Hmmm, basically, I think the answer is yes.

But when you tell customers your devices support USB 2.0, they will
try to plug-in lots of USB devices that you can not even imagine.
If they plug-in a combo USB device including an external USB hub, the
whole embedded Linux system maybe crash or hang there.
So this patch is to refuse enumerate such unsupported USB devices.

-Bryan Wu
