Return-Path: <linux-kernel-owner+w=401wt.eu-S933263AbXBWWEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbXBWWEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933267AbXBWWEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:04:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:54627 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263AbXBWWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=naQycCiq0hjyGHZogylT49721sjGx0Yl7KjftGvI+igG4+yMCbrXjY5bsfdXWWqTLnpNnx7AHp2yC541aLNfpC1ILQcLdnAvAUbFCwlGlG4tV7UFrng0Oalum4/mjIGHFK+oGXPGc1dvak8UezaxO+/lPbUV3PeQmpoXEfcXWOE=
Date: Sat, 24 Feb 2007 01:05:02 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sacher Khoudari <Sacher.Khoudari@stud.uni-heidelberg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: isapnp: broken API
Message-ID: <20070223220502.GA5599@martell.zuzino.mipt.ru>
References: <20070223162505.rdtobeij48o40sow@wwwmail.urz.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223162505.rdtobeij48o40sow@wwwmail.urz.uni-heidelberg.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 04:25:05PM +0100, Sacher Khoudari wrote:
> I've lately tried to run a ISA card (HP 82341, with drivers from the
> Linux GPIB project, latest version), but the module failed to get
> loaded. Modprobe said it couldn't find a symbol (Undefined symbol
> 'isapnp_read_byte'), although it was present in /boot/System.map and
> /proc/kallsyms. After some googleing, trying to compile a new kernel,
> looking into code, etc, I found out what the problem was. The function
> "isapnp_read_byte" was no longer been exported. You can find the line
> in question here [1] (note the #if 0). The patch that did this change
> was this [2] one.
>
> I'm not sure, but as I understand it, it was not intended to comment
> this EXPORT_SYMBOLS(isapnp_read_byte) out. So it probably just
> happened by accident?

No. It was unexported because no modular code in mainline was using it.

> [1] http://www.gelato.unsw.edu.au/lxr/source/drivers/pnp/isapnp/core.c#L948
> [2] http://lkml.org/lkml/2005/6/20/307

> --- linux-2.6.20.1/drivers/pnp/isapnp/core.c.old
> +++ linux-2.6.20.1/drivers/pnp/isapnp/core.c
> @@ -943,9 +943,7 @@
>  EXPORT_SYMBOL(isapnp_present);
>  EXPORT_SYMBOL(isapnp_cfg_begin);
>  EXPORT_SYMBOL(isapnp_cfg_end);
> -#if 0
>  EXPORT_SYMBOL(isapnp_read_byte);
> -#endif
>  EXPORT_SYMBOL(isapnp_write_byte);

