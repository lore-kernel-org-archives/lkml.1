Return-Path: <linux-kernel-owner+w=401wt.eu-S941128AbXGTQOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941128AbXGTQOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbXGTQOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:14:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761355AbXGTQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:14:12 -0400
Date: Fri, 20 Jul 2007 09:12:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: pata_platform: Fix NULL pointer dereference
In-Reply-To: <20070720035058.25300.28389.sendpatchset@clockwork.opensource.se>
Message-ID: <alpine.LFD.0.999.0707200910020.27249@woody.linux-foundation.org>
References: <20070720035058.25300.28389.sendpatchset@clockwork.opensource.s
 e>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jul 2007, Magnus Damm wrote:
> 
> pata_platform currently dereferences a NULL pointer in pata_platform_probe()
> if pdev->dev.platform_data is set to NULL. This breakage was most likely
> introduced by commit 5f45bc50976ee1f408f7171af155aec646655a37.

Ok, the *fix* looks real enough, but it seems that you have done your line 
splitting with a word processor rather than with a source code editor:

> +	return ata_host_activate(host, platform_get_irq(pdev, 0),
> +				 ata_interrupt, pp_info ? pp_info->irq_flags
> +				 : 0, &pata_platform_sht);

Please don't do things like this. Splitting up expressions across two 
lines just to make the line length come out "right" is silly.

So do the

	"pp_info ? pp_info->irq_flags : 0"

expression on one line.

And if it means that the line is longe rthan 80 characters, then so be it. 
It's ok. It's still more readable than the alternative.

			Linus "nit-picking bastard" Torvalds
