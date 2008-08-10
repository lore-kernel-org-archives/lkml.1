Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYHJMZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYHJMZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 08:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYHJMZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 08:25:14 -0400
Received: from cpsmtpo-eml05.kpnxchange.com ([213.75.38.154]:24239 "EHLO
	cpsmtpo-eml05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbYHJMZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 08:25:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Grant Coady <grant_lkml@dodo.com.au>
Subject: Re: Query: should 'Marvell SATA support' depend on PCI?
Date: Sun, 10 Aug 2008 14:24:58 +0200
User-Agent: KMail/1.9.9
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
References: <vg3t941ebudmtb8afj82thuldug82ak1fs@4ax.com>
In-reply-To: <vg3t941ebudmtb8afj82thuldug82ak1fs@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808101424.59011.elendil@planet.nl>
X-OriginalArrivalTime: 10 Aug 2008 12:25:11.0813 (UTC) FILETIME=[227C7B50:01C8FAE4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Coady wrote:
> I was reworking the ATA driver menu patch to shrink it (merge 'depends
> on' lines) and noticed that the:
> 
> config SATA_MV
>         tristate "Marvell SATA support (HIGHLY EXPERIMENTAL)"
>         depends on EXPERIMENTAL
>         help
>           This option enables support for the Marvell Serial ATA family.
>           Currently supports 88SX[56]0[48][01] chips.
> 
> doesn't have 'depends on PCI && EXPERIMENTAL' like other drivers around
> it, this is okay or should it also depend on PCI?

AFAICT it should not as it can also be implemented as a platform device.

I have SATA_MV on a QNAP TS-109 NAS dervice (arm) and lspci on that gives me:
$ lspci
00:00.0 Memory controller: Marvell Technology Group Ltd. Device 5182 (rev 02)
01:00.0 Memory controller: Marvell Technology Group Ltd. Device 5182 (rev 02)

So the disk controller is not on the PCI bus.
And in /sys/ I see sata_mv listed under devices/platform/.


Cheers,
FJP
