Return-Path: <linux-kernel-owner+w=401wt.eu-S938314AbXGSPMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938314AbXGSPMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762090AbXGSPMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:12:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45104 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964805AbXGSPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:12:05 -0400
Date: Thu, 19 Jul 2007 16:18:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: TAKADA Yoshihito <takada@mbf.nifty.com>
Cc: linux-kernel@vger.kernel.org, teheo@novell.com
Subject: Re: i386: pata_cs5520 does not work
Message-ID: <20070719161821.5206ac36@the-village.bc.nu>
In-Reply-To: <20070719.190831.23015057.takada@mbf.nifty.com>
References: <20070716.091928.111205836.takada@mbf.nifty.com>
	<20070718144212.3289e86c@the-village.bc.nu>
	<20070719015806.8B09.TAKADA@mbf.nifty.com>
	<20070719.190831.23015057.takada@mbf.nifty.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> > rc = devm_request_irq(&pdev->dev, irq[ap->port_no],
> > 	ata_interrupt, 0, DRV_NAME, host);
> 
> devm_request_irq() is called twice from loop.
> In 1st time, ap->port_no is 0. devm_request_irq() is success.
> 2nd time, ap->port_no is 0 too. devm_request_irq() failed.

Looks like whoever updated it to the new probe mechanism didn't quite get
it right

Change it to use 

          struct ata_port *ap = host->ports[i];

not ports[0]

Alan
