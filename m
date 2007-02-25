Return-Path: <linux-kernel-owner+w=401wt.eu-S964848AbXBYMZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964848AbXBYMZP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964851AbXBYMZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:25:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43313 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964844AbXBYMZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:25:13 -0500
Date: Sun, 25 Feb 2007 13:28:55 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Komuro <komurojun-mbn@nifty.com>
Subject: Re: [PATCH] libata: clear drvdata in ata_host_release()
Message-ID: <20070225132855.324a0b36@lxorguk.ukuu.org.uk>
In-Reply-To: <45E0EB9F.3050001@garzik.org>
References: <20070224074823.GA20322@htj.dyndns.org>
	<45E0EB9F.3050001@garzik.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007 20:51:27 -0500
Jeff Garzik <jeff@garzik.org> wrote:

> Tejun Heo wrote:
> > ata_host_release() uses drvdata to determine ata_host to release and
> > clearing drvdata in ->remove_one causes NULL pointer deference.  Clear
> > drvdata only in ata_host_release() after all resources are freed.
> > 
> > This bug was first analyzed by Alan Cox for pata_pcmcia.
> > 
> > Signed-off-by: Tejun Heo <htejun@gmail.com>
> > Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > ---
> > Alan, this is the bug you talked about, right?  I took the fix from
> > "[BUG] PATA_PCMCIA does not work" and expanded it.  If this isn't the
> > one, please let me know.  Thanks.
> 
> Has a tester confirmed that this patch fixes the problem, and supercedes 
> Alan's patch?

It doesn't appear to, instead it fixes further cases.
