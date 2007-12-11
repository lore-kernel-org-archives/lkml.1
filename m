Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbXLKNZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbXLKNZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXLKNZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:25:32 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34453 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752289AbXLKNZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:25:31 -0500
Date: Tue, 11 Dec 2007 13:19:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: linux-pcmcia@lists.infradead.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 1/6] pcmcia/3c574_cs: Fix dubious bitfield warning
Message-ID: <20071211131936.3379f2af@the-village.bc.nu>
In-Reply-To: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
References: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 05:32:38 +0100 (MET)
Richard Knutsson <ricknu-0@student.ltu.se> wrote:

> Fixing:
>   CHECK   drivers/net/pcmcia/3c574_cs.c
> drivers/net/pcmcia/3c574_cs.c:194:13: warning: dubious bitfield without explicit `signed' or `unsigned'
> drivers/net/pcmcia/3c574_cs.c:196:14: warning: dubious bitfield without explicit `signed' or `unsigned'
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Is there a reason for not doing it this way?

How is the endianness handled here (I suspect its always been broken)

> diff --git a/drivers/net/pcmcia/3c574_cs.c b/drivers/net/pcmcia/3c574_cs.c
> index ad134a6..97b6daa 100644
> --- a/drivers/net/pcmcia/3c574_cs.c
> +++ b/drivers/net/pcmcia/3c574_cs.c
> @@ -190,10 +190,10 @@ enum Window3 {			/* Window 3: MAC/config bits. */
>  union wn3_config {
>  	int i;
>  	struct w3_config_fields {
> -		unsigned int ram_size:3, ram_width:1, ram_speed:2, rom_size:2;
> -		int pad8:8;
> -		unsigned int ram_split:2, pad18:2, xcvr:3, pad21:1, autoselect:1;
> -		int pad24:7;
> +		u8 ram_size:3, ram_width:1, ram_speed:2, rom_size:2;
> +		u8 pad8;
> +		u8 ram_split:2, pad18:2, xcvr:3, pad21:1;
> +		u8 autoselect:1, pad24:7;

Just changing the int pad to unsigned int pad would be safer in terms of
not causing changes. Simply delcaring a 32bit field and bit masks to
and/or into it is probably a lot saner in the general case.
