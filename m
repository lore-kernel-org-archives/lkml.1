Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbZKWS2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbZKWS2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZKWS2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:28:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58673
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbZKWS17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:27:59 -0500
Date: Mon, 23 Nov 2009 10:28:17 -0800 (PST)
Message-Id: <20091123.102817.157628485.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: drivers/ide/au1xxx-ide.c: use resource_size()
From: David Miller <davem@davemloft.net>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901EE5BFD@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5BFD@mi8nycmail19.Mi8.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H Hartley Sweeten" <hartleys@visionengravers.com>
Date: Mon, 23 Nov 2009 13:15:32 -0500

> Use resource_size() for {request/release}_mem_region and ioremap.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Applied to ide-next-2.6, thanks.

>  
> -	ahwif->regbase = (u32)ioremap(res->start, res->end - res->start + 1);
> +	ahwif->regbase = (u32)ioremap(res->start, resource_size(res));
>  	if (ahwif->regbase == 0) {
>  		ret = -ENOMEM;
>  		goto out;

That needs some fixing.  ioremap()'s return value is an
"__iomem" pointer, not an integer.  ->regbase's type should be
changed to something like "void __iomem *" etc.
