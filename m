Return-Path: <linux-kernel-owner+w=401wt.eu-S1762946AbYF3Tqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762946AbYF3Tqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYF3Tqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:46:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34546
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbYF3Tql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:46:41 -0400
Date: Mon, 30 Jun 2008 12:46:41 -0700 (PDT)
Message-Id: <20080630.124641.13641106.davem@davemloft.net>
To: chas@cmf.nrl.navy.mil
Cc: dwmw2@infradead.org, netdev@vger.kernel.org,
       linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-ATM-General] [PATCH] firmware: convert Ambassador ATM
 driver to request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200806301610.m5UGAlqr025302@cmf.nrl.navy.mil>
References: <1214837678.10393.345.camel@pmac.infradead.org>
	<200806301610.m5UGAlqr025302@cmf.nrl.navy.mil>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
Date: Mon, 30 Jun 2008 12:10:47 -0400

> In message <1214837678.10393.345.camel@pmac.infradead.org>,David Woodhouse writ
> es:
> >> i removed the #ifdef's from around MODULE_LICENSE().  there shouldnt
> >> be any need for #ifdef's around MODULE_FIRMWARE() either.
> >
> >Unless you put #ifdef CONFIG_SBUS around the
> >MODULE_FIRMWARE("sba200e_ecd.bin") you will be requesting that firmware
> >even on non-sbus machines. Likewise little-endian vs. big-endian on PCI.
> 
> does it?  i was under the impression that MODULE_FIRMWARE() just
> provides a hint that modinfo can read.  request_firmware() still
> the requestor for the firmware image.

And also, there are systems with both PCI and SBUS so we should
make sure we handle that properly here.
