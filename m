Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZINKfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZINKfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZINKfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:35:45 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:53725 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZINKfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:35:44 -0400
Message-ID: <4AAE1C48.6030802@csr.com>
Date: Mon, 14 Sep 2009 11:34:48 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: Roman Zippel <zippel@linux-m68k.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: UWB Kconfig: cannot set UWB to N in gconfig
References: <1252577154.2340.12.camel@castor>
In-Reply-To: <1252577154.2340.12.camel@castor>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Sep 2009 10:34:48.0821 (UTC) FILETIME=[FC1C1A50:01CA3526]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:
> I sometimes use 'make gconfig' and I noticed that I cannot disable the
> UWB option -- it just won't let me set it to N.
> 
> AFAICT this is because the CONFIG USB_WUSB selects UWB which forces it
> on.
> applying this patch fixes the issue but I'm not sure if this is the
> right way to go about it.
> 
> any thoughts?
> 
> regards
> Richard
> 
> This is against 2.6.31
> 
> 
> diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
> index eb09a0a..cc97041 100644
> --- a/drivers/usb/wusbcore/Kconfig
> +++ b/drivers/usb/wusbcore/Kconfig
> @@ -5,7 +5,7 @@ config USB_WUSB
>  	tristate "Enable Wireless USB extensions (EXPERIMENTAL)"
>  	depends on EXPERIMENTAL
>  	depends on USB
> -        select UWB
> +        depends on UWB

NAK.  It's not sufficiently obvious to a user that Wireless USB support
requires UWB.

This is really an issue with the configuration application.  Consider
improving them to allow switching off select'ed options and popping up a
dialog that says "switching off UWB will also switch off WUSB" etc.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
