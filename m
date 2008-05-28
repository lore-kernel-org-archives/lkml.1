Return-Path: <linux-kernel-owner+w=401wt.eu-S1760497AbYE1AGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbYE1AGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 20:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758097AbYE1AFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 20:05:53 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:31275 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757963AbYE1AFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 20:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Mg58jgAdFSWe57yfdt96eu9PgsHr6RykRjLCf5FQ8XP78EDvlmsya3nIc8QhZbsNQAOylRlDMdB1CJqXr1+QG4ht0ymU8+b26pnJcLKPXcolkU49dsaH/N6fK/hJHtz0SStRrrobP9ODPndjUAIPPtPGGEKrfgFzVtcmLADUeP0=
Message-ID: <31e679430805271705o3f93e3ccoaa505bf5691b55e3@mail.gmail.com>
Date: Wed, 28 May 2008 03:05:47 +0300
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: HAVE_CLK (for <linux/clk.h> support)
Cc: "Felipe Balbi" <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805271614.55233.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805231044.59969.david-b@pacbell.net>
	 <1211879340-22013-1-git-send-email-felipe.balbi@nokia.com>
	 <200805271614.55233.david-b@pacbell.net>
X-Google-Sender-Auth: 2abfbe9e0fd24e37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 2:14 AM, David Brownell <david-b@pacbell.net> wrote:

[snip]

> --- g26.orig/drivers/usb/musb/Kconfig   2008-05-27 16:02:41.000000000 -0700
> +++ g26/drivers/usb/musb/Kconfig        2008-05-27 16:01:09.000000000 -0700
> @@ -8,7 +8,7 @@ comment "Enable Host or Gadget support t
>
>  # (M)HDRC = (Multipoint) Highspeed Dual-Role Controller
>  config USB_MUSB_HDRC
> -       depends on USB || USB_GADGET
> +       depends on HAVE_CLK && (USB || USB_GADGET)
>        select TWL4030_USB if MACH_OMAP_3430SDP
>        tristate 'Inventra Highspeed Dual Role Controller (TI, ...)'
>        help

Sorry, another comment.

Instead of making the driver dependant on HAVE_CLK (which would be
true for virtually any driver comming from linux-omap), you could make
clk_enable a nop in case arch doesn't HAVE_CLK. How does that sound?

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
