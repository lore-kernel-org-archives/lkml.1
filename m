Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbZJSPIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbZJSPIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 11:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932165AbZJSPIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 11:08:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54693 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932160AbZJSPIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 11:08:53 -0400
Date: Mon, 19 Oct 2009 11:08:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: nut-upsuser@lists.alioth.debian.org, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.4: USB/UPS connectivity issue on Intel DP55KG Motherboard
 [DEBUG logs included upsd/upsmon/usbhid-ups]
In-Reply-To: <alpine.DEB.2.00.0910181732550.4761@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.0910191100050.3899-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Oct 2009, Justin Piszcz wrote:

> Thanks Alan,
> 
> I have performed all of the steps you recommended, there is also a bug in
> the docs, the directory seems to be different, or at least if you have
> everything compiled into the kernel and not using modules.

> Start nut:
> # /etc/init.d/nut start
> Starting Network UPS Tools: upsdrvctl upsd upsmon.
> 
> Within ~20-30 seconds it already broke:
> ============================================================================
> Broadcast Message from nut@p34.internal.lan
>          (somewhere) at 17:22 ...

Well, the usbmon trace shows that wherever the problem lies, it isn't 
in the kernel.  There were a few problems in the device itself -- it 
was queried for a report and did not provide any data.  The nut program 
should be smart enough to retry when this happens, but it didn't.

It did try to re-establish communcation with the device, but it appears
that nut got caught in a loop during this attempt.  During this loop
nut did nothing but transfer a bunch of string descriptors from the
device, over and over again at 2-second intervals.  The loop lasted for
almost a minute, until another device error occurred.  Then nut
recovered properly -- until a third error happened and nut got stuck in
its loop again.

Alan Stern

