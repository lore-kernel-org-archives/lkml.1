Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYABSr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYABSr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYABSrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:47:19 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:43745 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752408AbYABSrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:47:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SWyXtqjz/aAMkgK8i4UEuzq6Y5LVv/QAORQoYshPlRkaKat9LPj+RzbJtp6PSROwDHJoRZcidk0MBiUfgqcgJP5/5bJuYE7jMmQ3ct5G08wx1cJA/NkwB5SWGfIXIA8q5RWY1FjB/rMBekHunIY1MR3satnk5AAMhPmxgfg07Oc=  ;
X-YMail-OSG: VUZKtrAVM1l9YPX8Bd7y0BQAFe5x2mPDwsnqHGWGT0AjXpeBr4iokXZjjjN6esZaNTmIzJCyEA--
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Wed, 2 Jan 2008 10:47:15 -0800
User-Agent: KMail/1.9.6
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <200801020948.51310.rgetz@blackfin.uclinux.org>
In-Reply-To: <200801020948.51310.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021047.16036.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Robin Getz wrote:
> From: Robin Getz <rgetz@blackfin.uclinux.org>
> 
> Allow embedded developers to turn support for USB Hubs off even if they have a 
> full root hub. This saves the overhead (RAM and Flash size).

ISTR that it won't save very much code though ... the Linux USB
stack structures all its enumeration logic around hubs.


> Allow embedded developers the capabilities of the "otg_whitelist.h" - a 
> product whitelist, so USB peripherals not listed there will be rejected 
> during enumeration. This is the desired operation for many embedded products.
> 
> Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>

This is probably the right thing to do.  Correct me if I'm wrong,
but USB-IF recently put out some specs about "embedded hosts" which
basically boil down to saying you can adopt the same functionality
restrictions that used to be OTG-only.  Which is why now there are
embedded developers who'd like this option.  :)

- Dave



> 
> ---
> 
>  drivers/usb/core/Kconfig |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> 
> Index: linux-2.6.x/drivers/usb/core/Kconfig
> ===================================================================
> --- linux-2.6.x/drivers/usb/core/Kconfig	(revision 4074)
> +++ linux-2.6.x/drivers/usb/core/Kconfig	(working copy)
> @@ -95,8 +95,9 @@
>  
>  config USB_OTG_WHITELIST
>  	bool "Rely on OTG Targeted Peripherals List"
> -	depends on USB_OTG
> -	default y
> +	depends on USB_OTG || EMBEDDED
> +	default y if USB_OTG
> +	default n if EMBEDDED
>  	help
>  	  If you say Y here, the "otg_whitelist.h" file will be used as a
>  	  product whitelist, so USB peripherals not listed there will be
> @@ -111,7 +112,7 @@
>  
>  config USB_OTG_BLACKLIST_HUB
>  	bool "Disable external hubs"
> -	depends on USB_OTG
> +	depends on USB_OTG || EMBEDDED
>  	help
>  	  If you say Y here, then Linux will refuse to enumerate
>  	  external hubs.  OTG hosts are allowed to reduce hardware
> 
