Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbYHTK3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbYHTK3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYHTK3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:29:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53228 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751593AbYHTK3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:29:23 -0400
Date: Wed, 20 Aug 2008 11:11:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 05/10] ldisc: new dcd_change() method for line
 disciplines.
Message-ID: <20080820111117.0113da05@lxorguk.ukuu.org.uk>
In-Reply-To: <20080820085303.GA17591@tekkaman>
References: <1219182612-13814-1-git-send-email-giometti@linux.it>
	<1219182612-13814-2-git-send-email-giometti@linux.it>
	<1219182612-13814-3-git-send-email-giometti@linux.it>
	<1219182612-13814-4-git-send-email-giometti@linux.it>
	<1219182612-13814-5-git-send-email-giometti@linux.it>
	<1219182612-13814-6-git-send-email-giometti@linux.it>
	<20080819225322.69f3215d@lxorguk.ukuu.org.uk>
	<20080819224930.GI21330@tekkaman>
	<20080819233857.41b756cc@lxorguk.ukuu.org.uk>
	<20080819230523.GJ21330@tekkaman>
	<20080820085303.GA17591@tekkaman>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> #ifdef CONFIG_PPS_IRQ_EVENTS
>                 ts = pps_irq_ts[port->irq];
> #else

That bit won't work very shortly - IRQ numbers are going sparse not a
single simple NR_IRQ array.

> This completely hides the (dirty) trick to the PPS clients and allow
> using struct tty_struct as first parameter.

Can we get the basics right first - drop the IRQ_EVENTS and HARDPPS
hackery out of the patchset and the core code then looks quite clean.
After that is sorted/merged we can come back to working out the best way
to improve the IRQ and HARDPPS hacks.

Alan
