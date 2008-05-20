Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbYETQsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbYETQsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756609AbYETQs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:48:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55068 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756152AbYETQs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:48:28 -0400
Date: Tue, 20 May 2008 12:48:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Brownell <david-b@pacbell.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <nico@cam.org>
Subject: Re: [PATCH] Re: [Bug #10713] ehci splatter in 2.6.26-rc2
In-Reply-To: <20080520105054.GA23368@xi.wantstofly.org>
Message-ID: <Pine.LNX.4.44L0.0805201247180.2114-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Lennert Buytenhek wrote:

> This patch appears to fix it:
> 
> 
> The Orion EHCI root hub does have a built-in Transaction Translator.
> 
> Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
> 
> Index: linux-2.6.26-rc3/drivers/usb/host/ehci-orion.c
> ===================================================================
> --- linux-2.6.26-rc3.orig/drivers/usb/host/ehci-orion.c
> +++ linux-2.6.26-rc3/drivers/usb/host/ehci-orion.c
> @@ -115,6 +115,8 @@ static int ehci_orion_setup(struct usb_h
>  	if (retval)
>  		return retval;
>  
> +	hcd->has_tt = 1;
> +
>  	ehci_reset(ehci);
>  	ehci_port_power(ehci, 0);

A similar change is needed in other bus-glue files.  I have put 
together a patch to take care of them all; it will be posted later 
today.

Alan Stern

