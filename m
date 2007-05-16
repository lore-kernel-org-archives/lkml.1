Return-Path: <linux-kernel-owner+w=401wt.eu-S1761734AbXEPMtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734AbXEPMtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 08:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbXEPMtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 08:49:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44186 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758236AbXEPMtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 08:49:46 -0400
Date: Wed, 16 May 2007 13:52:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vasily Averin <vvs@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: [patch i2o 5/6] i2o_proc files permission
Message-ID: <20070516135245.45b4b2db@the-village.bc.nu>
In-Reply-To: <464A8F7D.2090409@sw.ru>
References: <4649AA6C.2080808@sw.ru>
	<4649ABC9.6020605@sw.ru>
	<20070515174533.1caf24bb@the-village.bc.nu>
	<464A8F7D.2090409@sw.ru>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We have i2o on one of our testnodes: Adaptec Zero channel RAID 2010S integrated
> on MSI MS-9136 motherboard and I don't have access to another i2o hardware.
> Also I don't have any ideas how to detect buggy i2o node. As far as I understand
> Markus is right, and i2o hardware couldn't handle received message that on the
> first glance looks correctly.
> >From my POV it is bug in firmware and only vendor is able to fix it correctly.
> My patch is not a fix but workaround only -- it just do not allow to crash the
> node by any user in case when node admin due some reasons has loaded i2o_proc
> module.

It merely allows it to occur by accident if root does something like find
in the wrong place and it also breaks the expected behaviour for existing
systems.

There are two ways you can identify a specific controller if the vendor
didn't totally screw up

The first is the PCI idents or subidents, the second is to look at the
tables returned when the controller is being set up. In fact the
Adaptecrap controllers (ex DPT) are already detected and we set
c->adaptec in pci.c so we can stop them exploding for other reasons and
to use some extensions they have.

Thus I think the right solution is to skip registering those proc files
(and unregistering them on unload) if c->adaptec is set.
