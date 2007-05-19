Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbXESWD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbXESWD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbXESWDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:03:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58364 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbXESWDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:03:47 -0400
Message-ID: <464F7440.10900@garzik.org>
Date: Sat, 19 May 2007 18:03:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] sata_sil: Greatly improve DMA support
References: <20070519053532.GA32522@havoc.gtf.org> <1441.81.207.0.53.1179591630.squirrel@secure.samage.net>
In-Reply-To: <1441.81.207.0.53.1179591630.squirrel@secure.samage.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:
> This patch seems to work with my SiI 3512, though I don't notice any
> difference, neither a speedup, nor a slowdown. Hdparm gives the same
> speeds (-tT), and cp -a'ing kernel sources is abysmal slow in both cases,
> (need to look into that one) so I didn't really test it that well.


It won't result in much of a speedup, except in situations where IOMMU 
or other situation that causes you to run into the 64k boundary being an 
issue -- generally only on huge transfers.

A good measure is to dd(1) to/from the block device, rather than using a 
filesystem.  As has been shown on LKML, the filesystem can really slow 
things down in some cases.

	Jeff


