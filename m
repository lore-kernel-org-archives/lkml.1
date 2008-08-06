Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbYHFAp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbYHFAp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYHFApG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:45:06 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:48957 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYHFApE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:45:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=A91ddbxldx7ly/g0FYOx6c754pU6a3sCAQc9HMHrItjQ+5uMkaCYFtJ8nKsFzffnOw
         vzrA8/Q8gdc6WKMW2IPi1eb4H1HbWb+1UL6vIaQgaQ1MZqDt+ANMor6AcGqUG1h81ZIp
         19xv7W3Ir74jPSJnNa+TEjmzaeVMIHwQMak/8=
Message-ID: <4898F3EA.7000507@gmail.com>
Date: Wed, 06 Aug 2008 09:44:26 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no> <fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no> <fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no> <48976168.3020804@shaw.ca> <20080804205508.20a3f917@lxorguk.ukuu.org.uk> <48977200.3050307@shaw.ca> <20080804220619.76b94ceb@lxorguk.ukuu.org.uk> <4898EE70.1030604@shaw.ca>
In-Reply-To: <4898EE70.1030604@shaw.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Here's my first cut at it. Compile tested only. This sets most controllers
> to use 32-bit PIO except for those which could potentially be on a real ISA
> or other 16-bit bus. It's a bit non-obvious what to do with some of the
> drivers, so input is welcome.
> 
> This implementation doesn't check the ata_id_has_dword_io at all, since it
> would only make a difference on controllers where we don't really want to
> use it anyway.
> 
> It seems like regardless of whether we do 32-bit by default or not the 32-bit
> data_xfer function should be added to libata core as we have several drivers
> which duplicate the same code currently..

Great, just some minor nitpicks as I don't have much idea about 16 bit ones.

> +unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
> +			       unsigned int buflen, int rw)
> +{
> +	struct ata_port *ap = dev->link->ap;
> +	void __iomem *data_addr = ap->ioaddr.data_addr;
> +	unsigned int words = buflen >> 2;

dwords maybe?

> +	unsigned int slop = buflen & 3;
> +
> +	/* Transfer multiple of 4 bytes */
> +	if (rw == READ)
> +		ioread32_rep(data_addr, buf, words);
> +	else
> +		iowrite32_rep(data_addr, buf, words);
> +
> +	/* Transfer trailing 1 byte, if any. */

1byte?

Thanks.

-- 
tejun
