Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbXIFAeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbXIFAeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 20:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbXIFAeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 20:34:01 -0400
Received: from mobileweb01.london.02.net ([193.113.235.167]:55153 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755231AbXIFAeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 20:34:01 -0400
X-Greylist: delayed 608 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 20:33:57 EDT
Date: Thu, 6 Sep 2007 01:39:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Jeff Norden <jeff@math.tntech.edu>, alan@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] pata_it821x: fix lost interrupt with atapi devices
Message-ID: <20070906013929.1621849d@the-village.bc.nu>
In-Reply-To: <18141.42848.537873.349518@alkaid.it.uu.se>
References: <200709041607.l84G7KsT032647@norden.math.tntech.edu>
	<18141.42848.537873.349518@alkaid.it.uu.se>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

/from the media. */
>  > +	if (qc->nbytes < 2048)
>  > +		return -EOPNOTSUPP;
>  > +
>  >  	/* No ATAPI DMA in smart mode */
>  >  	if (itdev->smart)
>  >  		return -EOPNOTSUPP;
>  > 
> 
> This looks like a gross hack. Aren't you supposed to inspect
> the command instead and whitelist the ones you know are OK,
> like pata_pdc2027x.c and sata_promise.c do?

It does seem to be about transfer size in the IT821x case not commands.
It may be to do with how we issue ATAPI command transfer sizes from high
up (patch went to Jeff) but for now this is definitely the right approach

Reviewed-by: Alan Cox <alan@redhat.com>
