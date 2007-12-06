Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbXLFRWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbXLFRWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 12:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbXLFRWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 12:22:40 -0500
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:24557 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750829AbXLFRWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 12:22:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Cy6cS2guJQ+3G4vTYz8rFOjQrOtZij2Qdbb3V7NgHqFKFVdISb3N/r5tO6jcUE06jQKcksh9gIVaSEvdABhMWbVX8MjunJn5+HyUwHaJwRGPxf53mTxC7DUe30qHm7BWbuXtzXrEpPCTQldXxZ3HdyI7Faawrv4UP6jy08vyBAg=  ;
X-YMail-OSG: o6zr3LUVM1mn2eDi46OEi1TIxubR_VqS.UxYQIiWf4ClXc33OLgCu3lI8TVlem4.dmV_euaZAw--
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] usb: at91_udc: correct hanging while disconnecting usb cable
Date: Thu, 6 Dec 2007 08:02:52 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Victor <linux@maxim.org.za>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4757D7F3.8040904@atmel.com>
In-Reply-To: <4757D7F3.8040904@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712060802.53229.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007, Nicolas Ferre wrote:
> Correct hanging while disconnecting the USB device 
> cable. Prevent a race between vbus and UDP interrupts.
> This bug was tracked on at91sam9260ek boards.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com> 
> ---
> 
> A usb resume interrupt was firing after the vbus 
> interrupt : the IP was then already stoped and not able 
> to deal with it (no more clock). A simple interrupt disabling 
> is ok as the "end of bus reset" irq is non maskable and ok 
> to resume the USB device IP.

Good, thanks for finding this.  The bug was reported
recently, and obviously can't be reproduced except on
boards which *have* a VBUS interrupt!

I've signed off on this and suggested Greg merge it
before the 2.6.24-final freeze.

- Dave
