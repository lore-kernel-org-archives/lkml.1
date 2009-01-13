Return-Path: <linux-kernel-owner+w=401wt.eu-S1759872AbZAMJEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbZAMJEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbZAMJEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:04:09 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:39266 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759136AbZAMJEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:04:01 -0500
Date: Tue, 13 Jan 2009 10:03:57 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       sam@ravnborg.org, harvey.harrison@gmail.com, gorcunov@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] nubus.h: extern's make no sense in userspace
In-Reply-To: <1231832906.3212.24.camel@jaswinder.satnam>
Message-ID: <Pine.LNX.4.64.0901131001200.19352@vixen.sonytel.be>
References: <1231832906.3212.24.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Jaswinder Singh Rajput wrote:
> Impact: cleanup, Impact: fix 3 make headers_check warnings:
> 
> usr/include/linux/nubus.h:298: extern's make no sense in userspace
> usr/include/linux/nubus.h:300: extern's make no sense in userspace
> usr/include/linux/nubus.h:304: extern's make no sense in userspace
> 
> Also moved nubus_scan_bus() in __KERNEL__
> 
> Also removed obsolete get_nubus_list()
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/linux/nubus.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/nubus.h b/include/linux/nubus.h
> index bd31554..9f54a23 100644
> --- a/include/linux/nubus.h
> +++ b/include/linux/nubus.h
> @@ -297,6 +297,7 @@ struct nubus_dev {
>  	struct nubus_board* board;
>  };
>  
> +#ifdef __KERNEL__
>  /* This is all NuBus devices (used to find devices later on) */
>  extern struct nubus_dev* nubus_devices;
>  /* This is all NuBus cards */
> @@ -305,7 +306,7 @@ extern struct nubus_board* nubus_boards;
>  /* Generic NuBus interface functions, modelled after the PCI interface */
>  void nubus_scan_bus(void);
>  extern void nubus_proc_init(void);
> -int get_nubus_list(char *buf);
> +#endif /* __KERNEL__ */
>  int nubus_proc_attach_device(struct nubus_dev *dev);
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  int nubus_proc_detach_device(struct nubus_dev *dev);
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  /* If we need more precision we can add some more of these */

What about these? They (unfortunately) lack the "extern" keyword, but they're
still external declarations, and "make headers_check' doesn't notice them?

BTW, is there a way to tell gcc to warn about externs not marked "extern", so
we can fix all of them?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
