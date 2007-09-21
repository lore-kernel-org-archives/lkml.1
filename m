Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbXIUO4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbXIUO4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758978AbXIUO4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:56:39 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:36663 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759048AbXIUO4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:56:38 -0400
Date: Fri, 21 Sep 2007 10:56:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Satyam Sharma <satyam@infradead.org>, Gilboa Davara <gilboad@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage.
Message-ID: <20070921145628.GE15697@goodmis.org>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain> <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com> <1189869329.18191.77.camel@gilboa-home-dev.localdomain> <1189879681.18191.93.camel@gilboa-home-dev.localdomain> <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in> <46F1314B.8040105@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F1314B.8040105@grupopie.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 03:25:15PM +0100, Paulo Marques wrote:
>
> if we change the interface from "print_symbol(fmt, addr)" to 
> "print_symbol(prefix, addr, int newline)" we can simply do:
>
> printk(prefix);
> printk_symbol(addr);
> if (newline)
> 	printk("\n");

NACK

I just wrote something that does "print_symbol(" %s)\n", addr);"
Notice the ")" in the output.

-- Steve

>
> where "printk_symbol" is a new function that does the same as 
> sprint_symbol, but does "printk" instead of "sprintf".
>
> This should reduce immensely the stack usage of print_symbol without the 
> need for locking.
>
> Of course this requires changing _all_ callers of print_symbol to use the 
> new interface, but these are less than 100 ;)
>
> Comments?
>
> -- 
> Paulo Marques - www.grupopie.com
>
> "You're just jealous because the voices only talk to me."
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
