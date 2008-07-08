Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYGHHWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYGHHWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 03:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYGHHWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 03:22:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43705 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751866AbYGHHWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 03:22:31 -0400
Date: Tue, 8 Jul 2008 07:49:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: david@lang.hm
Cc: David Miller <davem@davemloft.net>, mchan@broadcom.com,
       dwmw2@infradead.org, bastian@waldi.eu.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
Message-ID: <20080708074947.2734d71f@the-village.bc.nu>
In-Reply-To: <alpine.DEB.1.10.0807072028590.12950@asgard.lang.hm>
References: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
	<1215421413.3189.199.camel@shinybook.infradead.org>
	<1215456981.5532.20.camel@dell>
	<20080707.143803.99767036.davem@davemloft.net>
	<20080707221950.3dfba435@the-village.bc.nu>
	<alpine.DEB.1.10.0807072028590.12950@asgard.lang.hm>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> so make the firmware part of the module if the driver is compiled as a 
> module. this way if the driver (and firmware) end up not being used they 
> don't take up any space. this seems a lot simpler (as well as more 
> reliable) then adding a mandatory dependancy on a different userspace 
> tool.

For the majority of drivers that would be a serious regression as they
load the firmware when needed, which is not when loaded. In some cases
there are many sets of firmware and only one is needed according to the
device, and only needed once per device detect.

It might well make sense for tg3 although even there it seems most tg3
work fine without loading new firmware, and examples like aic7xxx where
the firmware and code must match.

Alan
