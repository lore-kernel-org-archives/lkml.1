Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295Ab0AJPdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0AJPdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 10:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729Ab0AJPde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 10:33:34 -0500
Received: from bamako.nerim.net ([62.4.17.28]:56655 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab0AJPdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 10:33:33 -0500
Date: Sun, 10 Jan 2010 16:33:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: Re: [PATCH] i2c: make PCI device id constant
Message-ID: <20100110163331.0fca7abf@hyperion.delvare>
In-Reply-To: <4B49E524.1090404@freemail.hu>
References: <4B49E524.1090404@freemail.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Márton,

On Sun, 10 Jan 2010 15:33:08 +0100, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> The id_table field of the struct pci_driver is constant in <linux/pci.h>
> so it is worth to make initialization data also constant.
> 
> The semantic match that finds this kind of pattern is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> disable decl_init,const_decl_init;
> identifier I1, I2, x;
> @@
> 	struct I1 {
> 	  ...
> 	  const struct I2 *x;
> 	  ...
> 	};
> @s@
> identifier r.I1, y;
> identifier r.x, E;
> @@
> 	struct I1 y = {
> 	  .x = E,
> 	};
> @c@
> identifier r.I2;
> identifier s.E;
> @@
> 	const struct I2 E[] = ... ;
> @depends on !c@
> identifier r.I2;
> identifier s.E;
> @@
> +	const
> 	struct I2 E[] = ...;
> // </smpl>
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> Cc: Julia Lawall <julia@diku.dk>
> Cc: cocci@diku.dk
> ---

Applied, thanks.

-- 
Jean Delvare
