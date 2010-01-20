Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615Ab0ATWXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0ATWXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257Ab0ATWXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:23:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50472 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229Ab0ATWXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:23:22 -0500
Date: Wed, 20 Jan 2010 22:24:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Michael Breuer <mbreuer@majjas.com>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: [PATCH] sky2: Fix WARNING: at lib/dma-debug.c:902 check_sync
Message-ID: <20100120222414.57909d14@lxorguk.ukuu.org.uk>
In-Reply-To: <20100120094103.GA6225@ff.dom.local>
References: <20100120094103.GA6225@ff.dom.local>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Seems like an underlying bug in the DMA api. Maybe it just can't
> > handle operations on partial mapping.
> > 
> > Other drivers with same problem:
> >   bnx2, cassini, pcnet32, r8169, rrunner, skge, sungem, tg3, 
> 
> It seems using the same length (even without pci_unmap_len()) is
> crucial here, but I hope maintainers (added to CC) will take care.

The API needs fixing - if you've got a large mapping and you want to sync
part of it then we need to support that. Now it might well be that the
implementation on some braindead platform has to sync the entire thing,
and some implementations entire pages or cache lines.

You can't fix this in the drivers, they requested a service and they
don't have enough information nor is it their job to know about all the
platform specific rules.

Alan
